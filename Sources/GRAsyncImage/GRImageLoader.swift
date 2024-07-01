//
//  GRImageLoader.swift
//  
//
//  Created by Marián Franko on 25/05/2023
//

import SwiftUI

@MainActor final class GRImageLoader: ObservableObject {

    // MARK: - Properties

    @Published private(set) var status: Status

    // MARK: - Enums

    enum Status: Equatable {

        case idle
        case loading
        case success(Data)
        case failure

    }

    // MARK: - Initialization

    init(url: URL?) {
        if let url = url, let data = GRImageCache.shared.object(forKey: url as NSURL) {
            status = .success(data)
        } else {
            status = .idle
        }
    }

    // MARK: - Public

    func load(_ url: URL?) async {
        guard let url = url else {
            status = .failure
            return
        }

        if let data = GRImageCache.shared.object(forKey: url as NSURL) {
            status = .success(data)
            return
        }

        status = .loading

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            status = .success(data)
            GRImageCache.shared.set(object: data, forKey: url)
        } catch {
            status = .failure
        }
    }

}

