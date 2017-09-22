//
//  MockWebService.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Nimble
@testable import TryVIPER

final class MockWebService<U>: WebServiceProtocol {
    // MARK: Properties
    private var callCount = 0
    private var expectedResource: Resource<U>!
    var givenResult: Result<U>!
    
    // MARK: Public Methods
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T>) -> ()) {
        callCount += 1
        expectedResource = resource as Any as! Resource<U>
        completion(givenResult as Any as! Result<T>)
    }
    
    func verify(url: URL, file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
        expect(self.expectedResource.url, file: file, line: line).to(equal(url))
    }
}
