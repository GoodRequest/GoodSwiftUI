//
//  sourcery_iOS
//
//  Created by Andrej Jasso on 02/11/2022.
//

import SwiftUI

@available(iOS 14.0, *)
public struct GRScalingButtonStyle: ButtonStyle {

    // MARK: - Structs

    struct AnimationModel {

        let animation: Animation
        let minScale: CGFloat
        let overlayOpacity: CGFloat
        let overlayColor: Color

        static let `default` = AnimationModel(
            animation: C.animation,
            minScale: C.minScale,
            overlayOpacity: C.overlayOpacity,
            overlayColor: .white
        )

    }

    // MARK: - Constants

    private enum C {

        static let minScale = CGFloat(0.93)
        static let animation: Animation = .default
        static let overlayOpacity: CGFloat = 0.1
        static let overlayColor: Color = .white

    }

    // MARK: - Variables

    let viewModel: GRButtonViewModel
    let animationModel: AnimationModel

    init(viewModel: GRButtonViewModel, animationModel: AnimationModel = .default) {
        self.viewModel = viewModel
        self.animationModel = animationModel
    }

    // MARK: - Content

    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .overlay(
                    animationModel.overlayColor
                        .opacity(configuration.isPressed ? animationModel.overlayOpacity : .zero)
                        .cornerRadius(viewModel.appearance.frameModel.cornerRadius)
                )
                .scaleEffect(configuration.isPressed ? animationModel.minScale : 1)
        }
        .animation(animationModel.animation, value: configuration.isPressed)
    }

}

struct SimpleScalingButtonStyle: ButtonStyle {

    @State var buttonSize: CGSize = .zero

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(GeometryReader { proxy in EmptyView().onAppear { buttonSize = proxy.size }})
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }

}
