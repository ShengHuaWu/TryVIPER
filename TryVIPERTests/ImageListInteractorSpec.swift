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
        var mockImageProvider: MockImageProvider!
        let tweetForTest = ImageTweet.forTest
        
        beforeEach {
            mockImageProvider = MockImageProvider()
            interactor = ImageListInteractor(imageProvider: mockImageProvider)
        }
        
        afterEach {
            interactor = nil
        }
        
        describe(".hasToken") {
            it("has token if userDefaults set bearer token") {
                let userDefaults = UserDefaults(suiteName: #file)!
                userDefaults.removePersistentDomain(forName: #file)

                userDefaults.setBearerToken("abcdefgh1234567")
                
                expect(interactor.hasToken(in: userDefaults)).to(equal(true))
            }
            
            it("doesn't has token if userDefaults doesn't set bearer token") {
                let userDefaults = UserDefaults(suiteName: "com.shenghuawu.tryviper")!
                userDefaults.removePersistentDomain(forName: "com.shenghuawu.tryviper")
                
                expect(interactor.hasToken(in: userDefaults)).to(equal(false))
            }
        }
        
        describe(".fetchBearerToken") {
            it ("asks webService to load with bearer token url") {
                let mockWebService = MockWebService<Bool>()
                mockWebService.givenResult = .success(true)

                interactor.fetchBearerToken(with: mockWebService)
                
                mockWebService.verify(url: bearerToken().url)
            }
            
            it("asks output to end fetching token if webService load succeeds") {
                let mockWebService = MockWebService<Bool>()
                mockWebService.givenResult = .success(true)
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchBearerToken(with: mockWebService)
                
                mockOutput.verify()
            }
            
            it("asks output to has error if webService load fails") {
                let mockWebService = MockWebService<Bool>()
                mockWebService.givenResult = .failure(SerializationError.missing("token"))
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchBearerToken(with: mockWebService)
                
                mockOutput.verify(hasError: true)
            }
        }
        
        describe(".fetchTweets") {
            it("asks webService to load with image tweets url") {
                let mockWebService = MockWebService<[ImageTweet]>()
                mockWebService.givenResult = .success([tweetForTest])

                interactor.fetchTweets(with: mockWebService)
                
                mockWebService.verify(url: ImageTweet.tweets.url)
            }
            
            it("asks output to end fetching tweets if webService load succeeds") {
                let tweetsForTest = [tweetForTest]
                
                let mockWebService = MockWebService<[ImageTweet]>()
                mockWebService.givenResult = .success(tweetsForTest)
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchTweets(with: mockWebService)
                
                mockOutput.verify(tweets: tweetsForTest)
            }
            
            it("asks output to has error if webService load fails") {
                let mockWebService = MockWebService<[ImageTweet]>()
                mockWebService.givenResult = .failure(SerializationError.missing("token"))
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.fetchTweets(with: mockWebService)
                
                mockOutput.verify(hasError: true)
            }
        }
        
        describe(".suspendDownloadingImage") {
            it("asks imageProvider to suspend loading") {
                interactor.suspendDownloadingImage()
                
                mockImageProvider.verify(callCount: 1)
            }
        }
        
        describe(".resumeDownloadingImage") {
            it("asks imageProvider to resume loading") {
                interactor.resumeDownloadingImage()
                
                mockImageProvider.verify(callCount: 1)
            }
        }
        
        describe(".downloadImage") {
            it("asks imageProvider to load with image url") {
                mockImageProvider.givenResult = .success(tweetForTest.fileURL())
                
                interactor.downloadImage(for: tweetForTest)

                mockImageProvider.verify(url: tweetForTest.mediaURL, destinationURL: tweetForTest.fileURL())                
            }
            
            it("asks output to end downloading image if imageProvider load succeeds") {
                let destinationURL = tweetForTest.fileURL()
                mockImageProvider.givenResult = .success(destinationURL)
                
                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.downloadImage(for: tweetForTest)
                
                mockOutput.verify(tweet: tweetForTest)
            }
            
            it("asks output to has error if imageProvider load fails") {
                mockImageProvider.givenResult = .failure(SerializationError.missing("token"))

                let mockOutput = MockImageListInteractorOutput()
                interactor.output = mockOutput
                
                interactor.downloadImage(for: tweetForTest)
                
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
    private var expectedTweet: ImageTweet!
    
    // MARK: Public Methods
    func endFetchingToken() {
        callCount += 1
    }
    
    func endFetching(tweets: [ImageTweet]) {
        callCount += 1
        expectedTweets = tweets
    }
    
    func endDownloadingImage(for tweet: ImageTweet) {
        callCount += 1
        expectedTweet = tweet
    }
    
    func has(error: Error) {
        callCount += 1
        hasError = true
    }
    
    func verify(hasError: Bool = false, tweets: [ImageTweet] = [], tweet: ImageTweet? = nil, file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
        expect(self.hasError, file: file, line: line).to(equal(hasError))
        expect(self.expectedTweets.count, file: file, line: line).to(equal(tweets.count))
        
        let predicate = tweet == nil ? beNil() : equal(tweet?.twitterID)
        expect(self.expectedTweet?.twitterID, file: file, line: line).to(predicate)
    }
}
