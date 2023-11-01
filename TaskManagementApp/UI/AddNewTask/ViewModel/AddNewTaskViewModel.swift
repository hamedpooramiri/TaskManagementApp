//
//  AddNewTaskViewModel.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import Foundation

public class AddNewTaskViewModel: ObservableObject {
    
    // Support for localization in future
    public let title: String = "Add New Task"
    public let saveTitle: String = "Save Task"
    public let taskTitleMessage: String = "Task Title"
    public let taskDescriptionMessage: String = "Task description"

    @Published public private(set) var isSaving: Bool = false

    // MARK: dependencies
    private let taskSaver: TaskSaver
    private var onDismiss: (() -> Void)?

    init(taskSaver: TaskSaver, onDismiss: (@escaping () -> Void)) {
        self.taskSaver = taskSaver
        self.onDismiss = onDismiss
    }

    public func saveTaskPressed(withTitle title: String, description: String) {
        isSaving = true
        let taskItem = TaskItem(id: UUID(),
                                title: title.isEmpty ? "No Titled Task" : title,
                                description: description.isEmpty ? "No description for this Task" : description,
                                isCompleted: false)
        taskSaver.save(taskItem) { [weak self] result in
            self?.isSaving = false
            self?.backPressed()
        }
    }

    public func backPressed() {
        onDismiss?()
    }

}
