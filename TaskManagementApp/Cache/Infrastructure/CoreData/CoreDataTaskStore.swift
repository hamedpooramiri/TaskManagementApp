//
//  CoreDataTaskStore.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation
import CoreData

public class CoreDataTaskStore {
    
    private static let modelName = "TaskStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataTaskStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataTaskStore.model else {
            throw StoreError.modelNotFound
        }
        do {
            container = try NSPersistentContainer.load(name: CoreDataTaskStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext)-> Void) {
        let context = self.context
        context.perform { action(context) }
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
