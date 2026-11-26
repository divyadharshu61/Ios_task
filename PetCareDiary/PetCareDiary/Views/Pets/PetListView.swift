import SwiftUI
import SwiftData

public struct PetListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pet.name) private var pets: [Pet]

    @State private var viewModel = PetViewModel()
    @State private var showingAddPet = false
    @State private var petToDelete: Pet?
    @State private var showingDeleteAlert = false

    public init() {}

    public var body: some View {
        VStack(spacing: 8) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search pets by name, breed, or species...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.top, 4)

            // Species Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.speciesOptions, id: \.self) { species in
                        SpeciesFilterChip(
                            title: species,
                            isSelected: viewModel.selectedSpecies == species
                        ) {
                            viewModel.selectedSpecies = species
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }

            // Status Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(viewModel.statusOptions, id: \.self) { status in
                        Button {
                            viewModel.selectedStatus = status
                        } label: {
                            Text(status)
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(viewModel.selectedStatus == status ? Color.primary.opacity(0.14) : Color.clear, in: Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color(.separator).opacity(0.35), lineWidth: 0.8)
                                )
                                .foregroundStyle(viewModel.selectedStatus == status ? .primary : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
            }

            let filtered = viewModel.filteredPets(pets)

            if filtered.isEmpty {
                Spacer()
                if pets.isEmpty {
                    ContentUnavailableView(
                        "No Pets Yet",
                        systemImage: "pawprint",
                        description: Text("Add your pets to keep track of their vaccination schedules and veterinary care.")
                    )
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 10) {
                            Button {
                                showingAddPet = true
                            } label: {
                                Label("Add First Pet", systemImage: "plus")
                                    .font(.subheadline.bold())
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color.accentColor)

                            Button {
                                SampleDataService.insertSampleData(context: modelContext)
                            } label: {
                                Text("Load Sample Demo Data")
                                    .font(.footnote.weight(.semibold))
                            }
                        }
                        .padding(.horizontal, 36)
                        .padding(.bottom, 40)
                    }
                } else {
                    ContentUnavailableView(
                        "No Matching Pets",
                        systemImage: "magnifyingglass",
                        description: Text("Try adjusting your search terms or filter selection.")
                    )
                    .overlay(alignment: .bottom) {
                        Button("Reset Filters") {
                            viewModel.searchText = ""
                            viewModel.selectedSpecies = "All"
                            viewModel.selectedStatus = "All"
                        }
                        .buttonStyle(.bordered)
                        .padding(.bottom, 50)
                    }
                }
                Spacer()
            } else {
                List {
                    ForEach(filtered) { pet in
                        NavigationLink {
                            PetDetailView(pet: pet)
                        } label: {
                            PetRowCard(pet: pet)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                petToDelete = pet
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
        .navigationTitle("My Pets")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddPet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPet) {
            AddPetView()
        }
        .alert("Delete \(petToDelete?.name ?? "this pet")?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                petToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let petToDelete {
                    try? viewModel.deletePet(petToDelete, context: modelContext)
                }
                petToDelete = nil
            }
        } message: {
            Text("This will permanently remove this pet profile.")
        }
    }
}
