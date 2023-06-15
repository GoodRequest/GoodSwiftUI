//
//  GRImageCache.swift
//  
//
//  Created by Marián Franko on 25/05/2023
//

import Foundation

public protocol GRImageCacheType {

    func object(forKey url: NSURL) -> Data?
    func set(object: NSData, forKey url: NSURL)

}

final class DefaultImageCache {

    // MARK: - Typealiases

    typealias ImageCache = NSCache<NSURL, NSData>

    // MARK: - Properties

    static var shared = DefaultImageCache()

    private lazy var cache: ImageCache = {
        let cache = ImageCache()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1_024 * 1_024 // 50MB

        return cache
    }()

    // MARK: - Initialization

    private init() {}

}

// MARK: - Protocol implementation

extension DefaultImageCache: GRImageCacheType {

    func object(forKey url: NSURL) -> Data? {
        return cache.object(forKey: url) as? Data
    }

    func set(object: NSData, forKey url: NSURL) {
        cache.setObject(object, forKey: url)
    }

}

