import SwiftUI

public struct PrimaryPillStyle {
    public var foregroundColor: Color
    public var backgroundColor: Color
    public var disabledColor: Color
    public var font: Font
    public var height: CGFloat

    public init(
        foregroundColor: Color = defaultStyle.foregroundColor,
        backgroundColor: Color = defaultStyle.backgroundColor,
        disabledColor: Color? = nil,
        font: Font = defaultStyle.font,
        height: CGFloat = defaultStyle.height
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.disabledColor = disabledColor ?? backgroundColor.opacity(0.6)
        self.font = font
        self.height = height
    }
}

public extension PrimaryPillStyle {
    static var defaultStyle: Self {
        Self(
            foregroundColor: .white,
            backgroundColor: .blue,
            disabledColor: .blue,
            font: .headline.bold(),
            height: 48
        )
    }
}

public struct PrimaryPillButton: ButtonStyle {
    var style: PrimaryPillStyle
    var icon: String?
    var isLoading: Bool

    @Environment(\.isEnabled) private var isEnabled: Bool

    public init(
        style: PrimaryPillStyle = .defaultStyle,
        icon: String? = nil,
        isLoading: Bool = false
    ) {
        self.style = style
        self.icon = icon
        self.isLoading = isLoading
    }

    @ViewBuilder
    var iconView: some View {
        if let icon {
            Image(systemName: icon)
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()

            HStack(spacing: 8) {
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(Color.white)
                            .scaleEffect(0.8, anchor: .center)
                            .transition(.opacity.animation(.easeInOut))
                    } else {
                        iconView
                            .foregroundColor(style.foregroundColor.opacity(0.7))
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
                .frame(width: 24, height: 24)

                configuration.label
            }
            .offset(x: icon == nil ? 0 : -4) // Visually center horizontally

            Spacer()
        }
        .font(style.font)
        .foregroundColor(foregroundColorStyle(style, for: configuration))
        .frame(height: style.height)
        .background(backgroundColorStyle(style, for: configuration).gradient)
        .clipShape(Capsule(style: .continuous))
        .allowsHitTesting(!isLoading)
        .padding(.horizontal)
    }

    func backgroundColorStyle(_ style: PrimaryPillStyle, for configuration: Configuration) -> Color {
        let defaultColor = style.backgroundColor

        if configuration.isPressed {
            return defaultColor.opacity(0.6)
        }

        if !isEnabled {
            return style.disabledColor
        }

        return defaultColor
    }

    func foregroundColorStyle(_ style: PrimaryPillStyle, for configuration: Configuration) -> Color {
        let defaultColor = style.foregroundColor

        if configuration.isPressed {
            return defaultColor.opacity(0.6)
        }

        return defaultColor
    }
}

public extension View {
    func primaryPillButtonStyle(
        style: PrimaryPillStyle = .defaultStyle,
        icon: String? = nil,
        isLoading: Bool = false
    ) -> some View {
        self
            .buttonStyle(
                PrimaryPillButton(
                    style: style,
                    icon: icon,
                    isLoading: isLoading
                )
            )
    }
}

// swiftformat:disable indent
#if DEBUG
// MARK: - Demo Views
struct ButtonDemoView: View {
    var body: some View {
        ScrollView {
            VStack {
                Button("Hello", action: { print("") })
                    .primaryPillButtonStyle(icon: "calendar", isLoading: false)

                Button("Hello", action: {})
                    .primaryPillButtonStyle(icon: "calendar", isLoading: true)

                Button("Schedule Now", action: {})
                    .primaryPillButtonStyle()

                Button("Schedule Now", action: {})
                    .primaryPillButtonStyle()
                    .disabled(true)
            }
            .padding(.vertical)

            HStack(spacing: 8) {
                Button("Hello", action: { print("") })
                    .padding(.trailing, -16)

                Button("Hello", action: {})
                    .padding(.leading, -16)
            }
            .primaryPillButtonStyle(
                style: .init(font: .body),
                icon: "calendar",
                isLoading: false
            )
        }
    }
}

struct PrimaryPillButton_Previews: PreviewProvider {
    static var previews: some View {
        ButtonDemoView()
    }
}
#endif
