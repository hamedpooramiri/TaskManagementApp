//
//  TaskStore.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

public protocol TaskStore {

    typealias DeleteResult = Result<Void, Error>
    typealias DeleteCompletion = (DeleteResult) -> Void

    typealias InsertResult = Result<Void, Error>
    typealias InsertCompletion = (InsertResult) -> Void

    typealias UpdateResult = Result<Void, Error>
    typealias UpdateCompletion = (UpdateResult) -> Void

    typealias RetrieveResult = Result<[LocalTaskItem]?, Error>
    typealias retrieveCompletion = (RetrieveResult) -> Void

    func delete(task: LocalTaskItem, completion: @escaping DeleteCompletion)
    func insert(task: LocalTaskItem, completion: @escaping InsertCompletion)
    func update(task: LocalTaskItem, completion: @escaping UpdateCompletion)
    func retrieve(completion: @escaping retrieveCompletion)
}
