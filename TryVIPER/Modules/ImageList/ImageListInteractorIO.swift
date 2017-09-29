//
//  ImageListInteractorIO.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 27/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image List Interactor Input
protocol ImageListInteractorInput: class {
    func hasToken(in userDefaults: UserDefaults) -> Bool
    func fetchBearToken()
    func fetchBearerToken(with webService: WebServiceProtocol)
    func fetchTweets()
    func fetchTweets(with webService: WebServiceProtocol)
    func downloadImage(for tweet: ImageTweet)
    func suspendDownloadingImage()
    func resumeDownloadingImage()
}

extension ImageListInteractorInput {
    func hasToken() -> Bool {
        return hasToken(in: .standard)
    }
    
    func fetchBearToken() {
        fetchBearerToken(with: WebService(session: .appOnlyAuth))
    }
    
    func fetchTweets() {
        fetchTweets(with: WebService(session: .bearerToken))
    }
}

// MARK: - Image List Interactor Output
protocol ImageListInteractorOutput: class {
    func endFetchingToken()
    func endFetching(tweets: [ImageTweet])
    func endDownloadingImage(for tweet: ImageTweet)
    func has(error: Error)
}
