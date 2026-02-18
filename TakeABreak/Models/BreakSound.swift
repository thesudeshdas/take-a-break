import Foundation

enum BreakSoundType: String, Codable, CaseIterable, Identifiable {
    case chime
    case bell
    case natureBirds = "nature-birds"
    case water
    case silence

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .chime: "Chime"
        case .bell: "Bell"
        case .natureBirds: "Nature Birds"
        case .water: "Water"
        case .silence: "No Sound"
        }
    }

    var systemSoundName: String? {
        switch self {
        case .chime: "Tink"
        case .bell: "Glass"
        case .natureBirds: "Breeze"
        case .water: "Submarine"
        case .silence: nil
        }
    }
}
