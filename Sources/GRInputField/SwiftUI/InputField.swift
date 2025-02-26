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

public struct InputField<LeftView: View, RightView: View>: UIViewRepresentable {

    // MARK: - Typealiases

    #warning("TODO: Update to RegexBuilder")
    public typealias Regex = String

    // MARK: - Wrappers

    @Binding public var text: String
    @Binding private var validityGroup: ValidityGroup

    // MARK: - Variables

    public let title: String?
    public let placeholder: String?
    public let hint: String?

    public let leftView: MainSupplier<LeftView>
    public let rightView: MainSupplier<RightView>

    private var hasFormatting: Bool = false

    private var traits: InputFieldTraits
    private var allowedInput: Regex?
    @ValidatorBuilder private var criteria: MainSupplier<Validator>
    private var focusAction: MainClosure?
    private var submitAction: MainClosure?
    private var resignAction: MainClosure?
    private var editingChangedAction: MainClosure?

    /// Change appearance with `.inputFieldStyle()` modifier
    private var customAppearance: InputFieldAppearance?

    // MARK: - Initialization

    public init(
        text: Binding<String>,
        title: String? = nil,
        placeholder: String? = nil,
        hint: String? = " ",
        leftView: @escaping MainSupplier<LeftView> = { EmptyView() },
        rightView: @escaping MainSupplier<RightView> = { EmptyView() }
    ) {
        self._text = text
        self._validityGroup = Binding.constant([:])
        self.title = title
        self.placeholder = placeholder
        self.hint = hint
        self.traits = InputFieldTraits()
        self.criteria = { Validator(criteria: [Criterion.alwaysValid]) }
        self.leftView = leftView
        self.rightView = rightView
    }

    @available(iOS 15.0, *)
    public init<FormattedType, FormatterType: ParseableFormatStyle>(
        value: Binding<FormattedType>,
        format: FormatterType,
        title: String? = nil,
        placeholder: String? = nil,
        hint: String? = " ",
        leftView: @escaping MainSupplier<LeftView> = { EmptyView() },
        rightView: @escaping MainSupplier<RightView> = { EmptyView() }
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

        self.init(
            text: formattedBinding,
            title: title,
            placeholder: placeholder,
            hint: hint,
            leftView: leftView,
            rightView: rightView
        )
        self.hasFormatting = true
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, UITextFieldDelegate {

        let textFieldUUID = UUID()

        var cancellables = Set<AnyCancellable>()
        var focusAction: MainClosure?
        var submitAction: MainClosure?
        var allowedInput: Regex?

        public override init() {}

        /// Prevent SwiftUI from dismissing keyboard for a split of a second
        /// when binding to `@FocusState` changes (custom return action)
        /// - Parameter textField: Text field in question
        /// - Returns: true if keyboard should dismiss
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            defer { submitAction?() }
            if let focusAction {
                focusAction()
                return false
            } else {
                return true
            }
        }

        public func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            guard let allowedInput else { return true }

            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)

