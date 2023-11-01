//
//  TaskListView.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 11/1/23.
//

import SwiftUI

struct TaskListView: View {

    @ObservedObject var viewModel: TaskListViewModel

    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            titleView()
            segmentView()
            Spacer()
            makeListView()
            Spacer()
        }.overlay(alignment: .bottom) {
            addButtonView()
        }.onChange(of: viewModel.taskType) { newValue in
            viewModel.taskTypeChangeAction(taskType: newValue)
        }
    }

    private func titleView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)
    }

    private func segmentView() -> some View {
        Picker("What is your favorite color?", selection: $viewModel.taskType) {
            ForEach(TaskListViewModel.TaskType.allCases) {  taskType in
                Text(taskType.rawValue).tag(taskType.id)
            }
        }
        .pickerStyle(.segmented)
        .padding(.all)
        .background {
            LinearGradient(colors: [
                .white.opacity(0.7),
                .white.opacity(0.4),
                .clear
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        }
    }

    private func makeListView() -> some View {
        Group {
            if viewModel.taskItems.isEmpty {
                Text("No tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
            } else {
                List(viewModel.taskItems) { task in
                    rowView(for: task)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteTaskButtonPressed(for: task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }

    private func rowView(for task: TaskItemViewModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.title2)
                    .lineLimit(1)
                    .padding(.leading, 4)
                    .padding(.top)
                
                Text(task.description)
                    .font(.footnote)
                    .truncationMode(.head)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 4)
                    .padding(.bottom)

            }
            Spacer()
            VStack {
                Spacer()
                Button {
                    viewModel.taskStateChanged(for: task)
                } label: {
                    Circle()
                        .strokeBorder(.black, lineWidth: 1.5)
                        .frame(width: 25, height: 25)
                        .overlay {
                            Circle()
                                .fill(task.isCompleted ? .black : .white)
                                .frame(width: 25, height: 25)
                        }
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .padding(.bottom, 4)
    }

    private func addButtonView() -> some View {
        // MARK: Add Button
        Button {
            viewModel.addTaskButtonPressed()
        } label: {
            Label {
                Text("Add Task")
            } icon: {
                Image(systemName: "plus.app.fill")
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(.black, in: Capsule())
        }
        // MARK: Linear Gradient BG
        .padding(.top, 10)
        .frame(maxWidth: .infinity)
        .background {
            LinearGradient(colors: [
                .white.opacity(0.05),
                .white.opacity(0.4),
                .white.opacity(0.7),
                .white
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel())
    }
}
