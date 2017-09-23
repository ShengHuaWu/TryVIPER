//
//  MockImageProvider.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 20/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Nimble
@testable import TryVIPER

final class MockImageProvider: ImageProviderProtocol {
    // MARK: Properties
    private var callCount = 0
    private var expectedURL: URL!
    private var expectedDestinationURL: URL!
    var givenResult: Result<URL>!
    
    // MARK: Public Methods
    func load(at url: URL, to destinationURL: URL, with exist: (URL) -> Bool, completion: @escaping (Result<URL>) -> ()) {
        callCount += 1
        expectedURL = url
        expectedDestinationURL = destinationURL
        completion(givenResult)
    }
    
    func suspendLoading() {
        callCount += 1
    }
    
    func resumeLoading() {
        callCount += 1
    }
    
    func verify(callCount: Int = 1, url: URL? = nil, destinationURL: URL? = nil, file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(callCount))
        
        let urlPredicate = url == nil ? beNil() : equal(url)
        expect(self.expectedURL, file: file, line: line).to(urlPredicate)
        
        let destinationURLPredicate = destinationURL == nil ? beNil() : equal(destinationURL)
        expect(self.expectedDestinationURL, file: file, line: line).to(destinationURLPredicate)
    }
}
