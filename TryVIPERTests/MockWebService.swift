//
//  MockWebService.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
@testable import TryVIPER

final class MockWebService<U>: WebServiceProtocol {
    // MARK: Properties
    private var loadCallCount = 0
    private var expectedResource: Resource<U>!
    
    // MARK: Public Methods
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T>) -> ()) {
        loadCallCount += 1
        expectedResource = resource as Any as! Resource<U>
    }
    
    func verify(url: URL, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(loadCallCount, 1, "call count", file: file, line: line)
        XCTAssertEqual(expectedResource.url, url, "url", file: file, line: line)
    }
}
