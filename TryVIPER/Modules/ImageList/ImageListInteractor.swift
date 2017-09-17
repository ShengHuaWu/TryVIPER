//
//  ImageListInteractor.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 17/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image List Interactor Output
protocol ImageListInteractorOutput: class {
    func endFetchingToken()
    func endFetching(tweets: [ImageTweet])
    func has(error: Error)
}

// MARK: - Image List Interactor
final class ImageListInteractor {
    // MARK: Properties
    weak var output: ImageListInteractorOutput?
    
    // MARK: Public Methods
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
}
