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
        let globalAppearance = InputFieldAppearance(
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
                borderColor: UIColor.black,
                hintColor: UIColor.darkGray
            ),
            disabled: InputFieldViewStateAppearance(
                placeholderColor: UIColor.darkGray,
                contentBackgroundColor: UIColor.secondarySystemBackground,
                textFieldTextColor: UIColor.darkGray,
                borderColor: UIColor.systemGray2,
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

        InputFieldView.defaultAppearance = globalAppearance
    }

}

extension InputFieldAppearance {

    static let custom = InputFieldAppearance(
        titleFont: UIFont.preferredFont(for: .title2, weight: .regular, defaultSize: 20),
        titleColor: UIColor.brown,
        textFieldTintColor: UIColor.brown,
        textFieldFont: UIFont.preferredFont(for: .title2, weight: .regular, defaultSize: 30.0),
        hintFont: UIFont.preferredFont(for: .title2, weight: .thin, defaultSize: 20.0),
        borderWidth: 3,
        cornerRadius: 20,
        height: 56,
        eyeImageHidden: UIImage(systemName: "eye"),
        eyeImageVisible: UIImage(systemName: "eye.slash"),
        enabled: InputFieldViewStateAppearance(
            placeholderColor: UIColor.green.withAlphaComponent(0.5),
            contentBackgroundColor: UIColor.yellow.withAlphaComponent(0.1),
            textFieldTextColor: UIColor.green,
            borderColor: UIColor.systemMint,
            hintColor: UIColor.darkGray
        ),
        selected: InputFieldViewStateAppearance(
            placeholderColor: UIColor.green.withAlphaComponent(0.5),
            contentBackgroundColor: UIColor.yellow.withAlphaComponent(0.1),
            textFieldTextColor: UIColor.green,
            borderColor: UIColor.green,
            hintColor: UIColor.darkGray
        ),
        disabled: InputFieldViewStateAppearance(
            placeholderColor: UIColor.darkGray,
            contentBackgroundColor: UIColor.secondarySystemBackground,
            textFieldTextColor: UIColor.green.withAlphaComponent(0.5),
            borderColor: UIColor.systemMint.withAlphaComponent(0.2),
            hintColor: UIColor.darkGray
        ),
        failed: InputFieldViewStateAppearance(
            placeholderColor: UIColor.darkGray,
            contentBackgroundColor: UIColor.tertiarySystemBackground,
            textFieldTextColor:  UIColor.green,
            borderColor: UIColor.purple,
            hintColor: UIColor.systemRed
        )
    )

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
