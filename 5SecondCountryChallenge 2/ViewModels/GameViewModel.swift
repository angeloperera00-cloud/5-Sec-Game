import SwiftUI
import Combine

struct Question {
    let country: Country
    let options: [Country]
    let showFlag: Bool
}

enum AnswerState { case unanswered, correct, wrong, timeout }

final class GameViewModel: ObservableObject {

    // MARK: - Published
    @Published var currentQuestion:    Question?
    @Published var currentIndex:       Int = 0
    @Published var score:              Int = 0
    @Published var streak:             Int = 0
    @Published var bestStreak:         Int = 0
    @Published var timeRemaining:      Double = 5
    @Published var answerState:        AnswerState = .unanswered
    @Published var selectedAnswer:     Country? = nil
    @Published var isGameOver:         Bool = false
    @Published var correctCount:       Int = 0
    @Published var wrongCount:         Int = 0
    @Published var rushTimeRemaining:  Double = 60
    @Published var pointsEarned:       Int = 0
    @Published var isTransitioning:    Bool = false

    // MARK: - Config
    let mode: GameMode
    let difficulty: Difficulty

    // All modes auto-advance — practice removed
    var autoAdvance: Bool { true }

    private var questions:        [Question] = []
    private var countdownTimer:   Timer?
    private var rushTimer:        Timer?
    private var autoAdvanceTimer: Timer?
    private var answerTimestamp   = Date()
    private let storage = StorageManager.shared
    private let haptic  = HapticManager.shared

    // MARK: - Init
    init(mode: GameMode, difficulty: Difficulty) {
        self.mode = mode
        self.difficulty = difficulty
        self.timeRemaining = Double(storage.timerDuration)
        buildQuestions()
    }

    // MARK: - Build questions (no duplicates per round)
    private func buildQuestions() {
        var pool = CountryDatabase.countries(for: difficulty).shuffled()
        let limit = mode == .rush ? min(60, pool.count) : min(10, pool.count)
        pool = Array(pool.prefix(limit))

        let fullPool = CountryDatabase.countries(for: difficulty)

        questions = pool.map { country in
            let wrong = CountryDatabase.wrongOptions(for: country, in: fullPool)
            let opts  = ([country] + wrong).shuffled()
            let showFlag: Bool
            switch mode {
            case .flag:  showFlag = true
            case .map:   showFlag = false
            default:     showFlag = Bool.random()
            }
            return Question(country: country, options: opts, showFlag: showFlag)
        }
    }

    // MARK: - Game flow
    func startGame() {
        currentIndex = 0; score = 0; streak = 0; bestStreak = 0
        correctCount = 0; wrongCount = 0
        rushTimeRemaining = 60; isGameOver = false; isTransitioning = false
        loadQuestion(at: 0)
        if mode == .rush { startRushTimer() }
    }

    private func loadQuestion(at index: Int) {
        guard index < questions.count else { endGame(); return }
        isTransitioning = false
        currentQuestion = questions[index]
        answerState     = .unanswered
        selectedAnswer  = nil
        pointsEarned    = 0
        timeRemaining   = Double(storage.timerDuration)
        startCountdownTimer()
    }

