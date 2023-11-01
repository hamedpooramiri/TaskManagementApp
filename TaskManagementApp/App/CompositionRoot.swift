//
//  ContentView.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import SwiftUI
import CoreData

struct CompositionRoot: View {
    @State private var showDetails = false

    private var storeURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appending(path: "Task-store.sqlite")

    private let localTaskLoader: LocalTaskLoader

    init() {
        localTaskLoader = LocalTaskLoader(store: try! CoreDataTaskStore(storeURL: storeURL))
    }

    var body: some View {
        NavigationStack {
            TaskListComposer.compose(taskLoader: MainQueueDispatchDecorator(decoratee: localTaskLoader),
                                     taskSaver: MainQueueDispatchDecorator(decoratee: localTaskLoader),
                                     taskDeleter: MainQueueDispatchDecorator(decoratee: localTaskLoader),
                                     onAddTaskButtonPressed: {
                showDetails = true
            })
            .navigationDestination(isPresented: $showDetails) {
                AddNewTaskComposer.compose(taskSaver: MainQueueDispatchDecorator(decoratee: localTaskLoader)) {
                    showDetails = false
                }.navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CompositionRoot()
    }
    
}


