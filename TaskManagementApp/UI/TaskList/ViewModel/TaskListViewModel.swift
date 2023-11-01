//
//  TaskListViewModel.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

public class TaskListViewModel: ObservableObject {
    
    public enum TaskType: String, CaseIterable, Identifiable {
        public var id: Self { self }
        case all
        case Ongoing
        case Completed
    }

    public var title: String = "Task Management"
    @Published public var taskType: TaskType = .all
    @Published public var taskItems: [TaskItemViewModel] = [
        TaskItemViewModel(id: UUID(), title: "task", description: "description", isCompleted: true),
        TaskItemViewModel(id: UUID(), title: "task", description: "description", isCompleted: false)
    ]
    
    
    public func addTaskButtonPressed() {
        
    }

    public func deleteTaskButtonPressed(for task: TaskItemViewModel) {
        taskItems.firstIndex(where: { task.id == $0.id }).map { index in
            taskItems.remove(at: index)
        }
    }

    public func taskTypeChangeAction(taskType: TaskType) {
        
    }
    
    public func taskStateChanged(for task: TaskItemViewModel) {
        if let index = taskItems.firstIndex(where: { task.id == $0.id }) {
            var newTask = task
            newTask.isCompleted.toggle()
            taskItems[index] = newTask
        }
    }
}

public struct TaskItemViewModel: Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public var isCompleted: Bool
}
