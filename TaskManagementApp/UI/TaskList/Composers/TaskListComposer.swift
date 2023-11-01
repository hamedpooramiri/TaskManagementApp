//
//  TaskListComposer.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

public final class TaskListComposer {
    private init() {}
    public static func compose(taskLoader: TaskLoader,
                               taskSaver: TaskSaver,
                               taskDeleter: TaskDeleter,
                               onAddTaskButtonPressed: @escaping ()-> Void) -> TaskListView {
        let viewModel = TaskListViewModel(taskLoader: MainQueueDispatchDecorator(decoratee: taskLoader),
                                          taskSaver: MainQueueDispatchDecorator(decoratee: taskSaver),
                                          taskDeleter: MainQueueDispatchDecorator(decoratee: taskDeleter),
                                          onAddTaskButtonPressed: onAddTaskButtonPressed)
        let view = TaskListView(viewModel: viewModel)
        return view
    }
}
