import Foundation
import SwiftData

@Model
public final class VetAppointment {
    public var id: UUID
    public var title: String
    public var date: Date
    public var clinicName: String
    public var vetName: String
    public var notes: String
    public var isCompleted: Bool
    public var createdAt: Date
    public var pet: Pet?

    public init(
        title: String,
        date: Date,
        clinicName: String = "",
        vetName: String = "",
        notes: String = "",
        isCompleted: Bool = false,
        pet: Pet? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.clinicName = clinicName
        self.vetName = vetName
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = .now
        self.pet = pet
    }

    public var isUpcoming: Bool {
        !isCompleted && date >= Calendar.current.startOfDay(for: .now)
    }

    public var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    public var formattedTime: String {
        date.formatted(date: .omitted, time: .shortened)
    }

    public var formattedDateTime: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
}
