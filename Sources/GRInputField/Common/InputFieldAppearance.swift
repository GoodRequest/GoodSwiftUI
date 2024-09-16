//
//  InputFieldAppearance.swift
//  benu
//
//  Created by Maroš Novák on 11/03/2022.
//

import UIKit

public struct InputFieldAppearance: Sendable {

    public var titleFont: UIFont?
    public var titleColor: UIColor?

    /// Tint color of text field - eg. typing indicator
    public var textFieldTintColor: UIColor?
    public var textFieldFont: UIFont?

    public var hintFont: UIFont?

    public var borderWidth: CGFloat?
    public var cornerRadius: CGFloat?
    public var height: CGFloat?

    public var eyeImageHidden: UIImage?
    public var eyeImageVisible: UIImage?

    public var enabled: InputFieldViewStateAppearance? = .default
    public var selected: InputFieldViewStateAppearance? = .default
    public var disabled: InputFieldViewStateAppearance? = .default
    public var failed: InputFieldViewStateAppearance? = .default

    public init(
        titleFont: UIFont? = .systemFont(ofSize: 12),
        titleColor: UIColor? = .black,
        textFieldTintColor: UIColor? = .systemBlue,
        textFieldFont: UIFont? = .systemFont(ofSize: 12),
        hintFont: UIFont? = .systemFont(ofSize: 12),
        borderWidth: CGFloat? = 0,
        cornerRadius: CGFloat? = 0,
        height: CGFloat? = 50,
        eyeImageHidden: UIImage? = nil,
        eyeImageVisible: UIImage? = nil,
        enabled: InputFieldViewStateAppearance? = .default,
        selected: InputFieldViewStateAppearance? = .default,
        disabled: InputFieldViewStateAppearance? = .default,
        failed: InputFieldViewStateAppearance? = .default
    ) {
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.textFieldTintColor = textFieldTintColor
        self.textFieldFont = textFieldFont
        self.hintFont = hintFont
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.height = height
        self.eyeImageHidden = eyeImageHidden
        self.eyeImageVisible = eyeImageVisible
        self.enabled = enabled
        self.selected = selected
        self.disabled = disabled
        self.failed = failed
    }

    public static let `default` = InputFieldAppearance()
    
}

public struct InputFieldViewStateAppearance: Sendable {

    public var placeholderColor: UIColor?
    public var contentBackgroundColor: UIColor?
    public var textFieldTextColor: UIColor?
    public var borderColor: UIColor?
    public var hintColor: UIColor?

    public init(
        placeholderColor: UIColor? = .lightGray,
        contentBackgroundColor: UIColor? = .white,
        textFieldTextColor: UIColor? = .black,
        borderColor: UIColor? = .black,
        hintColor: UIColor? = .black
    ) {
        self.placeholderColor = placeholderColor
        self.contentBackgroundColor = contentBackgroundColor
        self.textFieldTextColor = textFieldTextColor
        self.borderColor = borderColor
        self.hintColor = hintColor
    }

    public static let `default` = InputFieldViewStateAppearance()
    
}
