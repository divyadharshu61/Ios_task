import Foundation
import SwiftData

@MainActor
public final class SampleDataService {
    public static func insertSampleData(context: ModelContext) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        // Pet 1: Bella - Golden Retriever (Up to Date)
        let bella = Pet(
            name: "Bella",
            species: "Dog",
            breed: "Golden Retriever",
            dateOfBirth: calendar.date(byAdding: .year, value: -3, to: today) ?? today,
            weight: 28.5,
            vetName: "Dr. Sarah Jenkins",
            vetPhone: "+1 (555) 234-5678",
            lastVaccinationDate: calendar.date(byAdding: .month, value: -4, to: today),
            nextVaccinationDate: calendar.date(byAdding: .month, value: 8, to: today),
            notes: "Friendly and highly active. Loves swimming and fetching tennis balls. Slight seasonal skin allergy in spring."
        )

        // Pet 2: Milo - British Shorthair (Due Soon)
        let milo = Pet(
            name: "Milo",
            species: "Cat",
            breed: "British Shorthair",
            dateOfBirth: calendar.date(byAdding: .year, value: -2, to: today) ?? today,
            weight: 4.6,
            vetName: "Dr. Sarah Jenkins",
            vetPhone: "+1 (555) 234-5678",
            lastVaccinationDate: calendar.date(byAdding: .month, value: -11, to: today),
            nextVaccinationDate: calendar.date(byAdding: .day, value: 14, to: today),
            notes: "Indoor cat. Enjoys sunny window perches. Prefers wet food in the evenings."
        )

        // Pet 3: Charlie - French Bulldog (Overdue)
        let charlie = Pet(
            name: "Charlie",
            species: "Dog",
            breed: "French Bulldog",
            dateOfBirth: calendar.date(byAdding: .year, value: -1, to: today) ?? today,
            weight: 11.2,
            vetName: "Dr. Robert Chen",
            vetPhone: "+1 (555) 876-5432",
            lastVaccinationDate: calendar.date(byAdding: .year, value: -1, to: today),
            nextVaccinationDate: calendar.date(byAdding: .day, value: -8, to: today),
            notes: "Sensitive ears need weekly gentle cleaning. Keep indoors during peak summer heat."
        )

        // Pet 4: Luna - Holland Lop Rabbit (Up to Date)
        let luna = Pet(
            name: "Luna",
            species: "Rabbit",
            breed: "Holland Lop",
            dateOfBirth: calendar.date(byAdding: .month, value: -14, to: today) ?? today,
            weight: 1.8,
            vetName: "Dr. Robert Chen",
            vetPhone: "+1 (555) 876-5432",
            lastVaccinationDate: calendar.date(byAdding: .month, value: -2, to: today),
            nextVaccinationDate: calendar.date(byAdding: .month, value: 4, to: today),
            notes: "Free-roam rabbit. Loves fresh Timothy hay and small parsley treats."
        )

        // Pet 5: Pip - Cockatiel (Not Set)
        let pip = Pet(
            name: "Pip",
            species: "Bird",
            breed: "Cockatiel",
            dateOfBirth: calendar.date(byAdding: .month, value: -8, to: today) ?? today,
            weight: 0.09,
            vetName: "Dr. Emily Davis",
            vetPhone: "+1 (555) 345-6789",
            lastVaccinationDate: nil,
            nextVaccinationDate: nil,
            notes: "Vocal and whistles cheerful tunes every morning. Enjoys head scratches."
        )

        context.insert(bella)
        context.insert(milo)
        context.insert(charlie)
        context.insert(luna)
        context.insert(pip)

        // Appointments
        let appt1 = VetAppointment(
            title: "Annual Wellness & Dental Check",
            date: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
            clinicName: "Metropolitan Pet Hospital",
            vetName: "Dr. Sarah Jenkins",
            notes: "Check teeth tartar and general body condition score.",
            isCompleted: false,
            pet: bella
        )

        let appt2 = VetAppointment(
            title: "Rabies & FVRCP Booster",
            date: calendar.date(byAdding: .day, value: 14, to: today) ?? today,
            clinicName: "Metropolitan Pet Hospital",
            vetName: "Dr. Sarah Jenkins",
            notes: "Scheduled booster to keep vaccination record fully up to date.",
            isCompleted: false,
            pet: milo
        )

        let appt3 = VetAppointment(
            title: "Overdue Vaccine Catch-up",
            date: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
            clinicName: "Oakwood Animal Clinic",
            vetName: "Dr. Robert Chen",
            notes: "Urgent overdue DHPP vaccination booster and ear examination.",
            isCompleted: false,
            pet: charlie
        )

        let appt4 = VetAppointment(
            title: "Routine Nail Trim & Health Exam",
            date: calendar.date(byAdding: .day, value: -20, to: today) ?? today,
            clinicName: "Metropolitan Pet Hospital",
            vetName: "Dr. Sarah Jenkins",
            notes: "Completed successfully. Weight was stable at 28.3 kg.",
            isCompleted: true,
            pet: bella
        )

        context.insert(appt1)
        context.insert(appt2)
        context.insert(appt3)
        context.insert(appt4)

        try? context.save()
    }
}
