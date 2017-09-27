//
//  ImageListInteractor.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image List Interactor
final class ImageListInteractor {
    // MARK: Properties
    weak var output: ImageListInteractorOutput?
    fileprivate let imageProvider: ImageProviderProtocol
    
    // MARK: Designated Initializer
    init(imageProvider: ImageProviderProtocol = ImageProvider()) {
        self.imageProvider = imageProvider
    }
}

extension ImageListInteractor: ImageListInteractorInput {
    func hasToken(in userDefaults: UserDefaults = UserDefaults.standard) -> Bool {
        return userDefaults.bearerToken() != nil ? true : false
    }
    
    func fetchBearerToken(with webService: WebServiceProtocol = WebService(session: .appOnlyAuth)) {
        webService.load(resource: bearerToken()) { [weak self] (result) in
            switch result {
            case .success:
                self?.output?.endFetchingToken()
            case .failure(let error):
                self?.output?.has(error: error)
            }
        }
    }
    
    func fetchTweets(with webService: WebServiceProtocol = WebService(session: .bearerToken)) {
        webService.load(resource: ImageTweet.tweets) { [weak self] (result) in
            switch result {
            case .success(let tweets):
                self?.output?.endFetching(tweets: tweets)
            case .failure(let error):
                self?.output?.has(error: error)
            }
        }
    }
    
    func downloadImage(for tweet: ImageTweet) {
        imageProvider.load(at: tweet.mediaURL, to: tweet.fileURL()) { [weak self] (result) in
            switch result {
            case .success:
                self?.output?.endDownloadingImage(for: tweet)
            case .failure(let error):
                self?.output?.has(error: error)
            }
        }
    }
    
    func suspendDownloadingImage() {
        imageProvider.suspendLoading()
    }
    
    func resumeDownloadingImage() {
        imageProvider.resumeLoading()
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    var mediaURL: URL {
        return URL(string: mediaURLString)!
    }
    
    func fileURL(with suffix: String = "", userDefaults: UserDefaults = UserDefaults.standard) -> URL {
        guard let directoryURL = userDefaults.temporaryDirectoryURL() else {
            fatalError("Tempoaray directory doesn'r exist.")
        }
        
        return directoryURL.appendingPathComponent(twitterID + suffix)
    }
}
