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
    let size: GRButtonFrameModel

    @ScaledMetric private var buttonMinHeight: CGFloat
    @ScaledMetric private var buttonMinWidth: CGFloat
    @ScaledMetric private var buttonMaxHeight: CGFloat
    @ScaledMetric private var buttonMaxWidth: CGFloat
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @ScaledMetric private var iconHeight: CGFloat
    @ScaledMetric private var iconWidth: CGFloat

    // MARK: - Initialization
    
    public init(
        appearance: GRButtonAppearanceModel,
        iconModel: GRButtonIconModel? = nil,
        isLoading: Bool = false,
        size: GRButtonFrameModel = .medium()
    ) {
        self.appearance = appearance
        self.iconModel = iconModel
        self.isLoading = isLoading
        self.size = size

        self._buttonMinHeight = ScaledMetric(wrappedValue: size.minHeight)
        self._buttonMinWidth = ScaledMetric(wrappedValue: size.minWidth ?? -1) // -1 means no width constraint
        self._buttonMaxHeight = ScaledMetric(wrappedValue: size.maxHeight ?? -1) // -1 means no width constraint
        self._buttonMaxWidth = ScaledMetric(wrappedValue: size.maxWidht ?? -1) // -1 means no width constraint
        self._iconHeight = ScaledMetric(wrappedValue: size.iconSize.height)
        self._iconWidth = ScaledMetric(wrappedValue: size.iconSize.width)
    }
    
    // MARK: - Content
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: size.itemSpacing) {
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
        .padding(size.edgeSpacing)
        .frame(
            minWidth: buttonMinWidth > -1 ? buttonMinWidth : nil,
            maxWidth: buttonMaxWidth > -1 ? buttonMaxWidth : nil,
            minHeight: buttonMinHeight,
            maxHeight: buttonMaxHeight > -1 ? buttonMaxHeight : nil
        )
        .frame(width: nil) // When widht is not set to nil, text sometimes gets clipped
        .contentShape(Rectangle()) // To increase the touch area of the button
        .background(
            RoundedRectangle(cornerRadius: size.cornerRadius)
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
