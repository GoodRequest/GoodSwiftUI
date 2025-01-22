//
//  GRButtonStyle.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 24/11/2024.
//

import SwiftUI

public struct GRButtonStyle: ButtonStyle {
    
    // MARK: - Constants

    private enum C {

        static let minimalScale = CGFloat(0.95)
        static let opacity = CGFloat(0.8)

    }
    
    @Environment(\.isEnabled) var isEnabled
    
    var isLeftIconMirroring: Bool {
        if iconModel?.leftIcon == nil,
           isLoading || iconModel?.rightIcon != nil {
            return iconModel?.mirrorIconSpace ?? false
        }
        return false
    }
    
    var isRightIconMirroring: Bool {
        if iconModel?.rightIcon == nil, iconModel?.leftIcon != nil {
            return iconModel?.mirrorIconSpace ?? false
        }
        return false
    }
    
    let appearance: GRButtonAppearanceModel
    let iconModel: GRButtonIconModel?
    let isLoading: Bool
    let size: Size

    @ScaledMetric private var buttonHeight: CGFloat
    @ScaledMetric private var buttonWidth: CGFloat
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @ScaledMetric private var iconHeight: CGFloat
    @ScaledMetric private var iconWidth: CGFloat

    // MARK: - Initialization
    
    public init(
        appearance: GRButtonAppearanceModel,
        iconModel: GRButtonIconModel? = nil,
        isLoading: Bool = false,
        size: Size = .medium
    ) {
        self.appearance = appearance
        self.iconModel = iconModel
        self.isLoading = isLoading
        self.size = size

        self._buttonHeight = ScaledMetric(wrappedValue: size.frame.height)
        self._buttonWidth = ScaledMetric(wrappedValue: size.frame.width ?? -1) // -1 means no width constraint
        self._iconHeight = ScaledMetric(wrappedValue: size.iconSize.height)
        self._iconWidth = ScaledMetric(wrappedValue: size.iconSize.width)
    }
    
    // MARK: - Content
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: size.frame.itemSpacing) {
            if isLeftIconMirroring {
                emptyIcon()
            } else {
                icon(iconModel?.leftIcon)
            }
            
            configuration.label
                .foregroundColor(isEnabled ? appearance.textColor : appearance.disabledTextColor)
                .font(isEnabled ? appearance.textFont : appearance.disabledTextFont)
                
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: appearance.loadingTintColor))
                    .transition(.scale)
            } else {
                if isRightIconMirroring {
                    emptyIcon()
                } else {
                    icon(iconModel?.rightIcon)
                }
            }
        }
        .padding(size.frame.edgeSpacing)
        .frame(width: buttonWidth > -1 ? buttonWidth : nil, height: buttonHeight)
        .contentShape(Rectangle()) // To increase the touch area of the button
        .background(
            RoundedRectangle(cornerRadius: size.frame.cornerRadius)
                .fill(isEnabled ? appearance.backgroundColor : appearance.disabledBackgroundColor)
        )
        .scaleEffect(configuration.isPressed ? C.minimalScale : 1)
        .opacity(configuration.isPressed ? C.opacity : 1)
        .animation(.default, value: configuration.isPressed)
        .animation(.linear(duration: 0.2), value: isLoading)
    }
    
}

// MARK: - Private

private extension GRButtonStyle {
    
    func icon(_ icon: Image?) -> some View {
        icon?
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth, height: iconHeight)
            .foregroundColor(isEnabled ? appearance.iconTintColor : appearance.iconDisabledTintColor)
    }
    
    func emptyIcon() -> some View {
        Rectangle()
            .frame(width: iconWidth, height: iconHeight)
            .opacity(0)
    }
    
}
