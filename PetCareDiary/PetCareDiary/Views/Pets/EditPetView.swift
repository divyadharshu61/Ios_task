import SwiftUI
import SwiftData

public struct EditPetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable public var pet: Pet

    @State private var name: String = ""
    @State private var species: String = "Dog"
    @State private var breed: String = ""
    @State private var dateOfBirth: Date = .now
    @State private var weight: String = ""
    @State private var vetName: String = ""
    @State private var vetPhone: String = ""
    @State private var trackVaccination: Bool = false
    @State private var lastVaccinationDate: Date = .now
    @State private var nextVaccinationDate: Date = .now
    @State private var notes: String = ""
    @State private var errorMessage: String = ""

    public init(pet: Pet) {
        self.pet = pet
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Pet Name *", text: $name)

                    Picker("Species", selection: $species) {
                        ForEach(Species.allCases) { item in
                            Label(item.rawValue, systemImage: item.systemImage)
                                .tag(item.rawValue)
                        }
                    }

                    TextField("Breed", text: $breed)

                    DatePicker("Date of Birth", selection: $dateOfBirth, in: ...Date.now, displayedComponents: .date)

                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }

                Section("Veterinarian Contact") {
                    TextField("Clinic / Vet Name", text: $vetName)
                    TextField("Phone Number", text: $vetPhone)
                        .keyboardType(.phonePad)
                }

                Section {
                    Toggle("Track Vaccination Schedule", isOn: $trackVaccination)

                    if trackVaccination {
                        DatePicker("Last Vaccination", selection: $lastVaccinationDate, in: ...Date.now, displayedComponents: .date)
                        DatePicker("Next Due Date", selection: $nextVaccinationDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Vaccination Schedule")
                } footer: {
                    if !trackVaccination {
                        Text("Disabling will set vaccination status to Not Set.")
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Edit Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                name = pet.name
                species = pet.species
                breed = pet.breed
                dateOfBirth = pet.dateOfBirth
                weight = pet.weight > 0 ? String(format: "%.1f", pet.weight) : ""
                vetName = pet.vetName
                vetPhone = pet.vetPhone
                notes = pet.notes

                trackVaccination = (pet.nextVaccinationDate != nil || pet.lastVaccinationDate != nil)
                lastVaccinationDate = pet.lastVaccinationDate ?? Calendar.current.date(byAdding: .month, value: -6, to: .now) ?? .now
                nextVaccinationDate = pet.nextVaccinationDate ?? Calendar.current.date(byAdding: .month, value: 6, to: .now) ?? .now
            }
        }
    }

    private func saveChanges() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else {
            errorMessage = "Pet name cannot be empty."
            return
        }

        let parsedWeight: Double
        if weight.trimmingCharacters(in: .whitespaces).isEmpty {
            parsedWeight = 0.0
        } else if let w = Double(weight.replacingOccurrences(of: ",", with: ".")) {
            guard w >= 0 else {
                errorMessage = "Weight cannot be negative."
                return
            }
            parsedWeight = w
        } else {
            errorMessage = "Please enter a valid numeric weight."
            return
        }

        pet.name = cleanName
        pet.species = species
        pet.breed = breed.trimmingCharacters(in: .whitespacesAndNewlines)
        pet.dateOfBirth = dateOfBirth
        pet.weight = parsedWeight
        pet.vetName = vetName.trimmingCharacters(in: .whitespacesAndNewlines)
        pet.vetPhone = vetPhone.trimmingCharacters(in: .whitespacesAndNewlines)
        pet.lastVaccinationDate = trackVaccination ? lastVaccinationDate : nil
        pet.nextVaccinationDate = trackVaccination ? nextVaccinationDate : nil
        pet.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Could not update pet: \(error.localizedDescription)"
        }
    }
}
