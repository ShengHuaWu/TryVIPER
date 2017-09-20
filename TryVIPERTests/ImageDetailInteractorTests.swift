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
        var interactor: ImageDetailInteractor!
        
        beforeEach {
            interactor = ImageDetailInteractor(tweet: .empty)
        }
        
        afterEach {
            interactor = nil
        }
        
        describe("download image") { 
            it("success") {
                let mockOutput = MockImageDetailInteractorOutput()
                interactor.output = mockOutput
                
                let mockImageProvide = MockImageProvider()
                interactor.downloadImage(with: mockImageProvide)
                
                mockOutput.verify()
                mockImageProvide.verify()
            }
        }
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    static var empty: ImageTweet {
        return ImageTweet(twitterID: "", text: "", mediaURLString: "", userName: "", userScreenName: "", userProfileImageURLString: "", createdAt: "")
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
