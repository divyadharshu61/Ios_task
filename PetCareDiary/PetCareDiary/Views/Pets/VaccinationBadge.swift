import SwiftUI

public struct VaccinationBadge: View {
    public let status: VaccinationStatus

    public init(status: VaccinationStatus) {
        self.status = status
    }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.systemImage)
                .font(.system(size: 10, weight: .semibold))
            Text(status.rawValue)
                .font(.system(size: 11, weight: .bold))
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .foregroundStyle(status.color)
        .background(status.color.opacity(0.14), in: Capsule())
    }
}
