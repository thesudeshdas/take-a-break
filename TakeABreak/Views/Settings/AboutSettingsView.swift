import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "eye.trianglebadge.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Take a Break")
                .font(.title)
                .fontWeight(.semibold)

            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Protect your eyes with regular screen breaks using the 20-20-20 rule.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)

            Spacer()

            Text("Built with SwiftUI")
                .font(.caption)
                .foregroundStyle(.tertiary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
