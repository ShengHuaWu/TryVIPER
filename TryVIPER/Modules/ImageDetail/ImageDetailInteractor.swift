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
}

// MARK: - Image Detail Interactor
final class ImageDetailInteractor {
    // MARK: Properties
    weak var output: ImageDetailInteractorOutput?
    
    // MARK: Public Methods
    func downloadImage(with imageProvider: ImageProviderProtocol = ImageProvider()) {
        // TODO: Download image and invoke output
    }
}
