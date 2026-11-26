import Foundation
import Observation
import SwiftData

@MainActor
@Observable
public final class DashboardViewModel {
    public init() {}

    public func totalPetsCount(pets: [Pet]) -> Int {
        pets.count
    }

    public func dueSoonCount(pets: [Pet]) -> Int {
        pets.filter { $0.vaccinationStatus == .dueSoon }.count
    }

    public func overdueCount(pets: [Pet]) -> Int {
        pets.filter { $0.vaccinationStatus == .overdue }.count
    }

    public func upcomingAppointmentsCount(appointments: [VetAppointment]) -> Int {
        appointments.filter { $0.isUpcoming }.count
    }

    public func recentlyAddedPets(pets: [Pet], limit: Int = 3) -> [Pet] {
        Array(pets.sorted(by: { $0.createdAt > $1.createdAt }).prefix(limit))
    }

    public func upcomingAppointments(appointments: [VetAppointment], limit: Int = 3) -> [VetAppointment] {
        Array(appointments.filter { $0.isUpcoming }.sorted(by: { $0.date < $1.date }).prefix(limit))
    }

    public func attentionRequiredPets(pets: [Pet]) -> [Pet] {
        pets.filter { $0.vaccinationStatus == .overdue || $0.vaccinationStatus == .dueSoon }
    }
}
