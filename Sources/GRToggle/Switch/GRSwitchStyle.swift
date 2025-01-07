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
        
        case small, large
        
        enum C {

            static let defaultHeight = CGFloat(31)
            static let defaultWidth = CGFloat(49)

        }
        
        public var heightRatio: CGFloat {
            switch self {
            case .small: CGFloat(28)/C.defaultHeight
            case .large: CGFloat(32)/C.defaultHeight
            }
        }

        public var widthRatio: CGFloat {
            switch self {
            case .small: CGFloat(44)/C.defaultWidth
            case .large: CGFloat(51)/C.defaultWidth
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
        Toggle("", isOn: configuration.$isOn)
            .labelsHidden()
            .tint(appearance.activeBackgroundColor)
            .scaleEffect(x: size.widthRatio, y: size.heightRatio)
    }
    
}
