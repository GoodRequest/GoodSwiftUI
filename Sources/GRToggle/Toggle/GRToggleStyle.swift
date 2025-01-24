//
//  GRToggleStyle.swift
//  GoodSwiftUI
//
//  Created by Lukas Kubaliak on 27/11/2024.
//

import SwiftUI

public struct GRToggleStyle: ToggleStyle {
    
    // MARK: - Size
    
    public enum Size: Int {
        
        case small = 24
        case large = 32
        
        var innerCircle: CGFloat { CGFloat(rawValue) / 2.5 }
        
        var checkmarkHeight: CGFloat {
            switch self {
            case .large: 12
            case .small: 8
            }
        }
        
        var checkmarkWidth: CGFloat {
            switch self {
            case .large: 16
            case .small: 12
            }
        }
        
    }
    
    // MARK: - Alignment
    
    public enum Alignment {
        
        case leading, trailing
        
    }
    
    // MARK: - Style
    
    public enum Style {
        
        case radio, checkbox, circularCheck
        
    }
    
    // MARK: - Variables
    
    var appearance: GRToggleAppearance
    var style: Style
    var size: Size
    var alignment: Alignment
    
    @Environment(\.isEnabled) private var isEnabled

    private var checkedBorderColor: Color {
        return style == .circularCheck ? .clear : appearance.tintColor
    }
    
    // MARK: - Initialization
    
    public init(
        appearance: GRToggleAppearance,
        style: Style,
        size: Size,
        alignment: Alignment = .trailing
    ) {
        self.appearance = appearance
        self.style = style
        self.size = size
        self.alignment = alignment
    }
    
    // MARK: - Content
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            switch alignment {
            case .leading:
                makeToggle(configuration: configuration)
                configuration.label
                
            case .trailing:
                configuration.label
                makeToggle(configuration: configuration)
            }
        }
        .animation(.default, value: configuration.isOn)
        .contentShape(Rectangle())
    }
    
}

// MARK: - Private

private extension GRToggleStyle {
        
    func makeToggle(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Group {
                if style == .checkbox {
                    boxToggle(configuration)
                } else {
                    circleToggle(configuration)
                }
            }
            .overlay {
                if style != .radio && configuration.isOn {
                    appearance.checkmarkImage?
                        .resizable()
                        .frame(width: size.checkmarkWidth, height: size.checkmarkHeight)
                        .foregroundColor(appearance.checkmarkImageTintColor)
                }
            }
            .opacity(isEnabled ? 1 : appearance.disabledOpacity)
        }
        .frame(width: CGFloat(size.rawValue), height: CGFloat(size.rawValue))
    }
    
    func boxToggle(_ configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .foregroundColor(configuration.isOn ? appearance.tintColor : appearance.uncheckedBackgroundColor)
            
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder()
                .foregroundColor(configuration.isOn ? .clear : appearance.uncheckedBorderColor)
        }
    }
    
    func circleToggle(_ configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(configuration.isOn ? appearance.checkedBackgroundColor : appearance.uncheckedBackgroundColor)
            
            Circle()
                .strokeBorder()
                .foregroundColor(configuration.isOn ? checkedBorderColor : appearance.uncheckedBorderColor)
            
            Circle()
                .foregroundColor(configuration.$isOn.wrappedValue ? appearance.tintColor : appearance.uncheckedBackgroundColor)
                .frame(
                    maxWidth: style == .circularCheck ? .none : size.innerCircle,
                    maxHeight: style == .circularCheck ? .none : size.innerCircle
                )
        }
    }
    
}
