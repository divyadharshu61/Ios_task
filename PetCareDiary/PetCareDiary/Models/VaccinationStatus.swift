import SwiftUI

public enum VaccinationStatus: String, CaseIterable, Codable {
    case upToDate = "Up to Date"
    case dueSoon = "Due Soon"
    case overdue = "Overdue"
    case notSet = "Not Set"

    public var color: Color {
        switch self {
        case .upToDate:
            return .green
        case .dueSoon:
            return .orange
        case .overdue:
            return .red
        case .notSet:
            return .secondary
        }
    }

    public var systemImage: String {
        switch self {
        case .upToDate:
            return "checkmark.shield.fill"
        case .dueSoon:
            return "clock.badge.exclamationmark.fill"
        case .overdue:
            return "exclamationmark.triangle.fill"
        case .notSet:
            return "questionmark.circle.dashed"
        }
    }

    public var iconBadge: String {
        switch self {
        case .upToDate:
            return "shield.lefthalf.filled"
        case .dueSoon:
            return "alarm.fill"
        case .overdue:
            return "exclamationmark.circle.fill"
        case .notSet:
            return "minus.circle"
        }
    }
}
