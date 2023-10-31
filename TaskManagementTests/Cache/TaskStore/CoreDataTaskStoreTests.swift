//
//  CoreDataTaskStoreTests.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import XCTest
import TaskManagementApp

final class CoreDataTaskStoreTests: XCTestCase, TaskStoreSpecs {

    func test_retrieve_emptyStore_deliverEmpty() {
        let sut = makeSUT()
        assetThatRetrieveFromEmptyStoreDeliverEmpty(on: sut)
    }
    
    func test_retrieve_emptyStore_hasNoSideEffectRetrieveTwice() {
        let sut = makeSUT()
        assetThatRetrieveFromEmptyStoreHasNoSideEffectRetrieveTwice(on: sut)
    }

    func test_retrieve_nonEmptyStore_deliverData() {
        let sut = makeSUT()
        assertThatRetrieveFromNonEmptyStoreDeliverData(on: sut)
    }
    
    func test_retrieve_nonEmptyStore_hasNoSideEffectOnRetrieveTwice() {
        let sut = makeSUT()
        assertThatRetrieveFromNonEmptyStoreHasNoSideEffectOnRetrieveTwice(on: sut)
    }
    
    func test_insert_toEmptyStore_addDataToStore() {
        let sut = makeSUT()
        assertThatInsertToEmptyStoreInsertData(on: sut)
    }
    
    func test_insert_toNonEmptyStore_addDataToStore() {
        let sut = makeSUT()
        assertThatInsertToNonEmptyStoreAddDataToStore(on: sut)
    }
    
    func test_delete_emptyStore_doNoting() {
        let sut = makeSUT()
        assertThatDeleteFromEmptyStoreDoNoting(on: sut)
    }
    
    func test_delete_emptyStore_hasNoSideEffectOnStore() {
        let sut = makeSUT()
        assertThatDeleteFromEmptyStoreHasNoSideEffectOnStore(on: sut)
    }
    
    func test_delete_nonEmptyStore_removeDataFromStore() {
        let sut = makeSUT()
        assertThatDeleteFromNonEmptyStoreRemoveDataFromStore(on: sut)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        assertThatStoreHasNoSideEffectWhenRunSerially(on: sut)
    }
    
    // MARK: Helper
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> TaskStore {
        let storeURL = URL(filePath: "/dev/null")
        let sut = try! CoreDataTaskStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
