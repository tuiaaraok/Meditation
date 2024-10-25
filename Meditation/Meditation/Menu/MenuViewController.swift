//
//  ViewController.swift
//  Meditation
//
//  Created by Karen Khachatryan on 23.10.24.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func clickedStart(_ sender: UIButton) {
        self.pushViewController(SoundsViewController.self, animated: true)
    }
    
    @IBAction func clickedStatistics(_ sender: UIButton) {
    }
    
    @IBAction func clickedInfo(_ sender: UIButton) {
    }
}

