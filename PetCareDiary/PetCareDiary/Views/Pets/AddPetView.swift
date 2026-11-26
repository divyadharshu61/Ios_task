import SwiftUI
import SwiftData

public struct AddPetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var species = "Dog"
    @State private var breed = ""
    @State private var dateOfBirth = Calendar.current.date(byAdding: .year, value: -1, to: .now) ?? .now
    @State private var weight = ""
    @State private var vetName = ""
    @State private var vetPhone = ""
    @State private var includeVaccinationDates = true
    @State private var lastVaccinationDate = Calendar.current.date(byAdding: .month, value: -6, to: .now) ?? .now
    @State private var nextVaccinationDate = Calendar.current.date(byAdding: .month, value: 6, to: .now) ?? .now
    @State private var notes = ""
    @State private var errorMessage = ""

    public init() {}

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

                    TextField("Breed (e.g. Golden Retriever)", text: $breed)

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
                    Toggle("Track Vaccination Schedule", isOn: $includeVaccinationDates)

                    if includeVaccinationDates {
                        DatePicker("Last Vaccination", selection: $lastVaccinationDate, in: ...Date.now, displayedComponents: .date)
                        DatePicker("Next Due Date", selection: $nextVaccinationDate, displayedComponents: .date)
                    }
                } header: {
                    Text("Vaccination Record")
                } footer: {
                    if includeVaccinationDates {
                        Text("The app will automatically calculate whether vaccination is Up to Date, Due Soon, or Overdue.")
                    }
                }

                Section("Notes") {
                    TextField("Behavior, diet, allergies, microchip ID...", text: $notes, axis: .vertical)
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
            .navigationTitle("Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { savePet() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func savePet() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else {
            errorMessage = "Please enter the pet's name."
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

        let pet = Pet(
            name: cleanName,
            species: species,
            breed: breed.trimmingCharacters(in: .whitespacesAndNewlines),
            dateOfBirth: dateOfBirth,
            weight: parsedWeight,
            vetName: vetName.trimmingCharacters(in: .whitespacesAndNewlines),
            vetPhone: vetPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            lastVaccinationDate: includeVaccinationDates ? lastVaccinationDate : nil,
            nextVaccinationDate: includeVaccinationDates ? nextVaccinationDate : nil,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        modelContext.insert(pet)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Could not save pet: \(error.localizedDescription)"
        }
    }
}
