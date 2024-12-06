//
//  sourcery_iOS
//
//  Created by Andrej Jasso on 28/10/2022.
//

import SwiftUI

public struct GRButtonAppearanceModel {
    
    public let backgroundColor: Color
    public let disabledBackgroundColor: Color
    public let loadingTintColor: Color
    public let iconTintColor: Color
    public let iconDisabledTintColor: Color
    public let textColor: Color
    public let disabledTextColor: Color
    public let textFont: UIFont
    public let disabledTextFont: UIFont
    
    public init(
        backgroundColor: Color,
        disabledBackgroundColor: Color,
        loadingTintColor: Color,
        iconTintColor: Color,
        iconDisabledTintColor: Color,
        textColor: Color,
        disabledTextColor: Color,
        textFont: UIFont,
        disabledTextFont: UIFont
    ) {
        self.backgroundColor = backgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.loadingTintColor = loadingTintColor
        self.iconTintColor = iconTintColor
        self.iconDisabledTintColor = iconDisabledTintColor
        self.textColor = textColor
        self.disabledTextColor = disabledTextColor
        self.textFont = textFont
        self.disabledTextFont = disabledTextFont
    }
    
}

public struct GRButtonIconModel {
    
    public let leftIcon: Image?
    public let rightIcon: Image?
    
    public init(leftIcon: Image? = nil, rightIcon: Image? = nil) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
}

public struct GRButtonFrameModel {
    
    public let height: CGFloat
    public let width: CGFloat?
    public let iconSize: CGSize
    public let edgeSpacing: EdgeInsets
    public let itemSpacing: CGFloat
    public let cornerRadius: CGFloat
    
    public init(
        height: CGFloat,
        width: CGFloat? = nil,
        iconSize: CGSize,
        edgeSpacing: EdgeInsets,
        itemSpacing: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.height = height
        self.width = width
        self.iconSize = iconSize
        self.edgeSpacing = edgeSpacing
        self.itemSpacing = itemSpacing
        self.cornerRadius = cornerRadius
    }
    
}
