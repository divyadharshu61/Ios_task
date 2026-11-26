import SwiftUI

public struct LoginView: View {
    @Bindable public var authViewModel: AuthViewModel

    @State private var isPasswordVisible: Bool = false

    public init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                // App Branding Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentColor, Color.teal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)
                            .shadow(color: Color.accentColor.opacity(0.35), radius: 12, x: 0, y: 6)

                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 46))
                            .foregroundStyle(.white)
                    }

                    Text("Pet Care Diary")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    Text("A happy, healthy life for every pet companion.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)

                // Biometric Unlock Button (Face ID / Touch ID)
                VStack(spacing: 10) {
                    Button {
                        Task {
                            await authViewModel.authenticateWithBiometrics()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            if authViewModel.isAuthenticating {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: authViewModel.biometricIcon)
                                    .font(.title3.weight(.semibold))
                            }

                            Text(authViewModel.biometricButtonTitle)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(authViewModel.isAuthenticating)
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)

                    Text("Biometric security keeps your pet records private.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 28)

                // Divider
                HStack {
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 0.8)
                    Text("OR SIGN IN WITH PASSWORD")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 0.8)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 4)

                // Fallback Credentials Form
                VStack(spacing: 14) {
                    // Username
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        TextField("Username", text: $authViewModel.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding(13)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                    // Password
                    HStack(spacing: 10) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.secondary)
                            .frame(width: 20)

                        if isPasswordVisible {
                            TextField("Password (min 6 chars)", text: $authViewModel.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } else {
                            SecureField("Password (min 6 chars)", text: $authViewModel.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(13)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                    // Sign In Button
                    Button {
                        authViewModel.signInWithCredentials()
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                    }
                    .buttonStyle(.bordered)
                    .tint(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(
                        authViewModel.username.trimmingCharacters(in: .whitespaces).isEmpty ||
                        authViewModel.password.count < 6
                    )
                }
                .padding(.horizontal, 28)

                // Error Message if any
                if let error = authViewModel.errorMessage {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(error)
                    }
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 28)
                    .multilineTextAlignment(.center)
                }

                Spacer(minLength: 20)

                // Demo Credentials Helper
                VStack(spacing: 6) {
                    Text("Demo account: petowner / 123456")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Button("Auto-fill Demo Credentials") {
                        authViewModel.fillDemoCredentials()
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                }
                .padding(.bottom, 24)
            }
        }
        .task {
            if !authViewModel.hasAttemptedInitialBiometric {
                authViewModel.hasAttemptedInitialBiometric = true
                await authViewModel.authenticateWithBiometrics()
            }
        }
    }
}
