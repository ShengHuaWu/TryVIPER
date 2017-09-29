//
//  ImageDetailInteractorSpec.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 29/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Quick
import Nimble
@testable import TryVIPER

// MARK: - Image Detail Interactor Spec
class ImageDetailInteractorSpec: QuickSpec {
    override func spec() {
        let tweet = ImageTweet.forTest
        var interactor: ImageDetailInteractor!
        
        beforeEach {
            interactor = ImageDetailInteractor(tweet: tweet)
        }
        
        afterEach {
            interactor = nil
        }
        
        describe("download image") {
            it("success") {
                let mockOutput = MockImageDetailInteractorOutput()
                interactor.output = mockOutput
                
                let destinationURL = tweet.fileURL(with: "large")
                let mockImageProvider = MockImageProvider()
                mockImageProvider.givenResult = .success(destinationURL)
                interactor.downloadImage(with: mockImageProvider)
                
                mockImageProvider.verify(url: tweet.largeMediaURL, destinationURL: destinationURL)
                mockOutput.verify(url: destinationURL)
            }
            
            it("failure") {
                let mockOutput = MockImageDetailInteractorOutput()
                interactor.output = mockOutput
                
                let mockImageProvider = MockImageProvider()
                mockImageProvider.givenResult = .failure(SerializationError.missing("token"))
                interactor.downloadImage(with: mockImageProvider)
                
                mockImageProvider.verify(url: tweet.largeMediaURL, destinationURL: tweet.fileURL(with: "large"))
                mockOutput.verify(hasError: true)
            }
        }
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    static var forTest: ImageTweet {
        return ImageTweet(twitterID: "999", text: "This is a tweet.", mediaURLString: "https://developer.apple.com", userName: "shenghuawu", userScreenName: "sheng", userProfileImageURLString: "https://developer.apple.com", createdAt: "123456789")
    }
}

// MARK: - Mock Image Detail Interactor Output
final class MockImageDetailInteractorOutput: ImageDetailInteractorOutput {
    // MARK: Properties
    private var callCount = 0
    private var hasError = false
    private var expectedURL: URL!
    
    // MARK: Public Methods
    func endDownloadingImage(to url: URL) {
        callCount += 1
        expectedURL = url
    }
    
    func has(error: Error) {
        callCount += 1
        hasError = true
    }
    
    func verify(hasError: Bool = false, url: URL? = nil, file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
        expect(self.hasError, file: file, line: line).to(equal(hasError))
        
        let predicate = url == nil ? beNil() : equal(url)
        expect(self.expectedURL, file: file, line: line).to(predicate)
    }
}
