//
//  SoundTableViewCell.swift
//  Meditation
//
//  Created by Karen Khachatryan on 23.10.24.
//

import UIKit
import FDWaveformView
import AVFAudio

class SoundTableViewCell: UITableViewCell {

    @IBOutlet weak var waveformBgView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    var waveFromView: FDWaveformView = FDWaveformView()

    var soundName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func configureCell(with sound: String) {
        soundName = sound
        if let player = SoundsViewModel.shared.audioPlayers[sound] {
            self.durationLabel.text = formatDuration((player.duration - player.currentTime))
        }
        if let waveformView = SoundsViewModel.shared.waveformViews[sound] {
            self.waveFromView = waveformView
            waveFromView.wavesColor = .gray
            waveFromView.progressColor = .white
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(waveformTapped(_:)))
            waveFromView.addGestureRecognizer(tapGesture)
            waveFromView.removeFromSuperview()
            waveFromView.translatesAutoresizingMaskIntoConstraints = false
            waveformBgView.addSubview(waveFromView)
            
            NSLayoutConstraint.activate([
                waveFromView.leadingAnchor.constraint(equalTo: waveformBgView.leadingAnchor, constant: 16),
                waveFromView.topAnchor.constraint(equalTo: waveformBgView.topAnchor, constant: 4),
                waveFromView.bottomAnchor.constraint(equalTo: waveformBgView.bottomAnchor, constant: -4),
                waveFromView.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -16)
            ])
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func clickedStartStop(_ sender: UIButton) {
        guard let soundName = soundName else { return }
        let viewModel = SoundsViewModel.shared
        viewModel.playSound(named: soundName, onStop: {
            self.playPauseButton.isSelected = false
            self.waveFromView.highlightedSamples = 0..<0
        }, onProgress: { [weak self] player in
            guard let self = self else { return }
            self.waveFromView.updateHighlightedSamples(for: player)
            self.durationLabel.text = self.formatDuration((player.duration - player.currentTime))
        })
        
        self.playPauseButton.isSelected = !playPauseButton.isSelected
    }
    
    @objc private func waveformTapped(_ gesture: UITapGestureRecognizer) {
        guard let soundName = soundName, playPauseButton.isSelected else { return }
           let location = gesture.location(in: waveFromView)
           let progress = location.x / waveFromView.bounds.width
           SoundsViewModel.shared.seekTo(progress: progress, for: soundName)
       }
}

extension FDWaveformView {
    func updateHighlightedSamples(for player: AVAudioPlayer) {
        let totalSamples = self.totalSamples
        let progressSamples = Int(CGFloat(player.currentTime / player.duration) * CGFloat(totalSamples))
        self.highlightedSamples = 0..<progressSamples
    }
}
