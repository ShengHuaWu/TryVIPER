//
//  ImageListInteractorSpec.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Quick
import Nimble
@testable import TryVIPER

// MARK: - Image List Interactor Spec
final class ImageListInteractorSpec: QuickSpec {
    override func spec() {
        var interactor: ImageListInteractor!
        
        beforeEach {
            interactor = ImageListInteractor()
        }
        
        afterEach {
            interactor = nil
        }
        
        describe("token") {
            it("exist") {
                let userDefaults = UserDefaults(suiteName: #file)!
                userDefaults.removePersistentDomain(forName: #file)

                userDefaults.setBearerToken("abcdefgh1234567")
                
                expect(interactor.hasToken(in: userDefaults)).to(equal(true))
                
                userDefaults.removePersistentDomain(forName: #file)
            }
            
            it("not exist") {
                expect(interactor.hasToken()).to(equal(false))
            }
        }
        
        describe("fetch bearer token") { 
            it("success") {
                let mockWebService = MockWebService<Bool>()
                mockWebService.givenResult = .success(true)
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchBearerToken(with: mockWebService)
                
                mockWebService.verify(url: bearerToken().url)
                mockOutput.verify(hasError: false)
            }
            
            it("failure") {
                let mockWebService = MockWebService<Bool>()
                mockWebService.givenResult = .failure(SerializationError.missing("token"))
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchBearerToken(with: mockWebService)
                
                mockWebService.verify(url: bearerToken().url)
                mockOutput.verify(hasError: true)
            }
        }
        
        describe("fetch tweets") { 
            it("success") {
                let tweetsForTest = [ImageTweet.forTest]
                
                let mockWebService = MockWebService<[ImageTweet]>()
                mockWebService.givenResult = .success(tweetsForTest)
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchTweets(with: mockWebService)
                
                mockWebService.verify(url: ImageTweet.tweets.url)
                mockOutput.verify(hasError: false, tweets: tweetsForTest)
            }
            
            it("failure") {
                let mockWebService = MockWebService<[ImageTweet]>()
                mockWebService.givenResult = .failure(SerializationError.missing("token"))
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchTweets(with: mockWebService)
                
                mockWebService.verify(url: ImageTweet.tweets.url)
                mockOutput.verify(hasError: true)
            }
        }
    }
}

// MARK: - Mock Image List Interactor Output
final class MockImageListInteractorOutput: ImageListInteractorOutput {
    // MARK: Properties
    private var callCount = 0
    private var hasError = false
    private var expectedTweets: [ImageTweet] = []
    
    // MARK: Public Methods
    func endFetchingToken() {
        callCount += 1
    }
    
    func endFetching(tweets: [ImageTweet]) {
        callCount += 1
        expectedTweets = tweets
    }
    
    func has(error: Error) {
        callCount += 1
        hasError = true
    }
    
    func verify(hasError: Bool, tweets: [ImageTweet] = [], file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
        expect(self.hasError, file: file, line: line).to(equal(hasError))
        expect(self.expectedTweets.count, file: file, line: line).to(equal(tweets.count))
    }
}
