//
//  TaskItemViewModel.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

public struct TaskItemViewModel: Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public var isCompleted: Bool
    
    public var model: TaskItem {
        TaskItem(id: id, title: title, description: description, isCompleted: isCompleted)
    }
}
