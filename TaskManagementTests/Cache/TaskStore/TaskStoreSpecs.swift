//
//  TaskStoreSpecs.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import Foundation

/// any FeedStore concrete implementation Tests must implement this Protocol,
/// provide structure for TestCases
protocol TaskStoreSpecs {

     func test_retrieve_emptyStore_deliverEmpty()

     func test_retrieve_emptyStore_hasNoSideEffectRetrieveTwice()

     func test_retrieve_nonEmptyStore_deliverData()

     func test_retrieve_nonEmptyStore_hasNoSideEffectOnRetrieveTwice()


     func test_insert_toEmptyStore_addDataToStore()

     func test_insert_toNonEmptyStore_addDataToStore()


     func test_delete_emptyStore_doNoting()

     func test_delete_emptyStore_hasNoSideEffectOnStore()

     func test_delete_nonEmptyStore_removeDataFromStore()

    
     func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveTaskStoreSpecs: TaskStoreSpecs {
    func test_retrieve_nonEmptyStore_onErrorDeliverError()
    func test_retrieve_nonEmptyStore_haseNoSideEffectOnRetrieveTwiceOnError()
}

protocol FailableInsertionTaskStoreSpecs: TaskStoreSpecs {
    func test_insert_onInsertionErrorDeliverError()
    func test_insert_hasNoSideEffectOnInsertionError()
}

protocol FailableDeleteTaskStoreSpecs: TaskStoreSpecs {
    func test_delete_onDeletionErrorDeliverError()
    func test_delete_hasNoSideEffectOnDeletionError()
}

/// any FeedStore concrete implementation Tests can implement this typealias,
/// provide structure for TestCases
typealias FailableTaskStoreSpecs = FailableRetrieveTaskStoreSpecs & FailableInsertionTaskStoreSpecs & FailableDeleteTaskStoreSpecs
