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

    // Support for localization in future
    public private(set) var title: String = "Task Management"
    public private(set) var noTaskFoundTitle = "No tasks found!!!"
    public private(set) var addTaskTitle = "Add Task"
    public private(set) var deleteTitle = "Delete"

    @Published public var taskType: TaskType = .all
    @Published public private(set) var taskItems: [TaskItemViewModel] = [] {
        didSet {
            taskTypeChangeAction(taskType: taskType)
        }
    }
    @Published public private(set) var filteredTaskItems: [TaskItemViewModel] = []

    // MARK: dependencies
    private var onAddTaskButtonPressed: (() -> Void)?
    private let taskLoader: TaskLoader
    private let taskSaver: TaskSaver
    private let taskDeleter: TaskDeleter

    init(taskLoader: TaskLoader, taskSaver: TaskSaver, taskDeleter: TaskDeleter, onAddTaskButtonPressed: @escaping () -> Void) {
        self.taskLoader = taskLoader
        self.taskSaver = taskSaver
        self.taskDeleter = taskDeleter
        self.onAddTaskButtonPressed = onAddTaskButtonPressed
    }

    // MARK: View Life Cycle

    func onViewAppear() {
        loadTasks()
    }
    
    // MARK: View Actions

    public func addTaskButtonPressed() {
        onAddTaskButtonPressed?()
    }

    public func deleteTaskButtonPressed(for task: TaskItemViewModel) {
        taskDeleter.delete(task.model) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.loadTasks()
            default: break
            }
        }
    }

    public func taskTypeChangeAction(taskType: TaskType) {
        switch taskType {
        case .Completed:
            filteredTaskItems = taskItems.filter{ $0.isCompleted }
        case .Ongoing:
            filteredTaskItems = taskItems.filter { !$0.isCompleted }
        case .all:
            filteredTaskItems = taskItems
        }
    }

    public func taskStateChanged(for task: TaskItemViewModel) {
        var clonedTask = task
        clonedTask.isCompleted.toggle()
        taskSaver.update(clonedTask.model) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if let index = self.taskItems.firstIndex(where: { clonedTask.id == $0.id }) {
                    taskItems[index] = clonedTask
                }
            default: break
            }
        }
    }

    // MARK: Services
    func loadTasks() {
        taskLoader.load { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                taskItems = tasks.map {
                    TaskItemViewModel(id: $0.id, title: $0.title ?? "no Title", description: $0.description ?? "no description", isCompleted: $0.isCompleted)
                }
            default: break
            }
        }
    }
}
