//
//  RootViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit
import FDWaveformView

class RootViewController: UIViewController {

    var renderingFormCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundsViewModel.shared.preGenerateWaveformViews {
            for form in SoundsViewModel.shared.waveformViews {
                form.value.frame.origin.y = -1000
                self.view.addSubview(form.value)
                form.value.delegate = self
            }
        }
    }
}

extension RootViewController: FDWaveformViewDelegate {
    func waveformViewDidRender(_ waveformView: FDWaveformView) {
        renderingFormCount += 1
        if renderingFormCount == SoundsViewModel.shared.waveformViews.count {
            if let menuVC = storyboard?.instantiateViewController(identifier: "MenuViewController") {
                self.navigationController?.viewControllers = [menuVC]
            }
        }
    }
}
