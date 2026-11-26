import SwiftUI

public struct AppointmentRowCard: View {
    public let appointment: VetAppointment
    public let onToggle: () -> Void

    public init(appointment: VetAppointment, onToggle: @escaping () -> Void) {
        self.appointment = appointment
        self.onToggle = onToggle
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: appointment.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(appointment.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)
            .padding(.top, 2)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(appointment.title)
                        .font(.headline)
                        .strikethrough(appointment.isCompleted, color: .secondary)
                        .foregroundStyle(appointment.isCompleted ? .secondary : .primary)

                    Spacer()

                    if appointment.isUpcoming {
                        Text("Upcoming")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.purple)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.purple.opacity(0.12), in: Capsule())
                    } else if appointment.isCompleted {
                        Text("Completed")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.green)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.green.opacity(0.12), in: Capsule())
                    }
                }

                if let pet = appointment.pet {
                    HStack(spacing: 6) {
                        Image(systemName: pet.speciesIconName)
                            .font(.caption)
                            .foregroundStyle(Color.accentColor)
                        Text("For \(pet.name)")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    Label(appointment.formattedDate, systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Label(appointment.formattedTime, systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if !appointment.clinicName.isEmpty || !appointment.vetName.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "cross.case.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text([appointment.clinicName, appointment.vetName].filter { !$0.isEmpty }.joined(separator: " • "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if !appointment.notes.isEmpty {
                    Text(appointment.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .italic()
                        .padding(.top, 2)
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color(.separator).opacity(0.2), lineWidth: 0.8)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}
