//
//  Date.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
