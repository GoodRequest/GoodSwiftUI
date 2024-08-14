//
//  ValidableInputFieldView.swift
//  benu
//
//  Created by Filip Šašala on 08/08/2022.
//

import Combine
import GoodExtensions
import UIKit

public class ValidableInputFieldView: InputFieldView {

    public typealias PostValidationAction = @MainActor ((any ValidationError)?) -> ()

    // MARK: - Variables

    private var validator: (() -> Validator)?
    private var afterValidation: PostValidationAction?

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupValidators()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupValidators()
    }

    // MARK: - Public

    public func setValidationCriteria(@ValidatorBuilder _ validator: @escaping () -> Validator) {
        self.validator = validator
    }

    public func setPostValidationAction(_ action: @escaping PostValidationAction) {
        self.afterValidation = action
    }

    /// Requests validation of this text fields' content. Text field will automatically update the appearance to
    /// valid/invalid state, depending on the result of validation.
    ///
    /// If no validator is set, this function will crash. Please make sure to set validation criteria before
    /// requesting validation.
    /// - Returns: `true` when content is valid, `false` otherwise
    @discardableResult
    public func validate() -> Bool {
        guard let validator = validator?() else { fatalError("Validator not set") }

        if let error = validator.validate(input: self.text) {
            fail(with: error.localizedDescription)
            afterValidation?(error)
            return false
        } else {
            unfail()
            afterValidation?(nil)
            return true
        }
    }

    /// Validates the content and returns an appropriate error.
    ///
    /// Does not update the UI in any way.
    /// - Returns: `nil` when content is valid, otherwise validation error from failed criterion.
    public func validateSilently() -> (any ValidationError)? {
        guard let validator = validator?() else { return InternalValidationError.alwaysError }

        return validator.validate(input: self.text)
    }

    // MARK: - Private

    private func setupValidators() {
        didResignPublisher
            .map { [weak self] _ in self?.validator?().validate(input: self?.text) }
            .sink { [weak self] error in
                if let error { self?.fail(with: error.localizedDescription) }
                self?.afterValidation?(error) // If wrapped in UIViewRepresentable, update SwiftUI state here
            }
            .store(in: &cancellables)
    }

}

// MARK: - Formatting

@available(iOS 15.0, *)
public class FormattableValidableInputFieldView<FormattedType, FormatterType: ParseableFormatStyle>: ValidableInputFieldView where FormatterType.FormatInput == FormattedType, FormatterType.FormatOutput == String {

    private var lastValidString: String = ""

    public var value: FormattedType? {
        get {
            try? formatter.parseStrategy.parse(self.text)
        }
        set {
            if let newValue {
                self.text = formatter.format(newValue)
            } else {
                self.text = ""
            }
        }
    }

    public var formatter: FormatterType

    public init(formatter: FormatterType, frame: CGRect) {
        self.formatter = formatter

        super.init(frame: frame)

        setupFormatter()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFormatter() {
        willResignPublisher
            .sink { [weak self] newString in
                guard let self else { return }
                guard let newValue = try? formatter.parseStrategy.parse(newString) else { return revert() }

                value = newValue
                lastValidString = newString
            }
            .store(in: &cancellables)
    }

    private func revert() {
        let oldValue = try? formatter.parseStrategy.parse(lastValidString)
        value = oldValue
    }

}
