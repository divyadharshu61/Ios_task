import SwiftUI
import SwiftData

@main
struct PetCareDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Pet.self, VetAppointment.self])
    }
}
