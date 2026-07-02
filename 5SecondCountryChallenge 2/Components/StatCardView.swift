import SwiftUI

struct StatCardView: View {
    let title: String; let value: String; let icon: String
    var accentColor: Color = .mutedGold
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            HStack { Image(systemName: icon).font(.system(size: 14, weight: .semibold)).foregroundColor(accentColor); Spacer() }
            Text(value).font(DS.Font.title2).foregroundColor(.deepNavy)
            Text(title).font(DS.Font.caption).foregroundColor(.slateGray)
        }
        .padding(DS.Spacing.md).cardStyle()
    }
}
