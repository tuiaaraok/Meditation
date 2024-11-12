//
//  StatisticsViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var practicsTableView: UITableView!
    @IBOutlet weak var statisticsTextView: UITextView!
    private let viewModel = StatisticsViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getPractics { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.practicsTableView.reloadData()
                self.statisticsTextView.text = self.viewModel.totalPracticeTime()
            }
        }
    }
    
    func setupUI() {
        setNavigationBar(title: "")
        let monda = UIFont.mondaRegular(size: 20)
        statisticsTextView.font = .mondaRegular(size: 20)
        practicsTableView.delegate = self
        practicsTableView.dataSource = self
        practicsTableView.register(UINib(nibName: "PracticeTableViewCell", bundle: nil), forCellReuseIdentifier: "PracticeTableViewCell")
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.practics.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeTableViewCell", for: indexPath) as! PracticeTableViewCell
        cell.setupData(practice: viewModel.practics[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
