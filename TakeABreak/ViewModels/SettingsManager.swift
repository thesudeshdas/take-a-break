import Foundation
import Observation

@Observable
final class SettingsManager {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard
    private let configKey = "breakConfiguration"

    var configuration: BreakConfiguration {
        didSet {
            save()
        }
    }

    private init() {
        if let data = defaults.data(forKey: configKey),
           let config = try? JSONDecoder().decode(BreakConfiguration.self, from: data) {
            self.configuration = config
        } else {
            self.configuration = BreakConfiguration()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(configuration) {
            defaults.set(data, forKey: configKey)
        }
    }

    func resetToDefaults() {
        configuration = BreakConfiguration()
    }
}
