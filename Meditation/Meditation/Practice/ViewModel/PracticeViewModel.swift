//
//  PracticeViewModel.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import Foundation

class PracticeViewModel {
    static let shared = PracticeViewModel()
    @Published var practiceModel = PracticeModel(id: UUID(), date: Date())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.savePractice(practiceModel: practiceModel) { error in
            completion(error)
        }
    }
    
    func clear() {
        practiceModel = PracticeModel(id: UUID(), date: Date())
    }
}
