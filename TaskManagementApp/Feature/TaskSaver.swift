//
//  TaskCacher.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

public protocol TaskSaver {
    typealias Result = Swift.Result<Void, Error>
    func save(_ task: TaskItem, completion: @escaping (Result) -> Void)
    func update(_ task: TaskItem, completion: @escaping (Result) -> Void)
}
