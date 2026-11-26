import SwiftUI

public struct PetRowCard: View {
    public let pet: Pet

    public init(pet: Pet) {
        self.pet = pet
    }

    public var body: some View {
        HStack(spacing: 14) {
            // Pet Avatar
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                Image(systemName: pet.speciesIconName)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 54, height: 54)

            // Pet Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if !pet.breed.isEmpty {
                        Text("•  \(pet.breed)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                HStack(spacing: 8) {
                    Label(pet.species, systemImage: "tag.fill")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Label(pet.ageDescription, systemImage: "clock")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                VaccinationBadge(status: pet.vaccinationStatus)
                    .padding(.top, 2)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                if pet.weight > 0 {
                    Text(String(format: "%.1f kg", pet.weight))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(.systemGray6), in: Capsule())
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
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