                do {
                    let regex = try NSRegularExpression(pattern: allowedInput, options: [])
                    let range = NSRange(location: .zero, length: updatedText.utf16.count)
                    let matches = regex.matches(
                        in: updatedText.folding(options: .diacriticInsensitive, locale: nil),
                        options: [],
                        range: range
                    )

                    return !matches.isEmpty
                } catch {
                    print("Invalid regular expression: \(error.localizedDescription)")

                    return false
                }
            }
            return false
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
            leftView: makeSupplementaryView(from: leftView()),
            rightView: makeSupplementaryView(from: rightView()),
            placeholder: placeholder,
            hint: hint,
            traits: traits
        )

        view.setup(with: model, customAppearance: customAppearance)
        view.attachTextFieldDelegate(context.coordinator)

        view.setValidationCriteria(criteria)
        view.setPostValidationAction { validationError in
            if let validationError {
                syncValidationState(uiViewState: .error(validationError), context: context)
            } else {
                syncValidationState(uiViewState: .valid, context: context)
            }
        }

        context.coordinator.focusAction = focusAction
        context.coordinator.submitAction = submitAction
        context.coordinator.allowedInput = allowedInput

        let editingChangedCancellable = view.editingChangedPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { newText in
                self.text = newText
                syncValidationState(uiViewState: .invalid, context: context)

                if hasFormatting {
                    applyFormatting()
                }

                editingChangedAction?()
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

        uiView.setupCustomLeftView(
            leftImage: nil,
            leftView: makeSupplementaryView(from: leftView())
        )
        uiView.setupCustomRightView(
            rightView: makeSupplementaryView(from: rightView())
        )

        // Equality check to prevent unintended side effects
        if uiView.isEnabled != context.environment.isEnabled {
            uiView.isEnabled = context.environment.isEnabled
        }

        updateValidationState(uiView: uiView, context: context)
    }

    public static func dismantleUIView(_ uiView: ValidableInputFieldView, coordinator: Coordinator) {
        coordinator.cancellables.removeAll()
    }

    private func makeSupplementaryView<V: View>(from view: V) -> _UIHostingView<V>? {
        guard !(view is EmptyView) else { return .none }

        return _UIHostingView(rootView: view)
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

    private func syncValidationState(uiViewState validationState: ValidationState, context: InputField.Context) {
        Task { @MainActor in
            validityGroup.updateValue(
                validationState,
                forKey: context.coordinator.textFieldUUID
            )
        }
    }

    private func syncValidationState(internalState: ValidationState, inputField: ValidableInputFieldView) {
        switch internalState {
        case .valid:
            inputField.unfail()

        case .error(let validationError):
            inputField.failSilently(with: validationError.localizedDescription)

        case .pending:
            break

        case .invalid:
            break
        }
    }

    private func updateValidationState(uiView: ValidableInputFieldView, context: Context) {
        let previousValidationState = validityGroup[context.coordinator.textFieldUUID]
        let validationError = criteria().validate(input: text)
        let newValidationState: ValidationState = if let validationError {
            .error(validationError)
        } else {
            .valid
        }

        // On first appear
        if previousValidationState == nil {
            if uiView.text.isEmpty {
                return syncValidationState(uiViewState: .pending(error: validationError), context: context)
            } else {
                changeValidationState(to: newValidationState, uiView: uiView, context: context)
            }
        }

        if case .pending = previousValidationState {
            return
        }

        if case .invalid = previousValidationState {
            return syncValidationState(uiViewState: .pending(error: validationError), context: context)
        }

        guard newValidationState != previousValidationState else {
            return
        }

        changeValidationState(to: newValidationState, uiView: uiView, context: context)
    }

    private func changeValidationState(to newState: ValidationState, uiView: ValidableInputFieldView, context: Context) {
        // This is a new state!
        // Update locally in SwiftUI storage
        syncValidationState(uiViewState: newState, context: context)

        // And push to UIView
        syncValidationState(internalState: newState, inputField: uiView)
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
        modifiedSelf.focusAction = { focusNextField(in: focusState) }
        return modifiedSelf.focused(focusState, equals: field)
    }

    func validityGroup(_ binding: Binding<ValidityGroup>) -> Self {
        var modifiedSelf = self
        modifiedSelf._validityGroup = binding
        return modifiedSelf
    }

    func onResign(_ action: @escaping MainClosure) -> Self {
        var modifiedSelf = self
        modifiedSelf.resignAction = action
        return modifiedSelf
    }

    func onSubmit(_ action: @escaping MainClosure) -> Self {
        var modifiedSelf = self
        modifiedSelf.submitAction = action
        return modifiedSelf
    }

    func onEditingChanged(_ action: @escaping MainClosure) -> Self {
        var modifiedSelf = self
        modifiedSelf.editingChangedAction = action
        return modifiedSelf
    }

    func validationCriteria(@ValidatorBuilder _ criteria: @escaping MainSupplier<Validator>) -> Self {
        var modifiedSelf = self
        modifiedSelf.criteria = criteria
        return modifiedSelf
    }

    func inputFieldStyle(_ appearance: InputFieldAppearance) -> Self {
        var modifiedSelf = self
        modifiedSelf.customAppearance = appearance
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
        hapticsAllowed: Bool = true
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
            hapticsAllowed: hapticsAllowed
        )
        return modifiedSelf
    }

    func allowedInput(_ allowedInputRegex: Regex?) -> Self {
        var modifiedSelf = self
        modifiedSelf.allowedInput = allowedInputRegex
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
            MainActor.assumeIsolated {
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

}
