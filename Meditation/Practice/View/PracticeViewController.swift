//
//  PracticeViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit

class PracticeViewController: UIViewController {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    var timer: Timer?
    var elapsedTime: TimeInterval = 0
    var isRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startStopwatch()
    }
    
    func setupUI() {
        self.setNavigationBar(title: "")
        durationLabel.layer.cornerRadius = 3
        durationLabel.layer.borderWidth = 2
        durationLabel.layer.borderColor = UIColor.black.cgColor
        durationLabel.font = .futurespore(size: 40)
        durationLabel.text = formatTime(elapsedTime)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func startStopwatch() {
        timer?.invalidate()
        elapsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopStopwatch() {
        timer?.invalidate()
        timer = nil
    }
    
    func pauseStopwatch() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func resumeStopwatch() {
        if !isRunning {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isRunning = true
        }
    }
    
    @objc func updateTimer() {
        elapsedTime += 1
        durationLabel.text = formatTime(elapsedTime)
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func clickedPauseResume(_ sender: UIButton) {
        if sender.isSelected {
            resumeStopwatch()
            SoundsViewModel.shared.resume()
        } else {
            pauseStopwatch()
        }
        sender.isSelected.toggle()
    }
    
    @IBAction func clickedStop(_ sender: UIButton) {
        pauseButton.isSelected = true
        PracticeViewModel.shared.practiceModel.duration = Int64(elapsedTime)
        pauseStopwatch()
        SoundsViewModel.shared.pause()
        let feelingsVC = FeelingsViewController(nibName: "FeelingsViewController", bundle: nil)
        self.navigationController?.pushViewController(feelingsVC, animated: true)
    }
}
