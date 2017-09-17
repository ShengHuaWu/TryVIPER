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
    // MARK: Public Methods
    func hasToken(in userDefaults: UserDefaults = UserDefaults.standard) -> Bool {
        return userDefaults.bearerToken() != nil ? true : false
    }
    
    func fetchToken(with webService: WebServiceProtocol = WebService(session: .appOnlyAuth)) {
        webService.load(resource: bearerToken()) { (result) in
            // TODO: Fetch tweets?
        }
    }
    
    func fetchTweets(with webService: WebServiceProtocol = WebService(session: .bearerToken)) {
        webService.load(resource: ImageTweet.tweets) { (result) in
            // TODO: Call output
        }
    }
}
