import SwiftUI
import SwiftData

public struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pet.createdAt, order: .reverse) private var pets: [Pet]
    @Query(sort: \VetAppointment.date) private var appointments: [VetAppointment]

    @State private var viewModel = DashboardViewModel()
    @State private var showingAddPet = false
    @State private var showingAddAppointment = false

    public var onNavigateToPets: (() -> Void)? = nil
    public var onNavigateToVisits: (() -> Void)? = nil
    public var onSignOut: (() -> Void)? = nil

    public init(
        onNavigateToPets: (() -> Void)? = nil,
        onNavigateToVisits: (() -> Void)? = nil,
        onSignOut: (() -> Void)? = nil
    ) {
        self.onNavigateToPets = onNavigateToPets
        self.onNavigateToVisits = onNavigateToVisits
        self.onSignOut = onSignOut
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                // Greeting Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello, Pet Parent 👋")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                        Text(currentDateFormatted)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if let onSignOut {
                        Button(action: onSignOut) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .padding(10)
                                .background(Color(.systemGray6), in: Circle())
                        }
                        .accessibilityLabel("Lock Diary")
                    }
                }

                // 2x2 Statistics Grid
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                    StatCardView(
                        title: "Total Pets",
                        value: "\(viewModel.totalPetsCount(pets: pets))",
                        icon: "pawprint.fill",
                        color: Color.accentColor,
                        subtitle: pets.isEmpty ? "None" : "Enrolled"
                    )

                    StatCardView(
                        title: "Due Soon",
                        value: "\(viewModel.dueSoonCount(pets: pets))",
                        icon: "calendar.badge.clock",
                        color: .orange,
                        subtitle: viewModel.dueSoonCount(pets: pets) > 0 ? "Next 30d" : "Clear"
                    )

                    StatCardView(
                        title: "Overdue",
                        value: "\(viewModel.overdueCount(pets: pets))",
                        icon: "exclamationmark.triangle.fill",
                        color: .red,
                        subtitle: viewModel.overdueCount(pets: pets) > 0 ? "Action!" : "None"
                    )

                    StatCardView(
                        title: "Vet Visits",
                        value: "\(viewModel.upcomingAppointmentsCount(appointments: appointments))",
                        icon: "cross.case.fill",
                        color: .purple,
                        subtitle: "Upcoming"
                    )
                }

                // Attention Banner if any overdue
                let overduePets = pets.filter { $0.vaccinationStatus == .overdue }
                if !overduePets.isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .font(.title2)
                            .foregroundStyle(.red)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Vaccinations Overdue")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.primary)

                            Text("\(overduePets.map(\.name).joined(separator: ", ")) need vaccine booster shots.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button("View") {
                            onNavigateToPets?()
                        }
                        .font(.caption.bold())
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .padding(14)
                    .background(Color.red.opacity(0.10), in: RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.red.opacity(0.25), lineWidth: 1)
                    )
                }

                // Quick Action Bar
                HStack(spacing: 12) {
                    Button {
                        showingAddPet = true
                    } label: {
                        Label("Add Pet", systemImage: "plus")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accentColor)

                    Button {
                        showingAddAppointment = true
                    } label: {
                        Label("Book Visit", systemImage: "calendar.badge.plus")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                    }
                    .buttonStyle(.bordered)
                    .tint(.purple)
                }

                // Upcoming Vet Visits Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Upcoming Vet Visits", systemImage: "cross.case.fill")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)

                        Spacer()

                        Button("View all") {
                            onNavigateToVisits?()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                    }

                    let upcoming = viewModel.upcomingAppointments(appointments: appointments, limit: 3)
                    if upcoming.isEmpty {
                        HStack {
                            Text("No upcoming vet visits scheduled.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button("+ Schedule") {
                                showingAddAppointment = true
                            }
                            .font(.caption.bold())
                            .tint(.purple)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 14))
                    } else {
                        VStack(spacing: 10) {
                            ForEach(upcoming) { appt in
                                UpcomingVisitCard(appointment: appt) {
                                    appt.isCompleted.toggle()
                                    try? modelContext.save()
                                }
                            }
                        }
                    }
                }

                // Recently Added Pets Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Recently Added", systemImage: "pawprint.fill")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)

                        Spacer()

                        Button("View all") {
                            onNavigateToPets?()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                    }

                    let recent = viewModel.recentlyAddedPets(pets: pets, limit: 3)
                    if recent.isEmpty {
                        VStack(spacing: 12) {
                            Text("No pets added yet.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                Button("Add Pet") {
                                    showingAddPet = true
                                }
                                .font(.caption.bold())
                                .buttonStyle(.borderedProminent)
                                .tint(Color.accentColor)

                                Button("Load Sample Data") {
                                    SampleDataService.insertSampleData(context: modelContext)
                                }
                                .font(.caption.bold())
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack(spacing: 10) {
                            ForEach(recent) { pet in
                                NavigationLink {
                                    PetDetailView(pet: pet)
                                } label: {
                                    PetRowCard(pet: pet)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .navigationTitle("Dashboard")
        .sheet(isPresented: $showingAddPet) {
            AddPetView()
        }
        .sheet(isPresented: $showingAddAppointment) {
            AddAppointmentView()
        }
    }

    private var currentDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date.now)
    }
}
