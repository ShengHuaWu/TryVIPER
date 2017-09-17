//
//  ImageListInteractorTests.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
@testable import TryVIPER

// MARK: - Image List Interactor Tests
final class ImageListInteractorTests: XCTestCase {
    // MARK: Properties
    private var interactor: ImageListInteractor!
    private var userDefaults = UserDefaults(suiteName: #file)!
    
    // MARK: Override Methods
    override func setUp() {
        super.setUp()
        
        userDefaults.removePersistentDomain(forName: #file)
        
        interactor = ImageListInteractor()
    }
    
    override func tearDown() {
        interactor = nil

        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testHasToken() {
        userDefaults.setBearerToken("abcdefgh1234567")
        
        XCTAssert(interactor.hasToken(in: userDefaults))
    }
    
    func testDoesnotHaveToken() {
        XCTAssertFalse(interactor.hasToken(in: userDefaults))
    }
    
    func testFetchBearerTokenWithSuccess() {
        let mockWebService = MockWebService<Bool>()
        mockWebService.givenResult = .success(true)
        
        let mockOutput = MockImageListInteractorOutput()
        interactor.output = mockOutput
        
        interactor.fetchBearerToken(with: mockWebService)
        
        mockWebService.verify(url: bearerToken().url)
        mockOutput.verify(hasError: false)
    }
    
    func testFetchBearerTokenWithFailure() {
        let mockWebService = MockWebService<Bool>()
        mockWebService.givenResult = .failure(SerializationError.missing("token"))
        
        let mockOutput = MockImageListInteractorOutput()
        interactor.output = mockOutput
        
        interactor.fetchBearerToken(with: mockWebService)
        
        mockWebService.verify(url: bearerToken().url)
        mockOutput.verify(hasError: true)
    }
    
    func testFetchTweetsWithSuccess() {
        let mockWebService = MockWebService<[ImageTweet]>()
        mockWebService.givenResult = .success([])
        
        let mockOutput = MockImageListInteractorOutput()
        interactor.output = mockOutput
        
        interactor.fetchTweets(with: mockWebService)
        
        mockWebService.verify(url: ImageTweet.tweets.url)
        mockOutput.verify(hasError: false)
    }
    
    func testFetchTweetsWithFailure() {
        let mockWebService = MockWebService<[ImageTweet]>()
        mockWebService.givenResult = .failure(SerializationError.missing("token"))
        
        let mockOutput = MockImageListInteractorOutput()
        interactor.output = mockOutput
        
        interactor.fetchTweets(with: mockWebService)
        
        mockWebService.verify(url: ImageTweet.tweets.url)
        mockOutput.verify(hasError: true)
    }
}

// MARK: - Mock Image List Interactor Output
final class MockImageListInteractorOutput: ImageListInteractorOutput {
    // MARK: Properties
    private var callCount = 0
    private var hasError = false
    
    // MARK: Public Methods
    func endFetchingToken() {
        callCount += 1
    }
    
    func endFetching(tweets: [ImageTweet]) {
        callCount += 1
    }
    
    func has(error: Error) {
        callCount += 1
        hasError = true
    }
    
    func verify(hasError: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(callCount, 1, "call count", file: file, line: line)
        XCTAssertEqual(self.hasError, hasError, "has error", file: file, line: line)
    }
}
