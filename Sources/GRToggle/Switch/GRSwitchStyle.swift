//
//  GRSwitchStyle.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 27/11/2024.
//

import SwiftUI

public struct GRSwitchStyle: ToggleStyle {
    
    // MARK: - Size
    
    public enum Size {
        
        case small, large, `default`
        
        enum C {

            static let defaultHeight = CGFloat(31)
            static let defaultWidth = CGFloat(49)
            
            static let smallHeight = CGFloat(28)
            static let smallWidth = CGFloat(44)
            
            static let largeHeight = CGFloat(32)
            static let largeWidth = CGFloat(51)

        }
        
        public var heightRatio: CGFloat {
            switch self {
            case .small: C.smallHeight / C.defaultHeight
            case .large: C.largeHeight / C.defaultHeight
            case .default: C.defaultHeight / C.defaultHeight
            }
        }

        public var widthRatio: CGFloat {
            switch self {
            case .small: C.smallWidth / C.defaultWidth
            case .large: C.largeWidth / C.defaultWidth
            case .default: C.defaultWidth / C.defaultWidth
            }
        }
        
    }
    
    // MARK: - Alignment
    
    public enum Alignment {
        
        case leading, trailing
        
    }
    
    // MARK: - Variables
    
    var appearance: GRSwitchAppearance
    var size: Size
    var alignment: Alignment
    
    // MARK: - Initialization
    
    public init(
        appearance: GRSwitchAppearance,
        size: Size,
        alignment: Alignment = .trailing
    ) {
        self.appearance = appearance
        self.size = size
        self.alignment = alignment
    }
    
    // MARK: - Content
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            switch alignment {
            case .leading:
                makeSwitch(configuration)
                configuration.label
                
            case .trailing:
                configuration.label
                makeSwitch(configuration)
            }
        }
    }
    
}

// MARK: - Private

private extension GRSwitchStyle {
    
    func makeSwitch(_ configuration: Configuration) -> some View {
        Toggle(isOn: configuration.$isOn) { configuration.label }
            .labelsHidden()
            .tint(appearance.activeBackgroundColor)
            .scaleEffect(x: size.widthRatio, y: size.heightRatio)
    }
    
}
