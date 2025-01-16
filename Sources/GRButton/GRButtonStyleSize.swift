//
//  GRButtonStyleSize.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 05/12/2024.
//

import SwiftUI

extension GRButtonStyle {
    
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
    
}
