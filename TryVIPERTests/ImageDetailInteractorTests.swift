//
//  ImageDetailInteractorTests.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 20/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Quick
import Nimble
@testable import TryVIPER

// MARK: - Image Detail Interactor Tests
class ImageDetailInteractorTests: QuickSpec {
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
                
                let mockImageProvide = MockImageProvider()
                let url = URL(string: "https://developer.apple.com")!
                mockImageProvide.givenResult = .success(url)
                interactor.downloadImage(with: mockImageProvide)
                
                mockOutput.verify()
                mockImageProvide.verify(url: tweet.largeMediaURL, destinationURL: tweet.fileURL(with: "large"))
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
    
    // MARK: Public Methods
    func endDownloadingImage(to url: URL) {
        callCount += 1
    }
    
    func has(error: Error) {
        callCount += 1
    }
    
    func verify(file: FileString = #file, line: UInt = #line) {
        expect(self.callCount, file: file, line: line).to(equal(1))
    }
}
