//
//  PracticeViewModel.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import Foundation

class PracticeViewModel {
    static let shared = PracticeViewModel()
    var practiceModel = PracticeModel(id: UUID())
    private init() {}
    
    func clear() {
        practiceModel = PracticeModel(id: UUID())
    }
}
