//
//  AddNewTaskComposer.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

public final class AddNewTaskComposer {
    private init() {}
    public static func compose(taskSaver: TaskSaver, onDismiss: (@escaping () -> Void)) -> AddNewTaskView {
        let viewModel = AddNewTaskViewModel(taskSaver: taskSaver, onDismiss: onDismiss)
        let view = AddNewTaskView(viewModel: viewModel)
        return view
    }
}
