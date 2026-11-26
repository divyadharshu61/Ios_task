import SwiftUI

public struct SpeciesFilterChip: View {
    public let title: String
    public let isSelected: Bool
    public let action: () -> Void

    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let species = Species(rawValue: title) {
                    Image(systemName: species.systemImage)
                        .font(.caption2)
                } else if title == "All" {
                    Image(systemName: "pawprint.fill")
                        .font(.caption2)
                }
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.systemGray6), in: Capsule())
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? Color.clear : Color(.separator).opacity(0.3), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}
