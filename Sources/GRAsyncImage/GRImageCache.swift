//
//  GRImageCache.swift
//  
//
//  Created by Marián Franko on 25/05/2023
//

import Foundation

@MainActor final class GRImageCache {

    // MARK: - Typealiases

    typealias ImageCache = NSCache<NSURL, NSData>

    // MARK: - Properties

    private lazy var cache: ImageCache = {
        let cache = ImageCache()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1_024 * 1_024 // 50MB

        return cache
    }()

    // MARK: - Singleton

    static let shared = GRImageCache()

    private init() {}

    // MARK: - Internal

    func object(forKey url: NSURL) -> Data? {
        return cache.object(forKey: url) as? Data
    }

    func set(object: Data, forKey url: URL) {
        cache.setObject(object as NSData, forKey: url as NSURL)
    }

}
