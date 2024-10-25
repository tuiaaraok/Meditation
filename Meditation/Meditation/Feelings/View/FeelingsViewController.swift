//
//  FeelingsViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit

class FeelingsViewController: UIViewController {

    @IBOutlet weak var feelingsTextView: BaseTextView!
    @IBOutlet weak var smileTitle: UILabel!
    private let viewModel = PracticeViewModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        setNavigationBar(title: "")
        feelingsTextView.font = .interRegular(size: 16)
        feelingsTextView.placeholder = "Enter your feelings during practice"
        feelingsTextView.baseDelegate = self
        feelingsTextView.addShadow()
        smileTitle.font = .futurespore(size: 20)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func chooseSmile(_ sender: UIButton) {
        viewModel.practiceModel.feelings = sender.tag
    }
}

extension FeelingsViewController: BaseTextViewDelegate {
    func didChancheSelection(_ textView: UITextView) {
        viewModel.practiceModel.feelingsDescription = textView.text
    }
}
