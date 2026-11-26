import SwiftUI

public struct ContentView: View {
    public var onSignOut: (() -> Void)? = nil

    @State private var selectedTab: Int = 0

    public init(onSignOut: (() -> Void)? = nil) {
        self.onSignOut = onSignOut
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView(
                    onNavigateToPets: { selectedTab = 1 },
                    onNavigateToVisits: { selectedTab = 2 },
                    onSignOut: onSignOut
                )
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                PetListView()
            }
            .tabItem {
                Label("My Pets", systemImage: "pawprint.fill")
            }
            .tag(1)

            NavigationStack {
                AppointmentListView()
            }
            .tabItem {
                Label("Vet Visits", systemImage: "cross.case.fill")
            }
            .tag(2)
        }
        .tint(Color.accentColor)
    }
}
