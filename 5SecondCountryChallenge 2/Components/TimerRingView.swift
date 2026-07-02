import SwiftUI

struct TimerRingView: View {
    let timeRemaining: Double; let totalTime: Double
    private var progress: Double { guard totalTime > 0 else { return 1 }; return max(0, min(1, timeRemaining / totalTime)) }
    private var ringColor: Color { progress > 0.6 ? .elegantGreen : progress > 0.3 ? .mutedGold : .mutedRed }
    var body: some View {
        ZStack {
            Circle().stroke(Color.softStone, lineWidth: 5)
            Circle().trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.05), value: progress)
            VStack(spacing: 0) {
                Text("\(max(0, Int(ceil(timeRemaining))))").font(DS.Font.display(22, weight: .bold))
                    .foregroundColor(ringColor).monospacedDigit()
                Text("sec").font(DS.Font.caption).foregroundColor(.slateGray)
            }
        }
        .frame(width: 72, height: 72)
    }
}
