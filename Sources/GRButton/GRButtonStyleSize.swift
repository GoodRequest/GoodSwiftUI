//
//  GRButtonStyleSize.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 05/12/2024.
//

import SwiftUI

@MainActor
public extension GRButtonFrameModel {

    static func small(stretch: Bool = true) -> Self {
        GRButtonFrameModel(
            minHeight: 32,
            maxWidth: stretch ? .infinity : nil,
            iconSize: CGSize(width: 16, height: 16),
            edgeSpacing: EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12),
            itemSpacing: 4,
            cornerRadius: 16
        )
    }

    static func medium(stretch: Bool = true) -> Self {
        GRButtonFrameModel(
            minHeight: 40,
            maxWidth: stretch ? .infinity : nil,
            iconSize: CGSize(width: 20, height: 20),
            edgeSpacing: EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16),
            itemSpacing: 4,
            cornerRadius: 20
        )
    }

    static func large(stretch: Bool = true) -> Self {
        GRButtonFrameModel(
            minHeight: 56,
            maxWidth: stretch ? .infinity : nil,
            iconSize: CGSize(width: 20, height: 20),
            edgeSpacing: EdgeInsets(top: 17, leading: 16, bottom: 17, trailing: 16),
            itemSpacing: 8,
            cornerRadius: 16
        )
    }

    static func circleSmall() -> Self {
        GRButtonFrameModel(
            minHeight: 32,
            minWidth: 32,
            iconSize: CGSize(width: 16, height: 16),
            edgeSpacing: .init(),
            itemSpacing: .zero,
            cornerRadius: 16
        )
    }

    static func circleMedium() -> Self {
        GRButtonFrameModel(
            minHeight: 40,
            minWidth: 40,
            iconSize: CGSize(width: 24, height: 24),
            edgeSpacing: .init(),
            itemSpacing: .zero,
            cornerRadius: 20
        )
    }

    static func square() -> Self {
        GRButtonFrameModel(
            minHeight: 56,
            minWidth: 56,
            iconSize: CGSize(width: 24, height: 24),
            edgeSpacing: .init(),
            itemSpacing: .zero,
            cornerRadius: 16
        )
    }

}
