//
//  sourcery_iOS
//
//  Created by Andrej Jasso on 28/10/2022.
//

import SwiftUI

public struct GRButtonViewModel {
    
    public let appearance: AppearanceModel
    
    public enum StyleType {
        
        case base
        case sampleBase
        case sampleText
        case destructive
        case text
        case textDestructive
        case sourcery
        
        case circularPrimary
        case circularSecondary
        
        case social
        case socialSquare
        
        case custom(AppearanceModel)
        
    }
    
    public init(styleModel: GRButtonStyleModel, _ type: StyleType) {
        switch type {
        case .base:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel.large,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .trailingEdge,
                    mirrorIconSpace: true
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .sampleBase:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel.small,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .trailingHugged,
                    mirrorIconSpace: false
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .destructive:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel.large,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: true
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .sampleText:
            appearance = AppearanceModel(
                backgroundColor: .clear,
                frameModel: FrameModel.small,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .trailingHugged,
                    mirrorIconSpace: false
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .text:
            appearance = AppearanceModel(
                backgroundColor: .clear,
                frameModel: FrameModel.large,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: true
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .textDestructive:
            appearance = AppearanceModel(
                backgroundColor: .clear,
                frameModel: FrameModel.large,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: true
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .sourcery:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: .large,
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .circularPrimary:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel(
                    height: 40,
                    width: 40,
                    edgeSpacing: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                    interItemSpacing: 0,
                    cornerRadius: 40,
                    stretching: true
                ),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: false
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .circularSecondary:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel(
                    height: 40,
                    width: 40,
                    edgeSpacing: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                    interItemSpacing: 0,
                    cornerRadius: 40,
                    stretching: true
                ),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: false
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .social:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel(
                    height: 50,
                    edgeSpacing: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                    interItemSpacing: 10,
                    cornerRadius: 8,
                    stretching: true
                ),
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: false
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.textFont
                )
            )
            
        case .socialSquare:
            appearance = AppearanceModel(
                backgroundColor: styleModel.backgroundColor,
                frameModel: FrameModel(
                    height: 64,
                    edgeSpacing: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                    interItemSpacing: .zero,
                    cornerRadius: 16,
                    stretching: true
                ),
                loading: LoadingModel(tintColor: styleModel.loadingTingColor),
                icon: IconModel(
                    tint: styleModel.iconTintColor,
                    alignment: .leadingHugged,
                    mirrorIconSpace: false
                ),
                text: TextModel(
                    color: styleModel.textColor,
                    font: styleModel.textFont
                ),
                disabledText: TextModel(
                    color: styleModel.disabledTextColor,
                    font: styleModel.disabledTextFont
                )
            )
            
        case .custom(let appearance):
            self.appearance = appearance
        }
    }
    
}

public struct AppearanceModel {
    
    let backgroundColor: Color
    let frameModel: FrameModel
    let loading: LoadingModel?
    let icon: IconModel?
    let text: TextModel
    let disabledText: TextModel
    let stroke: StrokeModel?
    let shadow: ShadowModel?
    
    public init(
        backgroundColor: Color,
        frameModel: FrameModel,
        loading: LoadingModel? = nil,
        icon: IconModel? = nil,
        text: TextModel,
        disabledText: TextModel,
        stroke: StrokeModel? = nil,
        shadow: ShadowModel? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.frameModel = frameModel
        self.loading = loading
        self.icon = icon
        self.text = text
        self.disabledText = disabledText
        self.stroke = stroke
        self.shadow = shadow
    }
    
}

public struct GRButtonStyleModel {
    
    let backgroundColor: Color
    let loadingTingColor: Color
    let iconTintColor: Color
    let textColor: Color
    let disabledTextColor: Color
    let textFont: UIFont
    let disabledTextFont: UIFont
    
    public init(
        backgroundColor: Color = .clear,
        loadingTingColor: Color,
        iconTintColor: Color,
        textColor: Color,
        disabledTextColor: Color,
        textFont: UIFont,
        disabledTextFont: UIFont
    ) {
        self.backgroundColor = backgroundColor
        self.loadingTingColor = loadingTingColor
        self.iconTintColor = iconTintColor
        self.textColor = textColor
        self.disabledTextColor = disabledTextColor
        self.textFont = textFont
        self.disabledTextFont = disabledTextFont
    }
    
}

public struct FrameModel: Sendable {
    
    let height: CGFloat
    let width: CGFloat?
    let edgeSpacing: EdgeInsets
    let interItemSpacing: CGFloat
    let cornerRadius: CGFloat
    let stretching: Bool
    
    static let small = FrameModel(
        height: 40,
        edgeSpacing: EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16),
        interItemSpacing: 4,
        cornerRadius: 12,
        stretching: false
    )
    
    static let large = FrameModel(
        height: 50,
        edgeSpacing: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        interItemSpacing: 12,
        cornerRadius: 8,
        stretching: true
    )
    
    
    public init(
        height: CGFloat,
        width: CGFloat? = nil,
        edgeSpacing: EdgeInsets,
        interItemSpacing: CGFloat,
        cornerRadius: CGFloat,
        stretching: Bool
    ) {
        self.height = height
        self.width = width
        self.edgeSpacing = edgeSpacing
        self.interItemSpacing = interItemSpacing
        self.cornerRadius = cornerRadius
        self.stretching = stretching
    }
    
}


public enum IconAlignment: Int, CaseIterable, Identifiable {
    
    public var id: Int {
        return rawValue
    }
    
    case leadingEdge
    case leadingHugged
    case trailingEdge
    case trailingHugged
    
}


public struct LoadingModel {
    
    let tintColor: Color
    
}

public struct IconModel {
    
    let tint: Color
    let alignment: IconAlignment
    let mirrorIconSpace: Bool
    
}

public struct TextModel {
    
    let color: Color
    let font: UIFont
    
}

public struct StrokeModel {
    
    let color: Color
    let weight: CGFloat
    
}

public struct ShadowModel {
    
    let color: Color
    let radius: CGFloat
    let offset: UIOffset
    
}
