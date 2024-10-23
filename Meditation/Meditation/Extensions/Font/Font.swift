//
//  Font.swift
//  Meditation
//
//  Created by Karen Khachatryan on 23.10.24.
//

import Foundation
import UIKit

extension UIFont {
    static func interItalic(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-LightItalic", size: CGFloat(size))
    }
    
    static func interRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: CGFloat(size))
    }
    
    static func futurespore(size: CFloat) -> UIFont? {
        return UIFont(name: "futuresporecyrillic", size: CGFloat(size))
    }
}
