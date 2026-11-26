import Foundation
import Observation
import SwiftData

@MainActor
@Observable
public final class AppointmentViewModel {
    public var selectedFilter: AppointmentFilter = .upcoming
    public var selectedPetFilter: String = "All"

    public enum AppointmentFilter: String, CaseIterable, Identifiable {
        case upcoming = "Upcoming"
        case past = "Completed"
        case all = "All"

        public var id: String { rawValue }
    }

    public init() {}

    public func filteredAppointments(_ appointments: [VetAppointment]) -> [VetAppointment] {
        appointments.filter { appt in
            let matchesTab: Bool
            switch selectedFilter {
            case .upcoming:
                matchesTab = appt.isUpcoming
            case .past:
                matchesTab = !appt.isUpcoming
            case .all:
                matchesTab = true
            }

            let matchesPet: Bool
            if selectedPetFilter == "All" {
                matchesPet = true
            } else {
                matchesPet = appt.pet?.name == selectedPetFilter
            }

            return matchesTab && matchesPet
        }
        .sorted {
            if selectedFilter == .past {
                return $0.date > $1.date
            } else {
                return $0.date < $1.date
            }
        }
    }

    public func addAppointment(
        pet: Pet?,
        title: String,
        date: Date,
        clinicName: String,
        vetName: String,
        notes: String,
        context: ModelContext
    ) throws {
        let appt = VetAppointment(
            title: title,
            date: date,
            clinicName: clinicName,
            vetName: vetName,
            notes: notes,
            isCompleted: false,
            pet: pet
        )
        context.insert(appt)
        try context.save()
    }

    public func toggleCompleted(_ appointment: VetAppointment, context: ModelContext) throws {
        appointment.isCompleted.toggle()
        try context.save()
    }

    public func deleteAppointment(_ appointment: VetAppointment, context: ModelContext) throws {
        context.delete(appointment)
        try context.save()
    }
}
