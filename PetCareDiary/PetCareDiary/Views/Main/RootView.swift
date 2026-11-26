import SwiftUI

public struct RootView: View {
    @State private var authViewModel = AuthViewModel()

    public init() {}

    public var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                ContentView(onSignOut: {
                    authViewModel.signOut()
                })
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}
