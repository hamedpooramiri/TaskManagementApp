//
//  SaveTaskToCacheUseCaseTests.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import XCTest
import TaskManagementApp

final class SaveTaskToCacheUseCaseTests: XCTestCase {

    func test_init_notSaveTaskOnCreation() {
        let (store, _) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_onCacheSaveSuccessfullyDeliverNoError() {
        let (store, sut) = makeSUT()
        expect(sut, withTask: uniqueTaskItem(), toCompleteWithError: nil) {
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_onCacheInsertionErrorDeliverError() {
        let (store, sut) = makeSUT()
        let expectedError = anyNSError()
        expect(sut, withTask: uniqueTaskItem(), toCompleteWithError: expectedError) {
            store.completeInsertion(with: expectedError)
        }
    }

    func test_save_hasNoSideEffectOnCache() {
        let (store, sut) = makeSUT()
        let taskItem = uniqueLocalTaskItem()
        sut.save(taskItem.model, completion: {_ in })
        XCTAssertEqual(store.receivedMessages, [.insertTask(task: taskItem.local)])
    }

    func test_save_afterDeallocatingSUTNotDeliverInsertionError() {
        let store = TaskStoreSpy()
        var sut: LocalTaskLoader? = LocalTaskLoader(store: store)
        var capturedResults = [LocalTaskLoader.SaveResult]()
        sut?.save(uniqueTaskItem()) { capturedResults.append($0) }
        sut = nil
        store.completeInsertion(with: anyNSError())
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
        let exp = expectation(description: "wait for save")
        var capturedError: Error?
        sut.save(task) { result in
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
