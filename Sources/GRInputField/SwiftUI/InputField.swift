//
//  InputField.swift
//  benu
//
//  Created by Filip Šašala on 10/04/2024.
//

import Combine
import GoodExtensions
import SwiftUI

// MARK: - View

public struct InputField: UIViewRepresentable {

    // MARK: - Wrappers

    @Binding public var text: String
    @Binding private var validityGroup: ValidityGroup

    // MARK: - Variables

    public let title: String?
    public let placeholder: String?
    public let hint: String?
    public let rightButton: Supplier<UIButton>?

    private var hasFormatting: Bool = false

    private var traits: InputFieldTraits
    @ValidatorBuilder private var criteria: Supplier<Validator>
    private var returnAction: VoidClosure?
    private var resignAction: VoidClosure?

    // MARK: - Initialization

    public init(
        text: Binding<String>,
        title: String? = nil,
        placeholder: String? = nil,
        hint: String? = " ",
        rightButton: Supplier<UIButton>? = nil
    ) {
        self._text = text
        self._validityGroup = Binding.constant([:])
        self.title = title
        self.placeholder = placeholder
        self.hint = hint
        self.rightButton = rightButton
        self.traits = InputFieldTraits()

        @ValidatorBuilder func alwaysValidCriteria() -> Validator {
            Criterion.alwaysValid
        }

        // closures cannot take @ValidationBuilder attribute, must be a function reference
        self.criteria = alwaysValidCriteria
    }

    @available(iOS 15.0, *)
    public init<FormattedType, FormatterType: ParseableFormatStyle>(
        value: Binding<FormattedType>,
        format: FormatterType,
        title: String? = nil,
        placeholder: String? = nil,
        hint: String? = " ",
        rightButton: Supplier<UIButton>? = nil
    ) where FormatterType.FormatInput == FormattedType, FormatterType.FormatOutput == String {
        let formattedBinding = Binding(get: {
            let formattedString = format.format(value.wrappedValue)
            return formattedString
        }, set: { newString in
            do {
                let parsedValue = try format.parseStrategy.parse(newString)
                value.wrappedValue = parsedValue
            } catch {
                // skip assigning invalid value
            }
        })

        self.init(text: formattedBinding, title: title, placeholder: placeholder, hint: hint, rightButton: rightButton)
        self.hasFormatting = true
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, UITextFieldDelegate {

        let textFieldUUID = UUID()

        var cancellables = Set<AnyCancellable>()
        var returnAction: VoidClosure?

        public override init() {}

        /// Prevent SwiftUI from dismissing keyboard for a split of a second
        /// when binding to `@FocusState` changes (custom return action)
        /// - Parameter textField: Text field in question
        /// - Returns: true if keyboard should dismiss
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let returnAction {
                returnAction()
                return false
            } else {
                return true
            }
        }

    }

    // MARK: - UIView representable

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public func makeUIView(context: Context) -> ValidableInputFieldView {
        let view = ValidableInputFieldView()
        let model = InputFieldView.Model(
            title: title,
            rightButton: rightButton?(),
            placeholder: placeholder,
            hint: hint,
            traits: traits
        )

        view.setup(with: model)
        view.attachTextFieldDelegate(context.coordinator)

        view.setValidationCriteria(criteria)
        view.setPostValidationAction { validationResult in
            if let error = validationResult {
                setValidityStateInGroup(to: .invalid(error), in: context)
            } else {
                setValidityStateInGroup(to: .valid, in: context)
            }
        }

        context.coordinator.returnAction = returnAction

        let editingChangedCancellable = view.editingChangedPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { newText in
                self.text = newText
                invalidateValidityState(in: context)

                if hasFormatting {
                    applyFormatting()
                }
            }

        let willResignCancellable = view.willResignPublisher
            .sink { [weak view] text in
                guard let view else { return }

                if hasFormatting {
                    applyFormatting()
                    view.updateText(self.text)
                }
            }

        let didResignCancellable = view.didResignPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                resignAction?()
            }

        context.coordinator.cancellables.insert(editingChangedCancellable)
        context.coordinator.cancellables.insert(willResignCancellable)
        context.coordinator.cancellables.insert(didResignCancellable)

