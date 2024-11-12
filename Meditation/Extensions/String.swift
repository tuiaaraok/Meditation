//
//  String.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import Foundation

extension String? {
    func checkValidation() -> Bool {
        guard let self = self else { return false }
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
