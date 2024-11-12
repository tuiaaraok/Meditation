//
//  CoreDataManager.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Meditation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func savePractice(practiceModel: PracticeModel, completion: @escaping (Error?) -> Void) {
        let id = practiceModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let practice: Practice

                if let existingPractice = results.first {
                    practice = existingPractice
                } else {
                    practice = Practice(context: backgroundContext)
                    practice.id = id
                }
                practice.date = practiceModel.date
                practice.duration = practiceModel.duration ?? 0
                practice.feelings = Int32(practiceModel.feelings ?? 0)
                practice.feelingsDescription = practiceModel.feelingsDescription
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPractics(completion: @escaping ([PracticeModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var practicsModel: [PracticeModel] = []
                for result in results {
                    let practiceModel = PracticeModel(id: result.id, date: result.date, duration: result.duration, feelings: Int(result.feelings), feelingsDescription: result.feelingsDescription)
                    practicsModel.append(practiceModel)
                }
                completion(practicsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}
