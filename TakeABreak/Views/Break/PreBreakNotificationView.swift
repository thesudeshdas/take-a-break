import SwiftUI

struct PreBreakNotificationView: View {
    let countdown: PreBreakCountdown

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "eye.fill")
                .font(.title2)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 2) {
                Text("Break starting soon")
                    .font(.headline)
                Text("in \(countdown.seconds) seconds")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
        }
    }
}
