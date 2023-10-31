//
//  DeleteTaskFromCacheUseCaseTests.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import XCTest
import TaskManagementApp

final class DeleteTaskFromCacheUseCaseTests: XCTestCase {

    func test_init_notDeleteTaskOnCreation() {
        let (store, _) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_delete_onCacheDeletionSuccessfullyDeliverNoError() {
        let (store, sut) = makeSUT()
        expect(sut, withTask: uniqueTaskItem(), toCompleteWithError: nil) {
            store.completeDeleteSuccessfully()
        }
    }

    func test_delete_onCacheDeletionErrorDeliverError() {
        let (store, sut) = makeSUT()
        let expectedError = anyNSError()
        expect(sut, withTask: uniqueTaskItem(), toCompleteWithError: expectedError) {
            store.completeDelete(with: expectedError)
        }
    }

    func test_delete_hasNoSideEffectOnCache() {
        let (store, sut) = makeSUT()
        let taskItem = uniqueLocalTaskItem()
        sut.delete(taskItem.model, completion: {_ in })
        XCTAssertEqual(store.receivedMessages, [.deleteTask])
    }

    func test_delete_afterDeallocatingSUTNotDeliverDeletionError() {
        let store = TaskStoreSpy()
        var sut: LocalTaskLoader? = LocalTaskLoader(store: store)
        var capturedResults = [LocalTaskLoader.DeleteResult]()
        sut?.delete(uniqueTaskItem()) { capturedResults.append($0) }
        sut = nil
        store.completeDelete(with: anyNSError())
        XCTAssertTrue(capturedResults.isEmpty)
    }

    //MARK: - Helpers

    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (store: TaskStoreSpy, sut: LocalTaskLoader){
        let store = TaskStoreSpy()
        let sut = LocalTaskLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (store, sut)
    }

    func expect(_ sut: LocalTaskLoader, withTask task: TaskItem, toCompleteWithError expectedError: NSError?, when action: @escaping ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for Deleting")
        var capturedError: Error?
        sut.delete(task) { result in
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                break
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp])
        XCTAssertEqual(capturedError as? NSError, expectedError, file: file, line: line)
    }


}
