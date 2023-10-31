//
//  TaskStoreSpy.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation
import TaskManagementApp

class TaskStoreSpy: TaskStore {
    
    enum ReceivedMessage: Equatable {
        case deleteTask
        case insertTask(task: LocalTaskItem)
        case retrieve
    }
    
    var receivedMessages: [ReceivedMessage] = []
    
    private var capturedDeleteCompletions: [DeleteCompletion] = []
    private var capturedInsertionCompletions: [InsertCompletion] = []
    private var capturedRetrieveCompletions: [retrieveCompletion] = []
    
    
    
    func delete(task: LocalTaskItem, completion: @escaping DeleteCompletion) {
        receivedMessages.append(.deleteTask)
        capturedDeleteCompletions.append(completion)
    }
    
    func insert(task: LocalTaskItem, completion: @escaping InsertCompletion) {
        capturedInsertionCompletions.append(completion)
        receivedMessages.append(.insertTask(task: task))
    }
    
    func retrieve(completion: @escaping retrieveCompletion) {
        capturedRetrieveCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    
    func completeDelete(with error: Error, at index: Int = 0) {
        capturedDeleteCompletions[index](.failure(error))
    }
    
    func completeDeleteSuccessfully(at index: Int = 0) {
        capturedDeleteCompletions[index](.success(()))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        capturedInsertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        capturedInsertionCompletions[index](.success(()))
    }

    func completeRetrieve(with error: Error, at index: Int = 0) {
        capturedRetrieveCompletions[index](.failure(error))
    }
    
    func completeRetrieveWithEmptyCache(at index: Int = 0) {
        capturedRetrieveCompletions[index](.success(nil))
    }
    
    func completeRetrieve(with tasks: [LocalTaskItem], at index: Int = 0) {
        capturedRetrieveCompletions[index](.success(tasks))
    }
}
