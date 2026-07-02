import SwiftUI

struct AnswerButton: View {
    let country: Country
    let state: AnswerButtonState
    let action: () -> Void
    @State private var isPressed = false

    enum AnswerButtonState { case normal, correct, wrong, revealed }

    private var bg: Color {
        switch state {
        case .normal:   return .cardWhite
        case .correct:  return .elegantGreen
        case .wrong:    return .mutedRed
        case .revealed: return .elegantGreen.opacity(0.15)
        }
    }
    private var fg: Color {
        switch state {
        case .normal:          return .deepNavy
        case .correct, .wrong: return .white
        case .revealed:        return .elegantGreen
        }
    }
    private var border: Color {
        switch state {
        case .normal:   return Color.slateGray.opacity(0.15)
        case .correct:  return .elegantGreen
        case .wrong:    return .mutedRed
        case .revealed: return .elegantGreen
        }
    }
    private var icon: String? {
        switch state {
        case .correct, .revealed: return "checkmark.circle.fill"
        case .wrong:              return "xmark.circle.fill"
        default:                  return nil
        }
    }

    var body: some View {
        Button(action: {
            guard state == .normal else { return }
            action()
        }) {
            HStack(spacing: DS.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(fg)
                }
                Text(country.name)
                    .font(DS.Font.headline)
                    .foregroundColor(fg)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
            }
            .padding(.horizontal, DS.Spacing.md)
            .padding(.vertical, DS.Spacing.sm + 2)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
                    .stroke(border, lineWidth: 1.5)
            )
            .appShadow(DS.Shadow.soft)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(state != .normal)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: state)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard state == .normal else { return }
                    withAnimation(.spring(response: 0.2)) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3)) { isPressed = false }
                }
        )
    }
}
