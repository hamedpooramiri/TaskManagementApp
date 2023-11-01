//
//  XCTestCase+TaskStoreSpecs.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation
import TaskManagementApp
import XCTest

extension TaskStoreSpecs where Self: XCTestCase {
    
    func assetThatRetrieveFromEmptyStoreDeliverEmpty(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toCompleteRetrieveWith: .success(nil), file: file, line: line)
    }
    
    func assetThatRetrieveFromEmptyStoreHasNoSideEffectRetrieveTwice(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(nil), file: file, line: line)
    }

    func assertThatRetrieveFromNonEmptyStoreDeliverData(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let item = uniqueLocalTaskItem()
        insert(item.local, to: sut, file: file, line: line)
        expect(sut, toCompleteRetrieveWith: .success([item.local]), file: file, line: line)
    }

    func assertThatRetrieveFromNonEmptyStoreHasNoSideEffectOnRetrieveTwice(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let item = uniqueLocalTaskItem()
        insert(item.local, to: sut, file: file, line: line)
        expect(sut, toRetrieveTwice: .success([item.local]), file: file, line: line)
    }

    func assertThatRetrieveFromNonEmptyStoreOnErrorDeliverError(on sut: TaskStore, storeURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        expect(sut, toCompleteRetrieveWith: .failure(anyNSError()), file: file, line: line)
    }

    func assertThatRetrieveNonEmptyStoreHaseNoSideEffectOnRetrieveTwiceOnError(on sut: TaskStore, storeURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }

    func assertThatInsertToEmptyStoreInsertData(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let item = uniqueLocalTaskItem()
        insert(item.local, to: sut, file: file, line: line)
        expect(sut, toCompleteRetrieveWith: .success([item.local]), file: file, line: line)
    }
    
    func assertThatInsertToNonEmptyStoreAddDataToStore(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let item0 = uniqueLocalTaskItem()
        insert(item0.local, to: sut, file: file, line: line)
        
        let item1 = uniqueLocalTaskItem()
        insert(item1.local, to: sut, file: file, line: line)

        expect(sut, toCompleteRetrieveWith: .success([item0.local, item1.local]), file: file, line: line)
    }

    func assertThatInsertOnInsertionErrorDeliverError(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert(uniqueLocalTaskItem().local, to: sut, file: file, line: line)
        XCTAssertNotNil(insertionError, "expect to deliver Error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectOnInsertionError(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        insert(uniqueLocalTaskItem().local, to: sut, file: file, line: line)
        expect(sut, toCompleteRetrieveWith: .success(nil), file: file, line: line)
    }

    func assertThatUpdateOnEmptyStoreDoNoting(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        update(uniqueLocalTaskItem().local, to: sut)
        expect(sut, toCompleteRetrieveWith: .success(nil), file: file, line: line)
    }

    func assertThatUpdateOnEmptyStoreHasNoSideEffectOnUpdateTwice(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        update(uniqueLocalTaskItem().local, to: sut, file: file, line: line)
        update(uniqueLocalTaskItem().local, to: sut, file: file, line: line)
        expect(sut, toCompleteRetrieveWith: .success(nil), file: file, line: line)
    }
    
    func assertThatUpdateOnNonEmptyStoreOverridePreviousData(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        var item = uniqueLocalTaskItem().local
        insert(item, to: sut, file: file, line: line)

        let updatedItem = LocalTaskItem(id: item.id, title: "updated title", description: "updated descriptioin", isCompleted: true)
        update(updatedItem, to: sut)

        expect(sut, toCompleteRetrieveWith: .success([updatedItem]), file: file, line: line)
    }
    
    func assertThatUpdateOnNonEmptyStoreHasNoSideEffectOnUpdateTwice(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        var item = uniqueLocalTaskItem().local
        insert(item, to: sut, file: file, line: line)

        let updatedItem = LocalTaskItem(id: item.id, title: "updated title", description: "updated descriptioin", isCompleted: true)
        update(updatedItem, to: sut)

        let latestUpdatedItem = LocalTaskItem(id: item.id, title: "latest updated title", description: "latest updated descriptioin", isCompleted: false)
        update(latestUpdatedItem, to: sut)

        expect(sut, toCompleteRetrieveWith: .success([latestUpdatedItem]), file: file, line: line)
    }

    func assertThatDeleteFromEmptyStoreDoNoting(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = delete(uniqueLocalTaskItem().local, from: sut)
        XCTAssertNil(deletionError, "expect to have no Deletion error", file: file, line: line)
    }

    func assertThatDeleteFromEmptyStoreHasNoSideEffectOnStore(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        delete(uniqueLocalTaskItem().local, from: sut)
        expect(sut, toCompleteRetrieveWith: .success(nil), file: file, line: line)
    }

    func assertThatDeleteFromNonEmptyStoreRemoveDataFromStore(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let item0 = uniqueLocalTaskItem()
        insert(item0.local, to: sut, file: file, line: line)
        
        let item1 = uniqueLocalTaskItem()
        insert(item1.local, to: sut, file: file, line: line)
        
        delete(item1.local, from: sut)
        expect(sut, toCompleteRetrieveWith: .success([item0.local]), file: file, line: line)
    }

    func assertThatDeleteOnDeletionErrorDeliverError(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = delete(uniqueLocalTaskItem().local, from: sut)
        XCTAssertNotNil(deletionError, "expect to have an error", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectOnDeletionError(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        delete(uniqueLocalTaskItem().local, from: sut)
        expect(sut, toCompleteRetrieveWith: .success(nil), file: file, line: line)
    }

    func assertThatStoreHasNoSideEffectWhenRunSerially(on sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) {
        var capturedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "op1")
        sut.insert(task: uniqueLocalTaskItem().local) { _ in
            capturedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "op2")
        sut.insert(task: uniqueLocalTaskItem().local) { _ in
            capturedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "op3")
        sut.insert(task: uniqueLocalTaskItem().local) { _ in
            capturedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        waitForExpectations(timeout: 7)
        XCTAssertEqual(capturedOperationsInOrder, [op1, op2, op3], file: file, line: line)
    }

    func expect(_ sut: TaskStore, toCompleteRetrieveWith expectedResult: TaskStore.RetrieveResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for retrieve")
        sut.retrieve { receivedresult in
            switch (receivedresult, expectedResult) {
            case let (.success(.some(receivedItems)), .success(.some(expectedItems))):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case (.success, .success), (.failure, .failure):
                break
            default:
                XCTFail("expected to get \(expectedResult) but got \(receivedresult)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func expect(_ sut: TaskStore, toRetrieveTwice expectedResult: TaskStore.RetrieveResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toCompleteRetrieveWith: expectedResult, file: file, line: line)
        expect(sut, toCompleteRetrieveWith: expectedResult, file: file, line: line)
    }
    
    @discardableResult
    func insert(_ task: LocalTaskItem, to sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let exp = expectation(description: "wait to retrieve items")
        var capturedError: Error?
        sut.insert(task: task) { result in
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        return capturedError
    }
    
    @discardableResult
    func update(_ task: LocalTaskItem, to sut: TaskStore, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let exp = expectation(description: "wait to update")
        var capturedError: Error?
        sut.update(task: task) { result in
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        return capturedError
    }

    @discardableResult
    func delete(_ task: LocalTaskItem, from sut: TaskStore) -> Error? {
        let exp = expectation(description: "wating for deletion")
        var deletionError: Error?
        sut.delete(task: task) { result in
            switch result {
            case .failure(let error):
                deletionError = error
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        return deletionError
    }
}
