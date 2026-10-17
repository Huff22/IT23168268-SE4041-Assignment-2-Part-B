//
//  Untitled.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playEnvironmentSound(filename: String) {
        // Stop any currently playing sound first
        stop()
        
        // Assuming your files are .mp3 (change to .wav or .m4a if needed)
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Audio file not found: \(filename).mp3")
            return
        }
        
        do {
            // Configure tvOS audio session to mix with other system sounds smoothly
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            
            // Fade in the audio smoothly
            audioPlayer?.volume = 0
            audioPlayer?.play()
            audioPlayer?.setVolume(1.0, fadeDuration: 2.0)
            
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        // Fade out before stopping completely
        audioPlayer?.setVolume(0.0, fadeDuration: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
    }
}
