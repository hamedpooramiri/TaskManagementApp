//
//  TaskLoader.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

public protocol TaskLoader {
    typealias Result = Swift.Result<[TaskItem], Error>
    func load(completion: @escaping (Result)-> Void)
}
