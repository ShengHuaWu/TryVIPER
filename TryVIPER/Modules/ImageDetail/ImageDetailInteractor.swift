//
//  ImageDetailInteractor.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 18/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image Detail Interactor Output
protocol ImageDetailInteractorOutput: class {
    func endDownloadingImage(to url: URL)
    func has(error: Error)
}

// MARK: - Image Detail Interactor
final class ImageDetailInteractor {
    // MARK: Properties
    weak var output: ImageDetailInteractorOutput?
    private let tweet: ImageTweet
    
    // MARK: Designated Initializer
    init(tweet: ImageTweet) {
        self.tweet = tweet
    }
    
    // MARK: Public Methods
    func downloadImage(with imageProvider: ImageProviderProtocol = ImageProvider()) {
        imageProvider.load(at: tweet.largeMediaURL, to: tweet.fileURL(with: "large")) { [weak self] (result) in
            switch result {
            case .success(let url):
                self?.output?.endDownloadingImage(to: url)
            case .failure(let error):
                self?.output?.has(error: error)
            }
        }
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    var largeMediaURL: URL {
        return URL(string: mediaURLString + ":large")!
    }
}
