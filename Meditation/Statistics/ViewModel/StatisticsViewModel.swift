//
//  StatisticsViewModel.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import Foundation

class StatisticsViewModel {
    static let shared = StatisticsViewModel()
    var practics: [PracticeModel] = []
    private init() {}
    
    func getPractics(completion: @escaping () -> Void) {
        CoreDataManager.shared.fetchPractics { [weak self] practics, error in
            guard let self = self else { return }
            self.practics = practics
            completion()
        }
    }
    
    func totalPracticeTime() -> String {
        let totalDuration = practics.compactMap { $0.duration }.reduce(0, +)
        let hours = totalDuration / 3600
        let minutes = (totalDuration % 3600) / 60
        let seconds = totalDuration % 60
        var components: [String] = []
        if hours > 0 {
            components.append("\(hours) hour\(hours > 1 ? "s" : "")")
        }
        if minutes > 0 {
            components.append("\(minutes) minute\(minutes > 1 ? "s" : "")")
        }
        if seconds > 0 || components.isEmpty { // Always show seconds if everything else is 0
            components.append("\(seconds) second\(seconds > 1 ? "s" : "")")
        }
        let timeString = joinWithAnd(components: components)
        return "You've been practicing for \(timeString) all the time"
    }
    
    private func joinWithAnd(components: [String]) -> String {
        guard components.count > 1 else {
            return components.first ?? ""
        }
        let allButLast = components.dropLast().joined(separator: ", ")
        return "\(allButLast) and \(components.last!)"
    }
}
