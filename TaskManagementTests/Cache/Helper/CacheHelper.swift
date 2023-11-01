//
//  CacheHelper.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation
import TaskManagementApp

func uniqueTaskItem() -> TaskItem {
    TaskItem(id: UUID(), title: "any description", description: "any location", isCompleted: false)
}

func uniqueLocalTaskItem(id: UUID = UUID()) -> (model: TaskItem, local: LocalTaskItem) {
    return (TaskItem(id: id, title: "any description", description: "any location", isCompleted: false),
            LocalTaskItem(id: id, title: "any description", description: "any location", isCompleted: false))
}
