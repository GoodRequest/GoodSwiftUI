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
        var cornerRadius: CGFloat { 6 }
        
    }
    
    // MARK: - Alignment
    
    public enum Alignment {
        
        case leading, trailing
        
    }
    
    // MARK: - Style
    
    public enum Style {
        
        case radio, checkBox, checkCircle
        
    }
    
    // MARK: - Variables
    
    var appearance: GRToggleAppearance
    var style: Style
    var size: Size
    var alignment: Alignment
    
    @Environment(\.isEnabled) private var isEnabled
    
    private var isLarge: Bool { size == .large }
    private var isCheck: Bool { style == .checkCircle }
    private var isBox: Bool { style == .checkBox }
    private var isRadio: Bool { style == .radio }
    private var checkedBorderColor: Color { isCheck ? .clear : appearance.tintColor }
    
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
        .onTapGesture { configuration.isOn.toggle() }
    }
    
}

// MARK: - Private

private extension GRToggleStyle {
        
    func makeToggle(configuration: Configuration) -> some View {
        ZStack{
            Group {
                if isBox {
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .foregroundColor(configuration.isOn ? appearance.tintColor : .clear)
                    
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .strokeBorder()
                        .foregroundColor(configuration.isOn ? .clear : appearance.uncheckedBorderColor)
                } else {
                    Circle()
                        .foregroundColor(configuration.isOn ? appearance.checkedBackgroundColor : .clear)
                    
                    Circle()
                        .strokeBorder()
                        .foregroundColor(configuration.isOn ? checkedBorderColor : appearance.uncheckedBorderColor)
                    
                    Circle()
                        .foregroundColor(configuration.$isOn.wrappedValue ? appearance.tintColor : .clear)
                        .frame(maxWidth: isCheck ? .none : size.innerCircle, maxHeight: isCheck ? .none : size.innerCircle)
                }
            }
            .opacity(isEnabled ? 1 : 0.32)

            if !isRadio && configuration.isOn {
                appearance.checkmarkImage?
                    .resizable()
                    .frame(width: isLarge ? 16 : 12, height: isLarge ? 12 : 8)
                    .foregroundColor(appearance.checkmarkImageTintColor)
            }
        }
        .frame(width: CGFloat(size.rawValue), height: CGFloat(size.rawValue))
        .contentShape(Circle())
    }
    
}
