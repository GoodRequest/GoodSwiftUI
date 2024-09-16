//
//  InputFieldViewConfiguration.swift
//  GoodSwiftUI-Sample
//
//  Created by Filip Šašala on 24/06/2024.
//

import UIKit
import GRInputField

extension InputFieldView {

    static func configureAppearance() {
        let customAppearance = InputFieldAppearance(
            titleFont: UIFont.preferredFont(for: .caption1, weight: .regular, defaultSize: 12.0),
            titleColor: UIColor.systemBlue,
            textFieldTintColor: UIColor.systemBlue,
            textFieldFont: UIFont.preferredFont(for: .body, weight: .regular, defaultSize: 17.0),
            hintFont: UIFont.preferredFont(for: .caption1, weight: .regular, defaultSize: 12.0),
            borderWidth: 1,
            cornerRadius: 16,
            height: 56,
            eyeImageHidden: UIImage(systemName: "eye"),
            eyeImageVisible: UIImage(systemName: "eye.slash"),
            enabled: InputFieldViewStateAppearance(
                placeholderColor: UIColor.darkGray,
                contentBackgroundColor: UIColor.tertiarySystemBackground,
                textFieldTextColor: UIColor.systemBlue,
                borderColor: UIColor.gray,
                hintColor: UIColor.darkGray
            ),
            selected: InputFieldViewStateAppearance(
                placeholderColor: UIColor.darkGray,
                contentBackgroundColor: UIColor.tertiarySystemBackground,
                textFieldTextColor: UIColor.systemBlue,
                borderColor: UIColor.gray,
                hintColor: UIColor.darkGray
            ),
            disabled: InputFieldViewStateAppearance(
                placeholderColor: UIColor.darkGray,
                contentBackgroundColor: UIColor.secondarySystemBackground,
                textFieldTextColor: UIColor.darkGray,
                borderColor: UIColor.gray,
                hintColor: UIColor.darkGray
            ),
            failed: InputFieldViewStateAppearance(
                placeholderColor: UIColor.darkGray,
                contentBackgroundColor: UIColor.tertiarySystemBackground,
                textFieldTextColor: UIColor.systemBlue,
                borderColor: UIColor.systemRed,
                hintColor: UIColor.systemRed
            )
        )

        InputFieldView.defaultAppearance = customAppearance
    }

}

extension UIFont {

    static func preferredFont(for style: TextStyle, weight: Weight, defaultSize: CGFloat) -> UIFont {
        let font = UIFont.systemFont(ofSize: defaultSize, weight: weight).with([.traitUIOptimized])
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        if let descriptor = fontDescriptor.withSymbolicTraits(
            UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)
        ) {
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return self
        }
    }

}
