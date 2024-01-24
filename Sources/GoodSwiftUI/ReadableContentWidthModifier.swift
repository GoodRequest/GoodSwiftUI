//
//  ReadableContentWidthModifier.swift
//
//  GoodSwiftUI
//  Created by Filip Šašala on 31/12/2023.
//

import SwiftUI

private struct ReadableContentWidth: ViewModifier {

    private let measureViewController = UIViewController()

    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: readableWidth(for: orientation))
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
    }

    private func readableWidth(for _: UIDeviceOrientation) -> CGFloat {
        measureViewController.view.frame = UIScreen.main.bounds
        let readableContentSize = measureViewController.view.readableContentGuide.layoutFrame.size
        return readableContentSize.width
    }

}

public extension View {

    func readableContentWidth(_ edges: Edge.Set = .horizontal, _ length: CGFloat = 16) -> some View {
        let modifiedView = modifier(ReadableContentWidth())
        return modifiedView.padding(edges, length)
    }

}