    // MARK: - Timers
    private func startCountdownTimer() {
        stopCountdownTimer()
        answerTimestamp = Date()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.timeRemaining -= 0.05
                if self.timeRemaining <= 0 {
                    self.timeRemaining = 0
                    self.handleTimeout()
                }
            }
        }
    }

    private func stopCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }

    private func startRushTimer() {
        rushTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.rushTimeRemaining -= 0.1
                if self.rushTimeRemaining <= 0 {
                    self.rushTimeRemaining = 0
                    self.stopCountdownTimer()
                    self.stopAutoAdvanceTimer()
                    self.endGame()
                }
            }
        }
    }

    private func stopAutoAdvanceTimer() {
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = nil
    }

    private func stopAllTimers() {
        stopCountdownTimer()
        stopAutoAdvanceTimer()
        rushTimer?.invalidate()
        rushTimer = nil
    }

    // MARK: - Answer handling
    func selectAnswer(_ country: Country) {
        guard answerState == .unanswered, !isTransitioning else { return }
        stopCountdownTimer()
        selectedAnswer = country
        let elapsed = Date().timeIntervalSince(answerTimestamp)

        if country.id == currentQuestion?.country.id {
            answerState  = .correct
            correctCount += 1
            streak       += 1
            bestStreak    = max(bestStreak, streak)

            var pts = Int(100.0 * difficulty.multiplier)
            if elapsed < 2.0 { pts += Int(50.0 * difficulty.multiplier) }
            if streak >= 10      { pts += 250 }
            else if streak >= 5  { pts += 100 }
            else if streak >= 3  { pts += 50  }
            pointsEarned = pts
            score       += pts
            if storage.hapticEnabled { haptic.success() }
        } else {
            answerState  = .wrong
            wrongCount   += 1
            streak        = 0
            pointsEarned  = 0
            if storage.hapticEnabled { haptic.error() }
        }

        scheduleAutoAdvance()
    }

    private func handleTimeout() {
        guard answerState == .unanswered, !isTransitioning else { return }
        stopCountdownTimer()
        answerState  = .timeout
        wrongCount   += 1
        streak        = 0
        pointsEarned  = 0
        if storage.hapticEnabled { haptic.error() }
        scheduleAutoAdvance()
    }

    // MARK: - Auto-advance (1.5s delay)
    private func scheduleAutoAdvance() {
        stopAutoAdvanceTimer()
        autoAdvanceTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async { self.nextQuestion() }
        }
    }

    // MARK: - Next question
    func nextQuestion() {
        guard !isTransitioning else { return }
        isTransitioning = true
        stopAutoAdvanceTimer()

        let next = currentIndex + 1
        currentIndex = next

        if let total = mode.questionsPerRound, next >= total {
            endGame(); return
        }

        if next < questions.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.loadQuestion(at: next)
            }
        } else {
            endGame()
        }
    }

    // MARK: - End game
    private func endGame() {
        stopAllTimers()
        isGameOver = true
        persistResults()
    }

    private func persistResults() {
        let xp = score / 10
        storage.totalGamesPlayed += 1
        storage.totalCorrect     += correctCount
        storage.totalWrong       += wrongCount
        storage.totalXP          += xp
        if score > storage.bestScore       { storage.bestScore  = score }
        if bestStreak > storage.bestStreak { storage.bestStreak = bestStreak }
        if mode == .flag { storage.flagRoundsPlayed += 1 }
        if mode == .map  { storage.mapRoundsPlayed  += 1 }

        let total = correctCount + wrongCount
        storage.addLeaderboardEntry(LeaderboardEntry(
            id: UUID(), score: score, mode: mode, difficulty: difficulty,
            accuracy: total > 0 ? Double(correctCount) / Double(total) : 0,
            date: Date()))
        checkBadges()
    }

    private func checkBadges() {
        if storage.totalGamesPlayed == 1 { storage.unlockBadge(id: "first_game") }
        if storage.totalCorrect >= 1     { storage.unlockBadge(id: "first_correct") }
        if storage.totalCorrect >= 10    { storage.unlockBadge(id: "correct_10") }
        if storage.totalCorrect >= 50    { storage.unlockBadge(id: "correct_50") }
        let t = correctCount + wrongCount
        if t > 0 && wrongCount == 0      { storage.unlockBadge(id: "perfect_round") }
        if storage.flagRoundsPlayed >= 5 { storage.unlockBadge(id: "flag_master") }
        if storage.mapRoundsPlayed  >= 5 { storage.unlockBadge(id: "map_explorer") }
        if bestStreak >= 5               { storage.unlockBadge(id: "streak_5") }
        if bestStreak >= 10              { storage.unlockBadge(id: "streak_10") }
        if difficulty == .worldMaster    { storage.unlockBadge(id: "world_master") }
    }

    var gameResult: GameResult {
        let t = correctCount + wrongCount
        return GameResult(
            score: score, correct: correctCount, wrong: wrongCount, total: t,
            xpEarned: score / 10, bestStreak: bestStreak, mode: mode, difficulty: difficulty
        )
    }

    deinit { stopAllTimers() }
}
