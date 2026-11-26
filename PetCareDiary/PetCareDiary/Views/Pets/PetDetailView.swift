import SwiftUI
import SwiftData

public struct PetDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable public var pet: Pet
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    @State private var showingAddAppointment = false

    public init(pet: Pet) {
        self.pet = pet
    }

    public var body: some View {
        List {
            // Profile Header Card
            Section {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.14))
                        Image(systemName: pet.speciesIconName)
                            .font(.system(size: 44))
                            .foregroundStyle(Color.accentColor)
                    }
                    .frame(width: 88, height: 88)

                    VStack(spacing: 4) {
                        Text(pet.name)
                            .font(.title.bold())

                        Text("\(pet.species) • \(pet.breed.isEmpty ? "Breed not specified" : pet.breed)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VaccinationBadge(status: pet.vaccinationStatus)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            // Pet Info
            Section("Pet Information") {
                LabeledContent("Age", value: pet.ageDescription)
                LabeledContent("Date of Birth", value: pet.dateOfBirth.formatted(date: .abbreviated, time: .omitted))
                LabeledContent("Weight", value: pet.weight > 0 ? String(format: "%.1f kg", pet.weight) : "Not recorded")
            }

            // Vaccination Record
            Section("Vaccination Status") {
                LabeledContent("Status") {
                    VaccinationBadge(status: pet.vaccinationStatus)
                }

                LabeledContent("Last Vaccination", value: dateText(pet.lastVaccinationDate))
                LabeledContent("Next Due Date", value: dateText(pet.nextVaccinationDate))

                if let days = pet.daysUntilVaccination {
                    if days < 0 {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                            Text("Vaccination was due \(abs(days)) day\(abs(days) == 1 ? "" : "s") ago!")
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(.red)
                        }
                    } else if days <= 30 {
                        HStack {
                            Image(systemName: "clock.badge.exclamationmark.fill")
                                .foregroundStyle(.orange)
                            Text("Vaccination due in \(days) day\(days == 1 ? "" : "s")")
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                    } else {
                        HStack {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundStyle(.green)
                            Text("Next booster in \(days) days")
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            // Veterinarian
            Section("Veterinarian") {
                LabeledContent("Vet Name", value: pet.vetName.isEmpty ? "Not recorded" : pet.vetName)

                if !pet.vetPhone.isEmpty {
                    HStack {
                        Text("Phone")
                        Spacer()
                        if let phoneURL = URL(string: "tel:\(pet.vetPhone.filter { "0123456789+".contains($0) })") {
                            Link(pet.vetPhone, destination: phoneURL)
                                .font(.body.weight(.medium))
                                .foregroundStyle(Color.accentColor)
                        } else {
                            Text(pet.vetPhone)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    LabeledContent("Phone", value: "Not recorded")
                }
            }

            // Appointments Section
            Section {
                let appts = (pet.appointments ?? []).sorted(by: { $0.date > $1.date })
                if appts.isEmpty {
                    HStack {
                        Text("No appointments scheduled.")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Button("Schedule") {
                            showingAddAppointment = true
                        }
                        .font(.subheadline.bold())
                    }
                } else {
                    ForEach(appts) { appt in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(appt.title)
                                    .font(.subheadline.weight(.semibold))
                                    .strikethrough(appt.isCompleted)
                                    .foregroundStyle(appt.isCompleted ? .secondary : .primary)

                                Text(appt.formattedDateTime)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if appt.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.caption)
                            } else if appt.isUpcoming {
                                Text("Upcoming")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.purple)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.purple.opacity(0.12), in: Capsule())
                            }
                        }
                    }

                    Button {
                        showingAddAppointment = true
                    } label: {
                        Label("Schedule New Appointment", systemImage: "plus")
                            .font(.subheadline.weight(.semibold))
                    }
                }
            } header: {
                Text("Vet Appointments")
            }

            // Notes
            Section("Notes") {
                Text(pet.notes.isEmpty ? "No special notes recorded." : pet.notes)
                    .foregroundStyle(pet.notes.isEmpty ? .secondary : .primary)
            }

            // Delete Action
            Section {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Label("Delete Pet Profile", systemImage: "trash")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEdit = true }
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditPetView(pet: pet)
        }
        .sheet(isPresented: $showingAddAppointment) {
            AddAppointmentView(preselectedPet: pet)
        }
        .alert("Delete \(pet.name)?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                modelContext.delete(pet)
                try? modelContext.save()
                dismiss()
            }
        } message: {
            Text("This will permanently remove \(pet.name) and all associated records from your diary.")
        }
    }

    private func dateText(_ date: Date?) -> String {
        date?.formatted(date: .abbreviated, time: .omitted) ?? "Not recorded"
    }
}
