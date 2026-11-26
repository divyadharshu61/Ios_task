import Foundation
import LocalAuthentication

@MainActor
public final class BiometricAuthService {

    public enum BiometryType {
        case faceID
        case touchID
        case opticID
        case none

        public var displayName: String {
            switch self {
            case .faceID: return "Face ID"
            case .touchID: return "Touch ID"
            case .opticID: return "Optic ID"
            case .none: return "Face ID"
            }
        }

        public var systemImage: String {
            switch self {
            case .faceID: return "faceid"
            case .touchID: return "touchid"
            default: return "faceid"
            }
        }
    }

    public init() {}

    public var biometryType: BiometryType {
        let context = LAContext()
        var error: NSError?
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .opticID:
            return .opticID
        default:
            return .faceID
        }
    }

    public var canAuthenticateWithBiometrics: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    public func authenticate() async -> (success: Bool, errorMessage: String?) {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Use Password"
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            let reason = error?.localizedDescription ?? "Face ID is not available on this device. Please sign in with your password."
            return (false, reason)
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Face ID is used to securely unlock your Pet Care Diary"
            )
            return (success, success ? nil : "Authentication failed. Please try again.")
        } catch let laError as LAError {
            switch laError.code {
            case .userCancel:
                return (false, "Authentication was cancelled.")
            case .userFallback:
                return (false, "Please use your password to sign in.")
            case .biometryNotEnrolled:
                return (false, "Face ID is not enrolled on this device. Use local sign in.")
            case .biometryLockout:
                return (false, "Face ID is locked due to multiple attempts. Please enter device passcode.")
            case .appCancel:
                return (false, "Authentication was cancelled by the app.")
            default:
                return (false, laError.localizedDescription)
            }
        } catch {
            return (false, error.localizedDescription)
        }
    }
}
