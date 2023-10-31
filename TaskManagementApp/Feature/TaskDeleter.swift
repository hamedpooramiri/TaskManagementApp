//
//  TaskDeleter.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

public protocol TaskDeleter {
    typealias Result = Swift.Result<Void, Error>
    func delete(_ task: TaskItem, completion: @escaping (Result) -> Void)
}
