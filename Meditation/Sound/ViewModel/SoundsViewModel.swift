//
//  SoundsViewModel.swift
//  Meditation
//
//  Created by Karen Khachatryan on 24.10.24.
//

import Foundation
import UIKit
import FDWaveformView
import AVFoundation

protocol SoundsViewModelDelegate: AnyObject {
    func stop(with sound: String)
}

class SoundsViewModel {
    static let shared = SoundsViewModel()
    weak var delegate: SoundsViewModelDelegate?
    let sounds = ["Fireflies", "gentle-awareness", "shrine", "ambient-jam","blurry-dreams", "boundless", "deep-immersion", "equilibrium", "in-stillness", "luminance"]
    
    var preloadedWaveforms: [String: FDWaveformView] = [:]
    var audioPlayers: [String: AVAudioPlayer] = [:]
    private var currentSoundName: String?
    private var progressUpdateTimer: Timer?
    var waveformViews: [String: FDWaveformView] = [:]
    
    private let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    private init() {
        preloadAudioPlayers()
    }
    
    private func preloadAudioPlayers() {
        for sound in sounds {
            if let url = Bundle.main.url(forResource: sound, withExtension: "mp3") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    audioPlayers[sound] = player
                } catch {
                    print("Failed to load \(sound): \(error)")
                }
            }
        }
    }
    
    func stopSound(sound: String, player: AVAudioPlayer) {
        player.stop()
        player.currentTime = 0
        delegate?.stop(with: sound)
    }
    
    func playSound(named sound: String, onStop: @escaping () -> Void, onProgress: @escaping (AVAudioPlayer) -> Void) {
        if let currentSound = currentSoundName {
            if let currentPlayer = audioPlayers[currentSound] {
                if sound == currentSound {
                    if currentPlayer.isPlaying {
                        currentPlayer.pause()
                    } else {
                        currentPlayer.play()
                        startProgressUpdates(for: currentPlayer, onProgress: onProgress)
                    }
                } else {
                    stopSound(sound: currentSound, player: currentPlayer)
                    if let player = audioPlayers[sound] {
                        player.play()
                        currentSoundName = sound
                        startProgressUpdates(for: player, onProgress: onProgress)
                    }
                }
            }
        } else {
            if let player = audioPlayers[sound] {
                player.play()
                currentSoundName = sound
                startProgressUpdates(for: player, onProgress: onProgress)
            }
        }
    }
    
    func seekTo(progress: CGFloat, for sound: String) {
        guard let player = audioPlayers[sound] else { return }
        let newTime = Double(progress) * player.duration
        player.currentTime = newTime
        player.play()
    }
    
    func stopPlayer() {
        if let currentSound = currentSoundName, let player = audioPlayers[currentSound] {
            player.stop()
            player.currentTime = 0
        }
    }
    
    func pause() {
        if let currentSound = currentSoundName, let player = audioPlayers[currentSound] {
            player.pause()
        }
    }
    
    func resume() {
        if let currentSound = currentSoundName, let player = audioPlayers[currentSound] {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    
    private func startProgressUpdates(for player: AVAudioPlayer, onProgress: @escaping (AVAudioPlayer) -> Void) {
        progressUpdateTimer?.invalidate()
        progressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            onProgress(player)
        }
    }
    
    func stopCurrentPlayback() {
        progressUpdateTimer?.invalidate()
    }
    
    func preGenerateWaveformViews(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        for sound in sounds {
            if waveformViews[sound] == nil {
                group.enter()
                generateWaveformView(for: sound) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("All waveform views pre-generated.")
            completion()
        }
    }
    
    private func generateWaveformView(for sound: String, completion: @escaping () -> Void) {
        guard let audioURL = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            completion()
            return
        }
        
        let waveformView = FDWaveformView()
        waveformView.audioURL = audioURL
        waveformView.frame.size = CGSize(width: 300, height: 80)
        self.waveformViews[sound] = waveformView
        let bgView = UIView()
        bgView.addSubview(waveformView)
        completion()
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                
            }
        }
    }
}
