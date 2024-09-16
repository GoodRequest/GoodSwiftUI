//
//  ReadableContentWidth.swift
//  GoodSwiftUI-Sample
//
//  Created by Filip Šašala on 16/09/2024.
//

import GoodSwiftUI
import SwiftUI

struct ReadableContentWidthView: View {

    var body: some View {
        Rectangle()
            .foregroundStyle(.red.gradient)
            .fittingReadableWidth()
            .navigationTitle("Readable content width")
    }

}
