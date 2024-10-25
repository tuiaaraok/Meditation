//
//  PlayerManager.swift
//  Meditation
//
//  Created by Karen Khachatryan on 24.10.24.
//

import AVFoundation

class PlayeManager {
    var playerMusic: AVAudioPlayer?
    var playerSound: AVAudioPlayer?
    
    static var shared = PlayeManager()
    
    private init() {}
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "Fireflies", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            playerMusic = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            playerMusic?.numberOfLoops = -1

            guard let player = playerMusic else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
