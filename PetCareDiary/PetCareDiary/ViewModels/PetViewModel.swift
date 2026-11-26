import Foundation
import Observation
import SwiftData

@MainActor
@Observable
public final class PetViewModel {
    public var searchText: String = ""
    public var selectedSpecies: String = "All"
    public var selectedStatus: String = "All"

    public let speciesOptions: [String] = Species.filterOptions
    public let statusOptions: [String] = ["All", "Up to Date", "Due Soon", "Overdue", "Not Set"]

    public init() {}

    public func filteredPets(_ pets: [Pet]) -> [Pet] {
        pets.filter { pet in
            let matchesSearch: Bool
            let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch = pet.name.localizedCaseInsensitiveContains(trimmed) ||
                                pet.breed.localizedCaseInsensitiveContains(trimmed) ||
                                pet.species.localizedCaseInsensitiveContains(trimmed)
            }

            let matchesSpecies = selectedSpecies == "All" || pet.species.caseInsensitiveCompare(selectedSpecies) == .orderedSame
            let matchesStatus = selectedStatus == "All" || pet.vaccinationStatus.rawValue == selectedStatus

            return matchesSearch && matchesSpecies && matchesStatus
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    public func addPet(
        name: String,
        species: String,
        breed: String,
        dateOfBirth: Date,
        weight: Double,
        vetName: String,
        vetPhone: String,
        lastVaccinationDate: Date?,
        nextVaccinationDate: Date?,
        notes: String,
        context: ModelContext
    ) throws {
        let pet = Pet(
            name: name,
            species: species,
            breed: breed,
            dateOfBirth: dateOfBirth,
            weight: weight,
            vetName: vetName,
            vetPhone: vetPhone,
            lastVaccinationDate: lastVaccinationDate,
            nextVaccinationDate: nextVaccinationDate,
            notes: notes
        )
        context.insert(pet)
        try context.save()
    }

    public func deletePet(_ pet: Pet, context: ModelContext) throws {
        context.delete(pet)
        try context.save()
    }

    public func saveChanges(context: ModelContext) throws {
        try context.save()
    }
}
