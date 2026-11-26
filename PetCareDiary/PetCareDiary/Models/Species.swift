import SwiftUI

public enum Species: String, CaseIterable, Identifiable, Codable {
    case dog = "Dog"
    case cat = "Cat"
    case bird = "Bird"
    case fish = "Fish"
    case rabbit = "Rabbit"
    case other = "Other"

    public var id: String { rawValue }

    public var systemImage: String {
        switch self {
        case .dog: return "dog.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .rabbit: return "hare.fill"
        case .other: return "pawprint.fill"
        }
    }

    public static var filterOptions: [String] {
        ["All"] + allCases.map { $0.rawValue }
    }
}
