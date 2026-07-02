import SwiftUI

// MARK: - Country Map Shape Renderer
struct CountryMapShape: View {
    let countryId: String
    var fillColor: Color = Color(hex: "#1F3B57")
    var size: CGFloat = 200

    var body: some View {
        // Use function lookup — never loads full dictionary into memory at once
        if let polygons = CountryOutlines.polygons(for: countryId) {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<polygons.count, id: \.self) { i in
                        CountryPolygonShape(
                            coords: polygons[i],
                            allPolygons: polygons,
                            viewSize: geo.size
                        )
                        .fill(fillColor)
                    }
                }
            }
            .frame(width: size, height: size)
            .shadow(color: fillColor.opacity(0.25), radius: 8, x: 0, y: 3)
        } else {
            VStack(spacing: 8) {
                Image(systemName: "map")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(fillColor.opacity(0.4))
                Text("Map unavailable")
                    .font(.system(size: 11))
                    .foregroundColor(.slateGray)
            }
            .frame(width: size, height: size)
        }
    }
}

// MARK: - Polygon Shape
struct CountryPolygonShape: Shape {
    let coords: [Double]
    let allPolygons: [[Double]]
    let viewSize: CGSize

    func path(in rect: CGRect) -> Path {
        guard coords.count >= 4 else { return Path() }

        var minLon =  Double.infinity, maxLon = -Double.infinity
        var minLat =  Double.infinity, maxLat = -Double.infinity
        for poly in allPolygons {
            var i = 0
            while i + 1 < poly.count {
                let lon = poly[i], lat = poly[i+1]
                minLon = min(minLon, lon); maxLon = max(maxLon, lon)
                minLat = min(minLat, lat); maxLat = max(maxLat, lat)
                i += 2
            }
        }

        let lonRange = maxLon - minLon
        let latRange = maxLat - minLat
        guard lonRange > 0, latRange > 0 else { return Path() }

        let padding: CGFloat = 12
        let availW = rect.width  - padding * 2
        let availH = rect.height - padding * 2
        let scale  = min(availW / CGFloat(lonRange), availH / CGFloat(latRange))

        let drawW  = CGFloat(lonRange) * scale
        let drawH  = CGFloat(latRange) * scale
        let offsetX = (rect.width  - drawW) / 2
        let offsetY = (rect.height - drawH) / 2

        func project(_ lon: Double, _ lat: Double) -> CGPoint {
            CGPoint(
                x: offsetX + CGFloat(lon - minLon) * scale,
                y: offsetY + CGFloat(maxLat - lat) * scale
            )
        }

        var path = Path()
        var i = 0
        while i + 1 < coords.count {
            let pt = project(coords[i], coords[i+1])
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
            i += 2
        }
        path.closeSubpath()
        return path
    }
}
