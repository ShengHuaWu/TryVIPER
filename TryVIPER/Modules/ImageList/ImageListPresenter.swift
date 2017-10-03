//
//  ImageListPresenter.swift
//  TryVIPER
//
//  Created by ShengHua Wu on 27/09/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image List User Interface
protocol ImageListUserInterface: class {
    func show(tweets: [ImageTweet])
    func show(error: Error)
}

// MARK: Image List Module Interface
protocol ImageListModuleInterface: class {
    func updateUserInterface()
    func suspendDownloading()
    func resumeDownloading()
}

// MARK: - Image List Presenter
final class ImageListPresenter {
    // MARK: Properties
    var interactor: ImageListInteractorInput?
    weak var userInterface: ImageListUserInterface?
}

extension ImageListPresenter: ImageListModuleInterface {
    func updateUserInterface() {
        if let hasToken = interactor?.hasToken(), hasToken {
            interactor?.fetchTweets()
        } else {
            interactor?.fetchBearToken()
        }
    }
    
    func suspendDownloading() {
        interactor?.suspendDownloadingImage()
    }
    
    func resumeDownloading() {
        interactor?.resumeDownloadingImage()
    }
}

extension ImageListPresenter: ImageListInteractorOutput {
    func endFetchingToken() {
        interactor?.fetchTweets()
    }
    
    func endFetching(tweets: [ImageTweet]) {
        userInterface?.show(tweets: tweets)
    }
    
    func endDownloadingImage(for tweet: ImageTweet) {
        // TODO: Load image from url with userInterface
    }
    
    func has(error: Error) {
        userInterface?.show(error: error)
    }
}
