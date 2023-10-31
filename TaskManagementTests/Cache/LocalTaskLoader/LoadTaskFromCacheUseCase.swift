//
//  LoadTaskFromCacheUseCase.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import XCTest
import TaskManagementApp

final class LoadTaskFromCacheUseCase: XCTestCase {

    func test_init_notLoadTasksOnCreation() {
        let store = TaskStoreSpy()
        let _ = LocalTaskLoader(store: store)
        XCTAssertEqual(store.receivedMessages, [])
    }
     
    func test_load_onCacheRetrieveErrorDeliverError() {
        let (store, sut) = makeSUT()
        let expectedError = anyNSError()
        expect(sut, toCompleteWithResult: .failure(expectedError)) {
            store.completeRetrieve(with: expectedError)
        }
    }

    func test_load_emptyCache_DeliversNoTaskItem() {
        let (store, sut) = makeSUT()
        expect(sut, toCompleteWithResult: .success([])) {
            store.completeRetrieveWithEmptyCache()
        }
    }

    func test_load_hasNoSideEffectOnCache() {
        let (store, sut) = makeSUT()
        sut.load(completion: {_ in })
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_afterDeallocationOfSUT_notDeliverResult() {
        let store = TaskStoreSpy()
        var sut: LocalTaskLoader? = LocalTaskLoader(store: store)
        var capturedResult = [TaskLoader.Result]()
        sut?.load { capturedResult.append($0) }
        sut = nil
        store.completeRetrieveWithEmptyCache()
        XCTAssertTrue(capturedResult.isEmpty)
    }

    // MARK: - Helper
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (store: TaskStoreSpy, sut: LocalTaskLoader){
        let store = TaskStoreSpy()
        let sut = LocalTaskLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (store, sut)
    }

    func expect(_ sut: LocalTaskLoader, toCompleteWithResult expectedResult: TaskLoader.Result, when action: @escaping ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for saving")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("expect to get result \(expectedResult) but got \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp])
    }


}
