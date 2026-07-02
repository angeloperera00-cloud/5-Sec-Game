import SwiftUI

struct CountryVisualCard: View {
    let question: Question
    var body: some View {
        if question.showFlag {
            FlagCard(country: question.country)
        } else {
            MapCard(country: question.country)
        }
    }
}

// MARK: - Flag Card
private struct FlagCard: View {
    let country: Country
    @State private var appeared = false

    var body: some View {
        VStack(spacing: DS.Spacing.sm) {
            Text(country.flag)
                .font(.system(size: 110))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .scaleEffect(appeared ? 1 : 0.5)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.65), value: appeared)

            Text("Flag Challenge")
                .font(DS.Font.caption)
                .foregroundColor(.slateGray)
                .padding(.horizontal, DS.Spacing.sm)
                .padding(.vertical, DS.Spacing.xxs)
                .background(Color.softStone)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.xl)
        .cardStyle()
        .onAppear { appeared = true }
        .onChange(of: country.id) { _ in
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
        }
    }
}

// MARK: - Map Card
private struct MapCard: View {
    let country: Country
    @State private var appeared = false

    private var hasRealMap: Bool {
        CountryOutlines.polygons(for: country.id) != nil
    }

    var body: some View {
        VStack(spacing: DS.Spacing.md) {
            if hasRealMap {
                CountryMapShape(
                    countryId: country.id,
                    fillColor: Color.deepOcean,
                    size: 180
                )
                .scaleEffect(appeared ? 1 : 0.5)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.65), value: appeared)
            } else {
                // Fallback only when no outline data exists for this country
                mapUnavailable
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeIn(duration: 0.3), value: appeared)
            }

            Text("Map Challenge")
                .font(DS.Font.caption)
                .foregroundColor(.slateGray)
                .padding(.horizontal, DS.Spacing.sm)
                .padding(.vertical, DS.Spacing.xxs)
                .background(Color.softStone)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Spacing.lg)
        .cardStyle()
        .onAppear { appeared = true }
        .onChange(of: country.id) { _ in
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
        }
    }

    private var mapUnavailable: some View {
        VStack(spacing: DS.Spacing.xs) {
            Image(systemName: "map")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.deepOcean.opacity(0.3))
            Text("Which country is this?")
                .font(DS.Font.caption)
                .foregroundColor(.slateGray)
        }
        .frame(width: 180, height: 140)
    }
}
