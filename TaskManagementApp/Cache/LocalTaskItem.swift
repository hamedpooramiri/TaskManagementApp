//
//  LocalTaskItem.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

public struct LocalTaskItem: Equatable {
    public let id: UUID
    public let title: String?
    public let description: String?
    public let isCompleted: Bool
    
    public init(id: UUID, title: String?, description: String?, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }

    public var model: TaskItem {
        TaskItem(id: id, title: title, description: description, isCompleted: isCompleted)
    }
}

extension Array where Element == LocalTaskItem {
    func toModel() -> [TaskItem] {
        map(\.model)
    }
}
