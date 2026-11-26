import SwiftUI
import SwiftData

public struct AppointmentListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \VetAppointment.date) private var appointments: [VetAppointment]
    @Query(sort: \Pet.name) private var pets: [Pet]

    @State private var viewModel = AppointmentViewModel()
    @State private var showingAddAppointment = false
    @State private var appointmentToDelete: VetAppointment?
    @State private var showingDeleteAlert = false

    public init() {}

    public var body: some View {
        VStack(spacing: 12) {
            // Segmented Picker
            Picker("Filter", selection: $viewModel.selectedFilter) {
                ForEach(AppointmentViewModel.AppointmentFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 4)

            // Pet filter if more than 1 pet
            if pets.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button {
                            viewModel.selectedPetFilter = "All"
                        } label: {
                            Text("All Pets")
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(viewModel.selectedPetFilter == "All" ? Color.accentColor : Color(.systemGray6), in: Capsule())
                                .foregroundStyle(viewModel.selectedPetFilter == "All" ? .white : .primary)
                        }
                        .buttonStyle(.plain)

                        ForEach(pets) { pet in
                            Button {
                                viewModel.selectedPetFilter = pet.name
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: pet.speciesIconName)
                                    Text(pet.name)
                                }
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(viewModel.selectedPetFilter == pet.name ? Color.accentColor : Color(.systemGray6), in: Capsule())
                                .foregroundStyle(viewModel.selectedPetFilter == pet.name ? .white : .primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            let filtered = viewModel.filteredAppointments(appointments)

            if filtered.isEmpty {
                Spacer()
                ContentUnavailableView(
                    emptyTitle,
                    systemImage: "calendar.badge.clock",
                    description: Text(emptyDescription)
                )
                .overlay(alignment: .bottom) {
                    Button {
                        showingAddAppointment = true
                    } label: {
                        Label("Schedule Appointment", systemImage: "plus")
                            .font(.subheadline.bold())
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accentColor)
                    .padding(.bottom, 40)
                }
                Spacer()
            } else {
                List {
                    ForEach(filtered) { appt in
                        AppointmentRowCard(appointment: appt) {
                            try? viewModel.toggleCompleted(appt, context: modelContext)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                try? viewModel.toggleCompleted(appt, context: modelContext)
                            } label: {
                                Label(
                                    appt.isCompleted ? "Mark Upcoming" : "Mark Done",
                                    systemImage: appt.isCompleted ? "arrow.uturn.backward" : "checkmark"
                                )
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                appointmentToDelete = appt
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Vet Visits")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddAppointment = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddAppointment) {
            AddAppointmentView()
        }
        .alert("Delete Appointment?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                appointmentToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let appointmentToDelete {
                    try? viewModel.deleteAppointment(appointmentToDelete, context: modelContext)
                }
                appointmentToDelete = nil
            }
        } message: {
            Text("This visit record will be permanently deleted.")
        }
    }

    private var emptyTitle: String {
        switch viewModel.selectedFilter {
        case .upcoming:
            return "No Upcoming Visits"
        case .past:
            return "No Completed Visits"
        case .all:
            return "No Visits Recorded"
        }
    }

    private var emptyDescription: String {
        switch viewModel.selectedFilter {
        case .upcoming:
            return "Stay ahead of your pets' veterinary checkups and vaccination boosters."
        case .past:
            return "Visits you mark completed will be archived here."
        case .all:
            return "Keep track of checkups, dental cleanings, and vaccination appointments."
        }
    }
}
