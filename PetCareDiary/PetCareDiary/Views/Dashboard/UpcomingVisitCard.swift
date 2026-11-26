import SwiftUI

public struct UpcomingVisitCard: View {
    public let appointment: VetAppointment
    public var onToggleCompleted: (() -> Void)? = nil

    public init(appointment: VetAppointment, onToggleCompleted: (() -> Void)? = nil) {
        self.appointment = appointment
        self.onToggleCompleted = onToggleCompleted
    }

    public var body: some View {
        HStack(spacing: 12) {
            // Calendar Date Badge
            VStack(spacing: 2) {
                Text(monthString)
                    .font(.system(size: 10, weight: .bold))
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 2)
                    .background(Color.purple)

                Text(dayString)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 4)
            }
            .frame(width: 48)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.purple.opacity(0.3), lineWidth: 0.8)
            )

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(appointment.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    if let pet = appointment.pet {
                        Label(pet.name, systemImage: pet.speciesIconName)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    if !appointment.clinicName.isEmpty {
                        Text("•")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(appointment.clinicName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Label(appointment.formattedTime, systemImage: "clock")
                    .font(.caption2)
                    .foregroundStyle(.purple)
            }

            Spacer()

            if let onToggleCompleted {
                Button(action: onToggleCompleted) {
                    Image(systemName: appointment.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(appointment.isCompleted ? .green : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color(.separator).opacity(0.2), lineWidth: 0.8)
        )
    }

    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: appointment.date)
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: appointment.date)
    }
}
