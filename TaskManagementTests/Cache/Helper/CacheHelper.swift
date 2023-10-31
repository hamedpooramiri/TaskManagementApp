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
