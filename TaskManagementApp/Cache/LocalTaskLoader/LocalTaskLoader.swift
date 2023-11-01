//
//  LocalTaskLoader.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

public final class LocalTaskLoader {

    private var store: TaskStore

    public init(store: TaskStore) {
        self.store = store
    }

}

extension LocalTaskLoader: TaskSaver {

    public typealias SaveResult = TaskSaver.Result

    public func save(_ task: TaskItem, completion: @escaping (SaveResult) -> Void){
        let localTask = LocalTaskItem(id: task.id, title: task.title, description: task.description, isCompleted: task.isCompleted)
        store.insert(task: localTask) { [weak self] insertionError in
            guard self != nil else { return }
            completion(insertionError)
        }
    }

    public func update(_ task: TaskItem, completion: @escaping (SaveResult) -> Void) {
        let localTask = LocalTaskItem(id: task.id, title: task.title, description: task.description, isCompleted: task.isCompleted)
        store.update(task: localTask) { [weak self] updateError in
            guard self != nil else { return }
            completion(updateError)
        }
    }
}

extension LocalTaskLoader: TaskLoader {

    public typealias LoadResult = TaskLoader.Result

    public func load(completion: @escaping (LoadResult)-> Void) {
        store.retrieve { [weak self ] result in
            guard self != nil else { return }
            switch result {
            case let .success(.some(cache)):
                completion(.success(cache.toModel()))
            case let .failure(error):
                completion(.failure(error))
            case .success(.none):
                completion(.success([]))
            }
        }
    }
}

extension LocalTaskLoader: TaskDeleter {

    public typealias DeleteResult = TaskDeleter.Result

    public func delete(_ task: TaskItem, completion: @escaping (DeleteResult) -> Void) {
        let localTask = LocalTaskItem(id: task.id, title: task.title, description: task.description, isCompleted: task.isCompleted)
        store.delete(task: localTask) { [weak self] deletionError in
            guard self != nil else { return }
            completion(deletionError)
        }
    }

}
