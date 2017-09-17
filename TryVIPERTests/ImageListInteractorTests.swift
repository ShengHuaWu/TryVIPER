//
//  ImageListInteractorTests.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
@testable import TryVIPER

final class ImageListInteractorTests: XCTestCase {
    // MARK: Properties
    private var interactor: ImageListInteractor!
    
    // MARK: Override Methods
    override func setUp() {
        super.setUp()
        
        interactor = ImageListInteractor()
    }
    
    override func tearDown() {
        interactor = nil

        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testHasToken() {
        let userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)
        
        userDefaults.setBearerToken("abcdefgh1234567")
        
        XCTAssert(interactor.hasToken(in: userDefaults))
    }
    
    func testFetchToken() {
        let mockWebService = MockWebService<Bool>()
        
        interactor.fetchToken(with: mockWebService)
        
        mockWebService.verify(url: bearerToken().url)
    }
    
    func testFetchTweets() {
        let mockWebService = MockWebService<[ImageTweet]>()
        
        interactor.fetchTweets(with: mockWebService)
        
        mockWebService.verify(url: ImageTweet.tweets.url)
    }
}
