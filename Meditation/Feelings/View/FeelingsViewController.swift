//
//  FeelingsViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit
import Combine

class FeelingsViewController: UIViewController {

    @IBOutlet weak var feelingsTextView: BaseTextView!
    @IBOutlet weak var smileTitle: UILabel!
    @IBOutlet weak var saveButton: GradientButton!
    private let viewModel = PracticeViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }

    func setupUI() {
        setNavigationBar(title: "")
        feelingsTextView.font = .interRegular(size: 16)
        feelingsTextView.placeholder = "Enter your feelings during practice"
        feelingsTextView.baseDelegate = self
        feelingsTextView.addShadow()
        smileTitle.font = .futurespore(size: 20)
        saveButton.isEnabled = false
    }
    
    func subscribe() {
        viewModel.$practiceModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] practiceModel in
                guard let self = self else { return }
                self.feelingsTextView.text = practiceModel.feelingsDescription
                self.saveButton.isEnabled = (practiceModel.feelings != nil && practiceModel.feelingsDescription.checkValidation())
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func chooseSmile(_ sender: UIButton) {
        viewModel.practiceModel.feelings = sender.tag
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension FeelingsViewController: BaseTextViewDelegate {
    func didChancheSelection(_ textView: UITextView) {
        viewModel.practiceModel.feelingsDescription = textView.text
    }
}
