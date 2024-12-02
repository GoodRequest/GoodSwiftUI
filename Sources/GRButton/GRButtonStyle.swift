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
    
    // MARK: - Size
    
    public enum Size {
        
        case small
        case medium
        case large
        
        case circleSmall
        case circleMedium
        case square
        
        case custom(GRButtonFrameModel)
        
        var iconSize: CGSize {
            switch self {
            case .small, .circleSmall:
                return CGSize(width: 16, height: 16)
                
            case .circleMedium, .square:
                return CGSize(width: 24, height: 24)
                
            default:
                return CGSize(width: 20, height: 20)
            }
        }
        
        var frame: GRButtonFrameModel {
            switch self {
            case .small:
                return GRButtonFrameModel(
                    height: 32,
                    iconSize: iconSize,
                    edgeSpacing: EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12),
                    itemSpacing: 4,
                    cornerRadius: 16
                )
                
            case .medium:
                return GRButtonFrameModel(
                    height: 40,
                    iconSize: iconSize,
                    edgeSpacing: EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16),
                    itemSpacing: 4,
                    cornerRadius: 20
                )
                
            case .large:
                return GRButtonFrameModel(
                    height: 56,
                    iconSize: iconSize,
                    edgeSpacing: EdgeInsets(top: 17, leading: 16, bottom: 17, trailing: 16),
                    itemSpacing: 8,
                    cornerRadius: 16
                )
                
            case .circleSmall:
                return GRButtonFrameModel(
                    height: 32,
                    width: 32,
                    iconSize: iconSize,
                    edgeSpacing: .init(),
                    itemSpacing: .zero,
                    cornerRadius: 16
                )
                
            case .circleMedium:
                return GRButtonFrameModel(
                    height: 40,
                    width: 40,
                    iconSize: iconSize,
                    edgeSpacing: .init(),
                    itemSpacing: .zero,
                    cornerRadius: 20
                )
                
            case .square:
                return GRButtonFrameModel(
                    height: 56,
                    width: 56,
                    iconSize: iconSize,
                    edgeSpacing: .init(),
                    itemSpacing: .zero,
                    cornerRadius: 16
                )
                
            case .custom(let frame):
                return frame
            }
        }
        
    }
    
    @Environment(\.isEnabled) var isEnabled
    
    let appearance: GRButtonAppearanceModel
    let iconModel: GRButtonIconModel?
    let isLoading: Bool
    let size: Size
    
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
    }
    
    // MARK: - Content
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: size.frame.itemSpacing) {
            icon(iconModel?.leftIcon)
            
            configuration.label
                .foregroundColor(isEnabled ? appearance.textColor : appearance.disabledTextColor)
                .font(Font(isEnabled ? appearance.textFont : appearance.disabledTextFont))
                
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: appearance.loadingTintColor))
                    .transition(.scale)
            } else {
                icon(iconModel?.rightIcon)
            }
        }
        .padding(size.frame.edgeSpacing)
        .frame(width: size.frame.width, height: size.frame.height)
        .background(
            appearance.backgroundColor
                .clipShape(RoundedRectangle(cornerRadius: size.frame.cornerRadius))
        )
        .opacity(isEnabled ? 1.0 : 0.4)
        .allowsHitTesting(!isLoading)
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
            .frame(width: size.iconSize.width, height: size.iconSize.height)
            .foregroundColor(appearance.iconTintColor)
    }
    
}
