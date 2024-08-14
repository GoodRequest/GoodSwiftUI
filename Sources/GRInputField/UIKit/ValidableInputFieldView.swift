//
//  ValidableInputFieldView.swift
//  benu
//
//  Created by Filip Šašala on 08/08/2022.
//

import Combine
import GoodExtensions
import UIKit

public final class ValidableInputFieldView: InputFieldView {

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

    @discardableResult
    func validate() -> Bool {
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

    func validateSilently() -> (any ValidationError)? {
        guard let validator = validator?() else { return InternalValidationError.alwaysError }

        return validator.validate(input: self.text)
    }

    // MARK: - Private

    private func setupValidators() {
        resignPublisher
            .map { [weak self] _ in self?.validator?().validate(input: self?.text) }
            .sink { [weak self] error in
                if let error { self?.fail(with: error.localizedDescription) }
                self?.afterValidation?(error) // If wrapped in UIViewRepresentable, update SwiftUI state here
            }
            .store(in: &cancellables)
    }

}
