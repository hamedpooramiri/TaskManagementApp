//
//  TaskListComposer.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

public final class TaskListComposer {
    private init() {}
    public static func compose(taskLoader: TaskLoader, taskSaver: TaskSaver, taskDeleter: TaskDeleter,
                               onAddTaskButtonPressed: @escaping ()-> Void) -> TaskListView {
        let viewModel = TaskListViewModel(taskLoader: taskLoader, taskSaver: taskSaver, taskDeleter: taskDeleter,
                                          onAddTaskButtonPressed: onAddTaskButtonPressed)
        let view = TaskListView(viewModel: viewModel)
        return view
    }
}
