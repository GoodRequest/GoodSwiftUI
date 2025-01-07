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
    var checkmarkImageTintColor: Color
    var checkmarkImage: Image?

    public init(
        tintColor: Color,
        uncheckedBorderColor: Color,
        checkedBackgroundColor: Color,
        checkmarkImageTintColor: Color,
        checkmarkImage: Image
    ) {
        self.tintColor = tintColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.checkedBackgroundColor = checkedBackgroundColor
        self.checkmarkImageTintColor = checkmarkImageTintColor
        self.checkmarkImage = checkmarkImage
    }

}
