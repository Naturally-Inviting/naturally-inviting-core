import SwiftUI

public struct PolkaTexturedView: View {
    public init() {}

    public var body: some View {
        Grid {
            ForEach(0...18, id: \.self) { _ in
                GridRow {
                    ForEach(0...12, id: \.self) { _ in
                        PolkaDotView()
                    }
                }
            }
        }
        .rotationEffect(.degrees(2))
    }
}

struct PolkaDotView: View {

    var color: Color = .red

    var body: some View {
        Circle()
            .fill(
                self.color.opacity(0.1)
            )
            .frame(width: 10, height: 10)
            .padding(16)
    }
}

#Preview {
    PolkaDotView()
}

#Preview {
    PolkaTexturedView()
}
