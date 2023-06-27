//
//  SamplesListView.swift
//  GoodSwiftUI-Sample
//
//  Created by Matus Klasovity on 15/06/2023.
//

import SwiftUI

// MARK: - Samples

enum Sample: CaseIterable, Identifiable, Hashable {
    
    var id: String { UUID().uuidString }
    
    case grAsyncImage
    
    var title: String {
        switch self {
        case .grAsyncImage:
            return "Async Image"
        }
    }
    
    var view: some View {
        switch self {
        case .grAsyncImage:
            return GRAsyncImageSampleView()
                .navigationTitle(self.title)
        }
    }
    
}

// MARK: - Samples List View

struct SamplesListView: View {
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List(Sample.allCases) { example in
                NavigationLink(example.title, value: example)
            }
            .navigationTitle("Samples")
            .navigationDestination(for: Sample.self) { $0.view }
        }
    }
    
}
