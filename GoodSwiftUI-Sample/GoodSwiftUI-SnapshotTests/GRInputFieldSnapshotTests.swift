//
//  GRInputFieldSnapshotTests.swift
//  GoodSwiftUI-Sample
//
//  Created by Lukas Kubaliak on 09/07/2025.
//

import XCTest
import SnapshotTesting
import SwiftUI

@testable import GRInputField

@MainActor final class GRInputFieldSnapshotTests: XCTestCase {
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let eyeImageHidden = UIImage(systemName: "eye")
        static let eyeImageVisible = UIImage(systemName: "eye.slash")
        static let personImage = Image(systemName: "person")
        static let title = "Label"
        static let placeholder = "Placeholder"
        static let text = "Value"
        static let hint = "Hint"
        
    }
    
    // MARK: - Test Configuration
    
    private var shouldRecordNewReferences = false
    
    private var inputField: InputField<EmptyView, EmptyView> {
        InputField(
            text: .constant(""),
            title: Constants.title,
            placeholder: Constants.placeholder,
            hint: Constants.hint
        )
    }
    
    private var inputFieldText: InputField<EmptyView, EmptyView> {
        InputField(
            text: .constant(Constants.text),
            title: Constants.title,
            placeholder: Constants.placeholder,
            hint: Constants.hint
        )
    }
    
    private var inputFieldLeftView: InputField<Image, EmptyView> {
        InputField(
            text: .constant(" "),
            title: Constants.title,
            placeholder: Constants.placeholder,
            hint: Constants.hint,
            leftView: { Constants.personImage }
        )
    }
    
    
    // MARK: - Override
    
    override func setUp() {
        super.setUp()
        
        setupAppearance()
    }
    
}

// MARK: - Tests

extension GRInputFieldSnapshotTests {
    
    func testBaseInputField() {
        let content = inputField
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
    func testBaseInputFieldDisabled() {
        let content = inputField
            .disabled(true)
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
}

extension GRInputFieldSnapshotTests {
    
    func testInputFieldText() {
        let content = inputFieldText
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
    func testInputFieldTextWithError() {
        let content = inputFieldText
            .validationCriteria {
                Criterion { _ in false }
                    .failWith(error: InternalValidationError.invalid)
                    .realtime()
            }
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
}

extension GRInputFieldSnapshotTests {
    
    func testInputFieldLeftView() {
        let content = inputFieldLeftView
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
    func testInputFieldLeftViewWithError() {
        let content = inputFieldLeftView
            .validationCriteria {
                Criterion { _ in false }
                    .failWith(error: InternalValidationError.invalid)
                    .realtime()
            }
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
}

extension GRInputFieldSnapshotTests {
    
    /// Tests the appearance of a secure (password-style) input field with valid input.
    func testSecureInputField() {
        let content = inputFieldText
            .inputFieldTraits(isSecureTextEntry: true)
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
    /// Tests the appearance of a secure input field when a validation error is present.
    func testSecureInputFieldWithError() {
        let content = inputFieldText
            .inputFieldTraits(isSecureTextEntry: true)
            .validationCriteria {
                Criterion { _ in false }
                    .failWith(error: InternalValidationError.invalid)
                    .realtime()
            }
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReferences)
    }
    
}

// MARK: - Setup Appearance

extension GRInputFieldSnapshotTests {
    
    /// Configures the appearance settings for different input field states used in snapshot tests.
    func setupAppearance() {
        // Appearance for enabled and selected states
        let inputFieldStateAppearance: InputFieldViewStateAppearance = .init(
            placeholderColor: UIColor.darkGray,
            contentBackgroundColor: UIColor.tertiarySystemBackground,
            textFieldTextColor: UIColor.black,
            borderColor: UIColor.lightGray,
            hintColor: UIColor.gray
        )
        
        // Appearance for disabled state
        let disabledInputFieldStateAppearance: InputFieldViewStateAppearance = .init(
            placeholderColor: UIColor.darkGray.withAlphaComponent(0.4),
            contentBackgroundColor: UIColor.secondarySystemBackground,
            textFieldTextColor: UIColor.black.withAlphaComponent(0.4),
            borderColor: UIColor.lightGray.withAlphaComponent(0.4),
            hintColor: UIColor.gray.withAlphaComponent(0.4)
        )
        
        // Appearance for error state
        let failedInputFieldStateAppearance: InputFieldViewStateAppearance = .init(
            placeholderColor: UIColor.darkGray.withAlphaComponent(0.4),
            contentBackgroundColor: UIColor.secondarySystemBackground,
            textFieldTextColor: UIColor.black.withAlphaComponent(0.4),
            borderColor: UIColor.red,
            hintColor: UIColor.red
        )
        
        InputFieldView.defaultAppearance = InputFieldAppearance(
            titleFont: UIFont.preferredFont(forTextStyle: .caption2),
            titleColor: UIColor.black,
            textFieldTintColor: UIColor.systemBlue,
            textFieldFont: UIFont.preferredFont(forTextStyle: .body),
            hintFont: UIFont.preferredFont(forTextStyle: .caption1),
            borderWidth: 1,
            cornerRadius: 8,
            height: 50,
            eyeImageHidden: Constants.eyeImageHidden,
            eyeImageVisible: Constants.eyeImageVisible,
            enabled: inputFieldStateAppearance,
            selected: inputFieldStateAppearance,
            disabled: disabledInputFieldStateAppearance,
            failed: failedInputFieldStateAppearance
        )
    }
    
}
