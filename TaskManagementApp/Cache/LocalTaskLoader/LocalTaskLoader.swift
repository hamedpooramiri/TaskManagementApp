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

}

extension LocalTaskLoader: TaskLoader {

    public typealias LoadResult = TaskLoader.Result

    public func load(completion: @escaping (LoadResult)-> Void) {
        store.retrieve { [weak self ] result in
            guard let self = self else { return }
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
        store.deleteTask { [weak self] deletionError in
            guard self != nil else { return }
            completion(deletionError)
        }
    }

}
