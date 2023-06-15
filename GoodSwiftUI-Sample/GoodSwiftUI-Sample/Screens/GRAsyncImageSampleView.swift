//
//  GRAsyncImageSampleView.swift
//  GoodSwiftUI-Sample
//
//  Created by Matus Klasovity on 15/06/2023.
//

import SwiftUI
import GRAsyncImage

struct GRAsyncImageSampleView: View {
    
    // MARK: - Body
    
    var body: some View {
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
        .padding()
    }
    
}

// MARK: - Previews

struct GRAsyncImageSampleView_Previews: PreviewProvider {
    
    static var previews: some View {
        GRAsyncImageSampleView()
    }
    
}
