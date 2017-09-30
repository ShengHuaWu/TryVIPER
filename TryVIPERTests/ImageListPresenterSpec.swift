//
//  ImageListPresenterSpec.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 29/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Quick
import Nimble

@testable import TryVIPER

// MARK: - Image List Presenter Spec
class ImageListPresenterSpec: QuickSpec {
    override func spec() {
        var mockInteractor: MockImageListInteractorInput!
        var mockUserInterface: MockImageListUserInterface!
        var presenter: ImageListPresenter!
        
        beforeEach {
            mockInteractor = MockImageListInteractorInput()
            mockUserInterface = MockImageListUserInterface()
            presenter = ImageListPresenter()
            presenter.interactor = mockInteractor
            presenter.userInterface = mockUserInterface
        }
        
        afterEach {
            presenter = nil
        }
        
        describe("image list module interface") {
            it("update user interface without token") {
                presenter.updateUserInterface()
                
                mockInteractor.verify()
            }
            
            it("update user interface with token") {
                mockInteractor.givenHasToken = true
                
                presenter.updateUserInterface()
                
                mockInteractor.verify()
            }
        }
        
        describe("image list interactor output") { 
            it("end fetching token") {
                presenter.endFetchingToken()
                
                mockInteractor.verify(hasTokenCallCount: 0)
            }
            
            it("end fetching tweets") {
                let tweetsForTesting = [ImageTweet.forTest]
                
                presenter.endFetching(tweets: tweetsForTesting)
                
                mockUserInterface.verify(tweetsCount: tweetsForTesting.count)
            }
            
            it("has error") {
                let error = SerializationError.missing("nothing")
                
                presenter.has(error: error)
                
                mockUserInterface.verify(hasError: true)
            }
        }
    }
}

// MARK: - Mock Image List Interactor Input
private final class MockImageListInteractorInput: ImageListInteractorInput {
    // MARK: Properties
    private var hasTokenCallCount = 0
    private var callCount = 0
    var givenHasToken: Bool = false
    
    // MARK: Public Methods
    func hasToken(in userDefaults: UserDefaults) -> Bool {
        hasTokenCallCount += 1
        return givenHasToken
    }
    
    func fetchBearToken() {
        callCount += 1
    }
    
    func fetchBearerToken(with webService: WebServiceProtocol) {
        // Do nothing
    }
    
    func fetchTweets() {
        callCount += 1
    }
    
    func fetchTweets(with webService: WebServiceProtocol) {
        // Do nothing
    }
    
    func downloadImage(for tweet: ImageTweet) {
        
    }
    
    func suspendDownloadingImage() {
        
    }
    
    func resumeDownloadingImage() {
        
    }
    
    func verify(hasTokenCallCount: Int = 1, file: FileString = #file, line: UInt = #line) {
        expect(self.hasTokenCallCount, file: file, line: line).to(equal(hasTokenCallCount))
        expect(self.callCount, file: file, line: line).to(equal(1))
    }
}

// MARK: - Mock Image List User Interface
private final class MockImageListUserInterface: ImageListUserInterface {
    // MARK: Properties
    private var callCount = 0
    private var expectedTweets: [ImageTweet] = []
    private var hasError = false
    
    // MARK: Public Methods
    func show(tweets: [ImageTweet]) {
        callCount += 1
        expectedTweets = tweets
    }
    
    func show(error: Error) {
        callCount += 1
        hasError = true
    }
    
    func verify(tweetsCount: Int = 0, hasError: Bool = false, file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
        expect(self.expectedTweets.count, file: file, line: line).to(equal(tweetsCount))
        expect(self.hasError, file: file, line: line).to(equal(hasError))
    }
}
