import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
public final class AuthViewModel {
    public var isAuthenticated: Bool = false
    public var username: String = ""
    public var password: String = ""
    public var errorMessage: String? = nil
    public var isAuthenticating: Bool = false
    public var hasAttemptedInitialBiometric: Bool = false

    private let biometricService = BiometricAuthService()

    public init() {}

    public var biometricName: String {
        biometricService.biometryType.displayName
    }

    public var biometricButtonTitle: String {
        "Continue with \(biometricName)"
    }

    public var biometricIcon: String {
        biometricService.biometryType.systemImage
    }

    public var isBiometricAvailable: Bool {
        biometricService.canAuthenticateWithBiometrics
    }

    public func authenticateWithBiometrics() async {
        guard !isAuthenticating else { return }
        isAuthenticating = true
        errorMessage = nil

        let result = await biometricService.authenticate()
        isAuthenticating = false

        if result.success {
            isAuthenticated = true
            errorMessage = nil
        } else {
            errorMessage = result.errorMessage
        }
    }

    public func signInWithCredentials() {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanUsername.isEmpty else {
            errorMessage = "Please enter your username."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        // Demo fallback verification
        // Supports demo account 'petowner' / '123456'
        // and also accepts any local username with minimum 6 characters password
        if (cleanUsername.lowercased() == "petowner" && password == "123456") ||
           (!cleanUsername.isEmpty && password.count >= 6) {
            isAuthenticated = true
            errorMessage = nil
        } else {
            errorMessage = "Invalid username or password. Demo login is petowner / 123456."
        }
    }

    public func fillDemoCredentials() {
        username = "petowner"
        password = "123456"
        errorMessage = nil
    }

    public func signOut() {
        isAuthenticated = false
        password = ""
        errorMessage = nil
    }
}
