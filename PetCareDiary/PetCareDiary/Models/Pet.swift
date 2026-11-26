import Foundation
import SwiftData

@Model
public final class Pet {
    public var id: UUID
    public var name: String
    public var species: String
    public var breed: String
    public var dateOfBirth: Date
    public var weight: Double
    public var vetName: String
    public var vetPhone: String
    public var lastVaccinationDate: Date?
    public var nextVaccinationDate: Date?
    public var notes: String
    public var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \VetAppointment.pet)
    public var appointments: [VetAppointment]? = []

    public init(
        name: String,
        species: String,
        breed: String = "",
        dateOfBirth: Date = .now,
        weight: Double = 0.0,
        vetName: String = "",
        vetPhone: String = "",
        lastVaccinationDate: Date? = nil,
        nextVaccinationDate: Date? = nil,
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.species = species
        self.breed = breed
        self.dateOfBirth = dateOfBirth
        self.weight = weight
        self.vetName = vetName
        self.vetPhone = vetPhone
        self.lastVaccinationDate = lastVaccinationDate
        self.nextVaccinationDate = nextVaccinationDate
        self.notes = notes
        self.createdAt = .now
        self.appointments = []
    }

    public var ageDescription: String {
        let calendar = Calendar.current
        let now = Date.now
        let components = calendar.dateComponents([.year, .month, .day], from: dateOfBirth, to: now)
        let years = max(0, components.year ?? 0)
        let months = max(0, components.month ?? 0)
        let days = max(0, components.day ?? 0)

        if years > 0 {
            let extraMonths = months % 12
            if extraMonths > 0 {
                return "\(years) yr \(extraMonths) mo"
            } else {
                return "\(years) year\(years == 1 ? "" : "s")"
            }
        } else if months > 0 {
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return "\(days) day\(days == 1 ? "" : "s")"
        }
    }

    public var vaccinationStatus: VaccinationStatus {
        guard let dueDate = nextVaccinationDate else { return .notSet }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let dueDay = calendar.startOfDay(for: dueDate)
        let days = calendar.dateComponents([.day], from: today, to: dueDay).day ?? 0

        if days < 0 {
            return .overdue
        } else if days <= 30 {
            return .dueSoon
        } else {
            return .upToDate
        }
    }

    public var daysUntilVaccination: Int? {
        guard let dueDate = nextVaccinationDate else { return nil }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let dueDay = calendar.startOfDay(for: dueDate)
        return calendar.dateComponents([.day], from: today, to: dueDay).day
    }

    public var speciesIconName: String {
        switch species.lowercased() {
        case "dog": return "dog.fill"
        case "cat": return "cat.fill"
        case "bird": return "bird.fill"
        case "fish": return "fish.fill"
        case "rabbit": return "hare.fill"
        default: return "pawprint.fill"
        }
    }
}
