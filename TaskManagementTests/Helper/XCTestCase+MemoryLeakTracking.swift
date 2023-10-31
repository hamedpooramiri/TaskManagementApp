//
//  XCTestCase+MemoryLeakTracking.swift
//  TaskManagementTests
//
//  Created by hamedpouramiri on 10/31/23.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. potential memory leak.", file: file, line: line)
        }
    }
}
