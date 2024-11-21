//
//  sourcery_iOS
//
//  Created by Andrej Jasso on 02/11/2022.
//

import SwiftUI

@available(iOS 14.0, *)
public struct ButtonViewStyleModifier: ViewModifier {

    // MARK: - Enums

    public enum ButtonTypeStyle {

        case scaling(viewModel: GRButtonViewModel)

    }

    // MARK: - Constants

    let buttonType: ButtonTypeStyle

    // MARK: - Content

    public func body(content: Content) -> some View {
        switch buttonType {
        case .scaling(let viewModel):
            content.buttonStyle(GRScalingButtonStyle(viewModel: viewModel))
        }
    }

}

@available(iOS 14.0, *)
extension View {

    public func buttonStyle(_ buttonType: ButtonViewStyleModifier.ButtonTypeStyle) -> some View {
        modifier(ButtonViewStyleModifier(buttonType: buttonType))
    }

}
