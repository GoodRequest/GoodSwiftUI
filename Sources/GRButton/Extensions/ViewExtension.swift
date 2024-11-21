//
//  ViewExtension.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 20/11/2024.
//

import SwiftUI

struct Shadow: ViewModifier {

    let model: ShadowModel?

    func body(content: Content) -> some View {
        if let model {
            return AnyView(
                content
                    .zIndex(1)
                    .shadow(
                        color: model.color,
                        radius: model.radius,
                        x: model.offset.horizontal,
                        y: model.offset.vertical
                    )
            )

        } else {
            return AnyView(content)
        }

    }
}

extension View {

    func shadowed(_ model: ShadowModel?) -> some View {
        modifier(Shadow(model: model))
    }

}
