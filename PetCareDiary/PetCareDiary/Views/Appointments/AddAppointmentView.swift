import SwiftUI
import SwiftData

public struct AddAppointmentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pet.name) private var pets: [Pet]

    public var preselectedPet: Pet?

    @State private var selectedPetId: UUID?
    @State private var title: String = ""
    @State private var date: Date = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    @State private var clinicName: String = ""
    @State private var vetName: String = ""
    @State private var notes: String = ""
    @State private var errorMessage: String = ""

    private let quickTitles = [
        "Annual Checkup",
        "Vaccine Booster",
        "Dental Cleaning",
        "Flea & Tick Prevention",
        "Routine Bloodwork",
        "Nail Trimming"
    ]

    public init(preselectedPet: Pet? = nil) {
        self.preselectedPet = preselectedPet
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Pet") {
                    if pets.isEmpty {
                        Text("No pets added yet. Add a pet first.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Select Pet", selection: $selectedPetId) {
                            Text("Select a Pet").tag(UUID?.none)
                            ForEach(pets) { pet in
                                HStack {
                                    Image(systemName: pet.speciesIconName)
                                    Text(pet.name)
                                }
                                .tag(UUID?.some(pet.id))
                            }
                        }
                    }
                }

                Section("Appointment Details") {
                    TextField("Reason / Title *", text: $title)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickTitles, id: \.self) { quick in
                                Button(quick) {
                                    title = quick
                                }
                                .font(.caption2.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(title == quick ? Color.accentColor : Color(.systemGray6), in: Capsule())
                                .foregroundStyle(title == quick ? .white : .primary)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Clinic & Veterinarian") {
                    TextField("Clinic / Hospital Name", text: $clinicName)
                    TextField("Veterinarian Name", text: $vetName)
                }

                Section("Notes") {
                    TextField("Special instructions, preparation, or questions...", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("New Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAppointment() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || selectedPet == nil)
                }
            }
            .onAppear {
                if let preselectedPet {
                    selectedPetId = preselectedPet.id
                    if !preselectedPet.vetName.isEmpty {
                        vetName = preselectedPet.vetName
                    }
                } else if let firstPet = pets.first {
                    selectedPetId = firstPet.id
                    if !firstPet.vetName.isEmpty {
                        vetName = firstPet.vetName
                    }
                }
            }
        }
    }

    private var selectedPet: Pet? {
        pets.first { $0.id == selectedPetId }
    }

    private func saveAppointment() {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty else {
            errorMessage = "Please enter an appointment title or reason."
            return
        }

        guard let pet = selectedPet else {
            errorMessage = "Please select a pet."
            return
        }

        let appt = VetAppointment(
            title: cleanTitle,
            date: date,
            clinicName: clinicName.trimmingCharacters(in: .whitespacesAndNewlines),
            vetName: vetName.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            isCompleted: false,
            pet: pet
        )

        modelContext.insert(appt)
        if pet.appointments == nil {
            pet.appointments = []
        }
        pet.appointments?.append(appt)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save appointment: \(error.localizedDescription)"
        }
    }
}
