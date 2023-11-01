//
//  AddNewTaskView.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import SwiftUI

public struct AddNewTaskView: View {

    @State private var taskTitle: String = ""
    @State private var taskDescription: String = ""

    @ObservedObject private var viewModel: AddNewTaskViewModel
    
    init(viewModel: AddNewTaskViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        LoadingView(isShowing: $viewModel.isSaving) {
            VStack(spacing: 12) {
                makeTitleView()
                makeTitleTextfieldView()
                Divider()
                makeDescriptionTextfieldView()
                Divider()
                Spacer()
                makeSaveButtonView()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }
    }

    // MARK: View Builders

    private func makeTitleView() -> some View {
        Text(viewModel.title)
            .font(.title3.bold())
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    viewModel.backPressed()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
    }
    
    private func makeTitleTextfieldView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.taskTitleMessage)
                .font(.caption)
                .foregroundColor(.gray)

            TextField("", text: $taskTitle)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
        .padding(.top, 10)
    }

    private func makeDescriptionTextfieldView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.taskDescriptionMessage)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("", text: $taskDescription)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
        }
        .padding(.top, 10)
    }
    
    private func makeSaveButtonView() -> some View {
        Button {
            viewModel.saveTaskPressed(withTitle: taskTitle, description: taskDescription)
        } label: {
            Text(viewModel.saveTitle)
                .font(.callout)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(.white)
                .background {
                    Capsule()
                        .fill(.black)
                }
        }
    }

}

struct AddNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskView(viewModel: AddNewTaskViewModel(taskSaver: Saver(), onDismiss: {}))
    }

    class Saver: TaskSaver {
        func save(_ task: TaskItem, completion: @escaping (TaskSaver.Result) -> Void) {}
        func update(_ task: TaskItem, completion: @escaping (TaskSaver.Result) -> Void) {}
    }
}
