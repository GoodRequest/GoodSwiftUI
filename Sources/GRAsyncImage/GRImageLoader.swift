//
//  GRImageLoader.swift
//  
//
//  Created by Marián Franko on 25/05/2023
//

import SwiftUI

final class GRImageLoader: ObservableObject {

    // MARK: - Properties

    @Published private(set) var status: Status

    private var imageCache: GRImageCacheType

    // MARK: - Enums

    enum Status: Equatable {

        case idle
        case loading
        case success(Data)
        case failure

    }

    // MARK: - Initialization

    init(url: URL?, imageCache: GRImageCacheType) {
        self.imageCache = imageCache

        if let url = url, let data = imageCache.object(forKey: url as NSURL) {
            status = .success(data)
        } else {
            status = .idle
        }
    }

    // MARK: - Public

    @MainActor
    func load(_ url: URL?) async {
        guard let url = url else {
            status = .failure
            return
        }

        if let data = imageCache.object(forKey: url as NSURL) {
            status = .success(data)
            return
        }

        status = .loading

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            status = .success(data)
            imageCache.set(object: data as NSData, forKey: url as NSURL)
        } catch {
            status = .failure
        }
    }

}

