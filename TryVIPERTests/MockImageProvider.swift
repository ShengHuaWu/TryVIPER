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
    
    // MARK: Public Methods
    func load(at url: URL, to destinationURL: URL, with exist: (URL) -> Bool, completion: @escaping (Result<URL>) -> ()) {
        callCount += 1
        completion(.success(URL(string: "https://developer.apple.com")!))
    }
    
    func verify(file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
    }
}
