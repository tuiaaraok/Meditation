//
//  SoundsViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 23.10.24.
//

import UIKit
import AVFAudio

class SoundsViewController: UIViewController {
    @IBOutlet weak var soundsTableView: UITableView!
    private let viewModel = SoundsViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "Choose the music")
        viewModel.delegate = self
        soundsTableView.delegate = self
        soundsTableView.dataSource = self
        soundsTableView.register(UINib(nibName: "SoundTableViewCell", bundle: nil), forCellReuseIdentifier: "SoundTableViewCell")
    }
    
    @IBAction func clickedStart(_ sender: GradientButton) {
        let practiceVC = PracticeViewController(nibName: "PracticeViewController", bundle: nil)
        self.navigationController?.pushViewController(practiceVC, animated: true)
    }
}

extension SoundsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sounds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundTableViewCell", for: indexPath) as! SoundTableViewCell
        cell.configureCell(with: viewModel.sounds[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        18
    }
    
}

extension SoundsViewController: SoundsViewModelDelegate {
    func stop(with sound: String) {
        guard let index = viewModel.sounds.firstIndex(where: { $0 == sound }) else { return }
        if let cell = soundsTableView.cellForRow(at: IndexPath(row: 0, section: index)) as? SoundTableViewCell {
            cell.playPauseButton.isSelected = false
        }
    }
}
