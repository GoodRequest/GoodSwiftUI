//
//  GRToggleAppearance.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 27/11/2024.
//

import SwiftUI

public struct GRToggleAppearance {

    var tintColor: Color
    var uncheckedBorderColor: Color
    var checkedBackgroundColor: Color
    var uncheckedBackgroundColor: Color
    var checkmarkImageTintColor: Color
    var checkmarkImage: Image?
    var cornerRadius: CGFloat
    var disabledOpacity: CGFloat

    public init(
        tintColor: Color,
        uncheckedBorderColor: Color,
        checkedBackgroundColor: Color,
        uncheckedBackgroundColor: Color = .clear,
        checkmarkImageTintColor: Color,
        checkmarkImage: Image,
        cornerRadius: CGFloat = 6,
        disabledOpacity: CGFloat = 0.32
    ) {
        self.tintColor = tintColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.checkedBackgroundColor = checkedBackgroundColor
        self.uncheckedBackgroundColor = uncheckedBackgroundColor
        self.checkmarkImageTintColor = checkmarkImageTintColor
        self.checkmarkImage = checkmarkImage
        self.cornerRadius = cornerRadius
        self.disabledOpacity = disabledOpacity
    }

}
