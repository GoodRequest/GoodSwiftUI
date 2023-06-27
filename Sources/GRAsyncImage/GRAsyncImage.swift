//
//  GRAsyncImage.swift
//  
//
//  Created by Marián Franko on 25/05/2023.
//

import SwiftUI

@available(iOS 14.0, *)
public struct GRAsyncImage<FailurePlaceholder: View, LoadingPlaceholder: View>: View {

    // MARK: - Properties

    @StateObject private var imageLoader: GRImageLoader

    var url: URL?
    var failurePlaceholder: FailurePlaceholder
    var loadingPlaceholder: LoadingPlaceholder
    var onLoading: VoidClosure?
    var onSuccess: VoidClosure?
    var onFailure: VoidClosure?

    // MARK: - Initialization

    public init(
        url: URL?,
        @ViewBuilder failurePlaceholder: () -> FailurePlaceholder = { Image(systemName: "arrow.clockwise") },
        @ViewBuilder loadingPlaceholder: () -> LoadingPlaceholder = { ProgressView().progressViewStyle(.circular) },
        onLoading: VoidClosure? = nil,
        onSuccess: VoidClosure? = nil,
        onFailure: VoidClosure? = nil
    ) {
        _imageLoader = StateObject(wrappedValue: GRImageLoader(url: url, imageCache: DefaultImageCache.shared))

        self.url = url
        self.failurePlaceholder = failurePlaceholder()
        self.loadingPlaceholder = loadingPlaceholder()
        self.onLoading = onLoading
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            switch imageLoader.status {
            case .loading:
                loadingPlaceholder

            case .success(let data):
                if let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    Button(action: { loadImage(url: url) }, label: { failurePlaceholder })
                }

            case .failure:
                Button(action: { loadImage(url: url) }, label: { failurePlaceholder })

            case .idle:
                Color.clear
            }
        }
        .onAppear { loadImage(url: url) }
        .onChange(of: url) { url in loadImage(url: url) }
        .onChange(of: imageLoader.status) {
            switch $0 {
            case .loading:
                onLoading?()

            case .success:
                onSuccess?()

            case .failure:
                onFailure?()

            case .idle:
                break
            }
        }
    }

    // MARK: - Private

    private func loadImage(url: URL?) {
        Task {
            await imageLoader.load(url)
        }
    }

}

@available(iOS 14.0, *)
extension GRAsyncImage: Equatable {

    public static func == (lhs: GRAsyncImage, rhs: GRAsyncImage) -> Bool {
        lhs.url == rhs.url
    }

}

@available(iOS 14.0, *)
struct GRAsyncImage_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            GRAsyncImage(
                url: URL(string: "https://picsum.photos/200/300")
            ).frame(width: 200, height: 200)
            
            GRAsyncImage(
                url: URL(string: ":}"),
                failurePlaceholder: {
                    Text("Error")
                        .foregroundColor(Color.red)
                }
            )
            .frame(width: 200, height: 200)
            .border(.red)
        }
    }
    
}

