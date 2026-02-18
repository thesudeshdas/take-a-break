import AppKit

final class SoundService {
    func playSound(_ sound: BreakSoundType, volume: Double, enabled: Bool) {
        guard enabled, let soundName = sound.systemSoundName else { return }

        if let nsSound = NSSound(named: NSSound.Name(soundName)) {
            nsSound.volume = Float(volume)
            nsSound.play()
        }
    }
}
