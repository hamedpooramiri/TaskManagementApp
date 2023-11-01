//
//  TaskCacheIntegrationTests.swift
//  TaskCacheIntegrationTests
//
//  Created by hamedpouramiri on 11/1/23.
//

import XCTest
import TaskManagementApp

final class TaskCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        setUpEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }

    func test_load_emptyCache_deliversNoItems() {
        let sut = makeSUT()
        expect(sut, toLoad: [])
    }

    func test_load_nonEmptyCache_seprateInstanceDeliverTasks() {
        let insertSut = makeSUT()
        let expectedTask = uniqueLocalTaskItem().model
        save(task: expectedTask, with: insertSut)

        let loadSut = makeSUT()
        expect(loadSut, toLoad: [expectedTask])
    }

    func test_save_addTasksToPreviousSavedTasksBySeprateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformLastSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstTaskItem = uniqueLocalTaskItem().model
        let lastTaskItem = uniqueLocalTaskItem().model
        
        save(task: firstTaskItem, with: sutToPerformFirstSave)
        save(task: lastTaskItem, with: sutToPerformLastSave)
        expect(sutToPerformLoad, toLoad: [firstTaskItem, lastTaskItem])
    }

    func test_update_updateTaskThatSavedPreviousBySeprateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformUpdate = makeSUT()
        let sutToPerformLoad = makeSUT()

        let taskItem = uniqueLocalTaskItem()
        let updatedTaskItem = LocalTaskItem(id: taskItem.model.id, title: "new title", description: "new description", isCompleted: true)
        
        save(task: taskItem.model, with: sutToPerformSave)
        update(task: updatedTaskItem.model, with: sutToPerformUpdate)
        expect(sutToPerformLoad, toLoad: [updatedTaskItem.model])
    }

    //MARK: Helpers
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LocalTaskLoader {
        let storeURL = storeURLForTest()
        let store = try! CoreDataTaskStore(storeURL: storeURL)
        let sut = LocalTaskLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func expect(_ sut: LocalTaskLoader, toLoad expectedTasks: [TaskItem], file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load from cache")
        sut.load { result in
            switch result {
            case let .success(recievedTasks):
                XCTAssertEqual(recievedTasks, expectedTasks, "expected to get \(expectedTasks), but got \(recievedTasks)", file: file, line: line)
            case let .failure(error):
                XCTAssertNil(error, "expected to get success result, but got error \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func save(task: TaskItem, with sut: LocalTaskLoader, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for save")
        sut.save(task) { result  in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, "expect to save Data Successfully but got error: \(String(describing: error))", file: file, line: line)
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func update(task: TaskItem, with sut: LocalTaskLoader, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for update")
        sut.update(task) { result  in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, "expect to update Data Successfully but got error: \(String(describing: error))", file: file, line: line)
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    private func storeURLForTest() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appending(path: "\(type(of: self)).store")
    }

    private func setUpEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: storeURLForTest())
    }
}

