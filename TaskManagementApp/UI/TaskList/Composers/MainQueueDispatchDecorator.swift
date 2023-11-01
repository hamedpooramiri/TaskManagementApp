//
//  MainQueueDispatchDecorator.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

final public class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    private func dispatch(completion: @escaping ()-> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: TaskLoader where T == TaskLoader {
    public func load(completion: @escaping (TaskLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: TaskSaver where T == TaskSaver {
    public func save(_ task: TaskItem, completion: @escaping (TaskSaver.Result) -> Void) {
        decoratee.save(task) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }

    public func update(_ task: TaskItem, completion: @escaping (TaskSaver.Result) -> Void) {
        decoratee.update(task) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: TaskDeleter where T == TaskDeleter {
    public func delete(_ task: TaskItem, completion: @escaping (TaskDeleter.Result) -> Void) {
        decoratee.delete(task) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
