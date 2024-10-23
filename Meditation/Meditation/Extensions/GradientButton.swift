//
//  GradientButton.swift
//  Meditation
//
//  Created by Karen Khachatryan on 23.10.24.
//

import UIKit

class GradientButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        commonInit()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         commonInit()
     }
    
    func commonInit() {
        self.titleLabel?.font = .futurespore(size: 32)
        self.setTitleColor(.buttonTitle, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientBackground()
    }
}