        return view
    }
    
    public func updateUIView(_ uiView: ValidableInputFieldView, context: Context) {
        uiView.updateText(self.text, force: true)

        // Equality check to prevent unintended side effects
        if uiView.isEnabled != context.environment.isEnabled {
            uiView.isEnabled = context.environment.isEnabled
        }

        updateValidityState(uiView: uiView, context: context)
    }

    public static func dismantleUIView(_ uiView: ValidableInputFieldView, coordinator: Coordinator) {
        coordinator.cancellables.removeAll()
    }

    // MARK: - Layout

    @available(iOS 16.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: ValidableInputFieldView, context: Context) -> CGSize? {
        let intrinsicSize = uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        var optimalSize = CGSize()
        optimalSize.width = proposal.width ?? intrinsicSize.width
        optimalSize.height = intrinsicSize.height

        return optimalSize
    }

    // MARK: - Validation

    private func updateValidityState(uiView: ValidableInputFieldView, context: InputField.Context) {
        let validityState = validityGroup[context.coordinator.textFieldUUID]
        switch validityState {
        case .valid:
            uiView.unfail()

        case .invalid(let error):
            uiView.failSilently(with: error.localizedDescription)

        case .none:
            setValidityStateInGroup(to: .pending(uiView.validateSilently()), in: context)

        case .pending:
            break
        }
    }

    private func setValidityStateInGroup(to validationState: ValidationState, in context: Context) {
        Task { @MainActor in
            validityGroup.updateValue(
                validationState,
                forKey: context.coordinator.textFieldUUID
            )
        }
    }

    private func invalidateValidityState(in context: Context) {
        Task { @MainActor in
            validityGroup.removeValue(forKey: context.coordinator.textFieldUUID)
        }
    }

    // MARK: - Formatting

    func applyFormatting() {
        // (get)self.text = get value from storage (not formatted) and format it (in Binding.get)
        let formatted = self.text

        // (set)self.text = store formatted value back to storage
        self.text = formatted
    }

}

// MARK: - Public modifiers

public extension InputField {

    @available(iOS 15.0, *)
    func bindFocusState<Focus: RawRepresentable & CaseIterable & Hashable>(
        _ focusState: FocusState<Focus?>.Binding,
        to field: Focus
    ) -> some View where Focus.RawValue == Int {
        var modifiedSelf = self
        modifiedSelf.returnAction = { focusNextField(in: focusState) }
        return modifiedSelf.focused(focusState, equals: field)
    }

    func validityGroup(_ binding: Binding<ValidityGroup>) -> Self {
        var modifiedSelf = self
        modifiedSelf._validityGroup = binding
        return modifiedSelf
    }

    func onResign(_ action: @escaping VoidClosure) -> Self {
        var modifiedSelf = self
        modifiedSelf.resignAction = action
        return modifiedSelf
    }

    func validationCriteria(@ValidatorBuilder _ criteria: @escaping () -> Validator) -> Self {
        var modifiedSelf = self
        modifiedSelf.criteria = criteria
        return modifiedSelf
    }

    func inputFieldTraits(
        textContentType: UITextContentType? = .none,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        autocorrectionType: UITextAutocorrectionType = .default,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .default,
        numpadReturnKeyTitle: String? = "Done",
        clearButtonMode: UITextField.ViewMode = .whileEditing,
        isSecureTextEntry: Bool = false,
        isHapticsAllowed: Bool = true
    ) -> Self {
        var modifiedSelf = self
        modifiedSelf.traits = InputFieldTraits(
            textContentType: textContentType,
            autocapitalizationType: autocapitalizationType,
            autocorrectionType: autocorrectionType,
            keyboardType: keyboardType,
            returnKeyType: returnKeyType,
            numpadReturnKeyTitle: numpadReturnKeyTitle,
            clearButtonMode: clearButtonMode,
            isSecureTextEntry: isSecureTextEntry,
            isHapticsAllowed: isHapticsAllowed
        )
        return modifiedSelf
    }

}

// MARK: - View focus extension

@available(iOS 15.0, *)
private extension View {

    func focusNextField<Focus: RawRepresentable & CaseIterable>(in focusState: FocusState<Focus?>.Binding) where Focus.RawValue == Int {
        guard let currentValue = focusState.wrappedValue else { return }

        let nextFieldIndex = currentValue.rawValue + 1
        focusState.wrappedValue = Focus(rawValue: nextFieldIndex)

        // OK to recurse, SwiftUI will update focus state only once to the last valid value
        // Used to skip fields that are not in view hierarchy (hidden) and unable to be focused
        advanceFocusIfNeeded(nextFieldIndex: nextFieldIndex, in: focusState)
    }

    func advanceFocusIfNeeded<Focus: RawRepresentable & CaseIterable>(nextFieldIndex: Int, in focusState: FocusState<Focus?>.Binding) where Focus.RawValue == Int {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(10)) {
            if focusState.wrappedValue?.rawValue != nextFieldIndex {
                let newValue = Focus(rawValue: nextFieldIndex + 1)
                focusState.wrappedValue = newValue

                if newValue.isNotNil {
                    advanceFocusIfNeeded(nextFieldIndex: nextFieldIndex + 1, in: focusState)
                }
            }
        }
    }

}
