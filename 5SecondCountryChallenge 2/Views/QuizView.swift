import SwiftUI

struct QuizView: View {
    let mode: GameMode
    let difficulty: Difficulty
    @Binding var path: NavigationPath

    @StateObject private var vm: GameViewModel

    init(mode: GameMode, difficulty: Difficulty, path: Binding<NavigationPath>) {
        self.mode = mode
        self.difficulty = difficulty
        self._path = path
        self._vm = StateObject(wrappedValue: GameViewModel(mode: mode, difficulty: difficulty))
    }

    var body: some View {
        ZStack {
            Color.warmIvory.ignoresSafeArea()
            if vm.isGameOver {
                Color.clear.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        path.append(AppRoute.result(result: vm.gameResult))
                    }
                }
            } else {
                gameContent
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { path.removeLast(path.count) } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Quit").font(DS.Font.callout)
                    }.foregroundColor(.slateGray)
                }
            }
        }
        .onAppear { vm.startGame() }
    }

    // MARK: - Main layout
    private var gameContent: some View {
        VStack(spacing: 0) {
            topHUD
                .padding(.horizontal, DS.Spacing.md)
                .padding(.top, DS.Spacing.sm)

            if mode == .rush {
                rushBar
                    .padding(.horizontal, DS.Spacing.md)
                    .padding(.top, DS.Spacing.xs)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: DS.Spacing.md) {

                    if let total = mode.questionsPerRound {
                        progressDots(current: vm.currentIndex + 1, total: total)
                    }

                    if let q = vm.currentQuestion {

                        CountryVisualCard(question: q)
                            .padding(.horizontal, DS.Spacing.md)
                            .id(q.country.id)
                            .opacity(vm.isTransitioning ? 0 : 1)
                            .animation(.easeInOut(duration: 0.2), value: vm.isTransitioning)

                        if vm.answerState != .unanswered {
                            feedbackBanner(q: q)
                                .padding(.horizontal, DS.Spacing.md)
                                .transition(.scale(scale: 0.95).combined(with: .opacity))
                        }

                        VStack(spacing: DS.Spacing.sm) {
                            ForEach(q.options, id: \.id) { country in
                                AnswerButton(
                                    country: country,
                                    state: btnState(country, q),
                                    action: { vm.selectAnswer(country) }
                                )
                            }
                        }
                        .padding(.horizontal, DS.Spacing.md)
                        .opacity(vm.isTransitioning ? 0 : 1)
                        .animation(.easeInOut(duration: 0.2), value: vm.isTransitioning)

                        // Auto-advance indicator — shown for all modes
                        if vm.answerState != .unanswered {
                            autoAdvanceIndicator
                        }

                        Spacer(minLength: 80)
                    }
                }
                .padding(.top, DS.Spacing.md)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.answerState)
            }
        }
    }

    // MARK: - Top HUD
    private var topHUD: some View {
        HStack(spacing: DS.Spacing.sm) {
            VStack(spacing: 0) {
                Text("\(vm.score)")
                    .font(DS.Font.display(20))
                    .foregroundColor(.deepNavy)
                    .monospacedDigit()
                    .animation(.spring(response: 0.3), value: vm.score)
                Text("Score").font(DS.Font.caption).foregroundColor(.slateGray)
            }
            .frame(maxWidth: .infinity)

            TimerRingView(
                timeRemaining: vm.timeRemaining,
                totalTime: Double(StorageManager.shared.timerDuration)
            )

            VStack(spacing: 0) {
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(vm.streak > 0 ? .mutedRed : .slateGray)
                    Text("\(vm.streak)")
                        .font(DS.Font.display(20))
                        .foregroundColor(.deepNavy)
                        .animation(.spring(response: 0.3), value: vm.streak)
                }
                Text("Streak").font(DS.Font.caption).foregroundColor(.slateGray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(DS.Spacing.md)
        .cardStyle()
    }

    // MARK: - Rush timer bar
    private var rushBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: DS.Radius.pill)
                    .fill(Color.softStone)
                    .frame(height: 6)
                RoundedRectangle(cornerRadius: DS.Radius.pill)
                    .fill(vm.rushTimeRemaining > 15 ? Color.elegantGreen : Color.mutedRed)
                    .frame(width: geo.size.width * max(0, vm.rushTimeRemaining / 60), height: 6)
                    .animation(.linear(duration: 0.1), value: vm.rushTimeRemaining)
            }
        }
        .frame(height: 6)
    }

    // MARK: - Progress dots
    private func progressDots(current: Int, total: Int) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i < current ? Color.deepOcean : Color.softStone)
                    .frame(height: 4)
                    .animation(.spring(response: 0.3), value: current)
            }
        }
        .padding(.horizontal, DS.Spacing.md)
        .frame(height: 4)
    }

    // MARK: - Feedback banner
    private func feedbackBanner(q: Question) -> some View {
        let isCorrect = vm.answerState == .correct
        let isTimeout = vm.answerState == .timeout
        let color: Color = isCorrect ? .elegantGreen : .mutedRed

        return VStack(spacing: DS.Spacing.xs) {
            HStack(spacing: DS.Spacing.xs) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
                Text(isCorrect ? "Correct!" : isTimeout ? "Time's Up!" : "Wrong!")
                    .font(DS.Font.title3)
                    .foregroundColor(color)
                if vm.pointsEarned > 0 {
                    Text("+\(vm.pointsEarned)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.mutedGold)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.mutedGold.opacity(0.12))
                        .clipShape(Capsule())
                }
                Spacer()
            }

            if !isCorrect {
                HStack(spacing: DS.Spacing.xs) {
                    Text(q.country.flag).font(.system(size: 18))
                    Text("It was \(q.country.name)")
                        .font(DS.Font.headline)
                        .foregroundColor(.deepNavy)
                    Spacer()
                }
            }

            Text(q.country.shortFact)
                .font(DS.Font.callout)
                .foregroundColor(.slateGray)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DS.Spacing.md)
        .background(color.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
                .stroke(color.opacity(0.25), lineWidth: 1.5)
        )
    }

    // MARK: - Auto-advance indicator
    private var autoAdvanceIndicator: some View {
        HStack(spacing: DS.Spacing.xs) {
            ProgressView()
                .tint(Color.slateGray)
                .scaleEffect(0.7)
            Text("Next question…")
                .font(DS.Font.caption)
                .foregroundColor(.slateGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.xs)
    }

    // MARK: - Button state
    private func btnState(_ c: Country, _ q: Question) -> AnswerButton.AnswerButtonState {
        guard vm.answerState != .unanswered else { return .normal }
        if c.id == q.country.id {
            return (vm.answerState == .correct && vm.selectedAnswer?.id == c.id) ? .correct : .revealed
        }
        if vm.selectedAnswer?.id == c.id { return .wrong }
        return .normal
    }
}
