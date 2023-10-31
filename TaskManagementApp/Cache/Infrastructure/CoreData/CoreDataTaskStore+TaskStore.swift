//
//  CoreDataTaskStore+TaskStore.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

extension CoreDataTaskStore: TaskStore {
    public func delete(task: LocalTaskItem, completion: @escaping DeleteCompletion) {
        perform { context in
            completion(DeleteResult {
                try ManagedTaskItem.deleteTask(byID: task.id, in: context)
            })
        }
    }
    
    public func insert(task: LocalTaskItem, completion: @escaping InsertCompletion) {
        perform { context in
            completion(InsertResult {
                let managedTaskItem = ManagedTaskItem.newTask(from: task, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping retrieveCompletion) {
        perform { context in
            completion(RetrieveResult(catching: {
                try ManagedTaskItem.allTasks(in: context).map { managedTask in
                    return managedTask.map(\.local)
                }
            }))
        }
    }
}
