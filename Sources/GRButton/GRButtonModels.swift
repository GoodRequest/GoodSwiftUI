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
    public let textFont: Font
    public let disabledTextFont: Font
    
    public init(
        backgroundColor: Color,
        disabledBackgroundColor: Color,
        loadingTintColor: Color,
        iconTintColor: Color,
        iconDisabledTintColor: Color,
        textColor: Color,
        disabledTextColor: Color,
        textFont: Font,
        disabledTextFont: Font
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
    public let mirrorIconSpace: Bool
    
    public init(
        leftIcon: Image? = nil,
        rightIcon: Image? = nil,
        mirrorIconSpace: Bool = false
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.mirrorIconSpace = mirrorIconSpace
    }
    
}

public struct GRButtonFrameModel {
    
    public let minHeight: CGFloat
    public let maxHeight: CGFloat?
    public let minWidth: CGFloat?
    public let maxWidht: CGFloat?
    public let iconSize: CGSize
    public let edgeSpacing: EdgeInsets
    public let itemSpacing: CGFloat
    public let cornerRadius: CGFloat

    public init(
        minHeight: CGFloat,
        maxHeight: CGFloat? = nil,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        iconSize: CGSize,
        edgeSpacing: EdgeInsets,
        itemSpacing: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.minWidth = minWidth
        self.maxWidht = maxWidth
        self.iconSize = iconSize
        self.edgeSpacing = edgeSpacing
        self.itemSpacing = itemSpacing
        self.cornerRadius = cornerRadius
    }

}
