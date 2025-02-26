//
//  InputFieldView.swift
//  benu
//
//  Created by Maroš Novák on 10/03/2022.
//

import GoodExtensions
import UIKit
import Combine

public class InputFieldView: UIView {

    // MARK: - State

    public enum State: Equatable {

        case enabled
        case disabled
        case selected
        case failed(String?)

    }

    // MARK: - Model

    public struct Model {

        public var title: String?
        public var text: String?

        /// Custom left image.
        public var leftImage: UIImage?

        /// Custom left view. This will be ignored when `leftImage` property is set.
        public var leftView: UIView?

        /// Custom right view. This will be ignored when input field is secure.
        public var rightView: UIView?
        public var placeholder: String?
        public var hint: String?
        public var traits: InputFieldTraits?

        public init(
            title: String? = nil,
            text: String? = nil,
            leftImage: UIImage? = nil,
            leftView: UIView? = nil,
            rightView: UIView? = nil,
            placeholder: String? = nil,
            hint: String? = nil,
            traits: InputFieldTraits? = nil
        ) {
            self.title = title
            self.text = text
            self.leftImage = leftImage
            self.leftView = leftView
            self.rightView = rightView
            self.placeholder = placeholder
            self.hint = hint
            self.traits = traits
        }

    }

    // MARK: - Constants

    private struct C {

        static let emptyString = ""

    }

    private let verticalStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 4
        $0.axis = .vertical
    }

    private let horizontalStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 8
    }

    private let titleLabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
    }

    private let contentView = UIView()

    private let leftContainerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private let textField = UITextField().then {
        $0.textAlignment = .left
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private let rightView = UIView().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private lazy var eyeButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private let lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }

    private let hintLabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 2
    }

    // MARK: - Variables

    private weak var completionResponder: UIView?
    private var isSecureTextEntry = false
    private var hapticsAllowed = true

    public var text: String {
        get {
            textField.text ?? C.emptyString
        }
        set {
            textField.text = newValue
            editingChangedSubject.send(newValue)
        }
    }

    public var hint: String?

    private(set) public var state: State! {
        didSet {
            setState(state)
        }
    }

    /// Appearance can be set globally using `configureAppearance()` by modifying the `defaultAppearance`,
    /// or locally by sending an appearance in `setup(with: Model, customAppearance: InputFieldAppearance?)`.
    open var standardAppearance: InputFieldAppearance = defaultAppearance
    public static var defaultAppearance: InputFieldAppearance = .default

    // MARK: - Combine

    internal var cancellables = Set<AnyCancellable>()

    private let willResignSubject = PassthroughSubject<String, Never>()
    private(set) public lazy var willResignPublisher = willResignSubject.eraseToAnyPublisher()

    private let didResignSubject = PassthroughSubject<String, Never>()
    private(set) public lazy var didResignPublisher = didResignSubject.eraseToAnyPublisher()

    public var resignPublisher: AnyPublisher<String, Never> { didResignPublisher.eraseToAnyPublisher() }

    private let returnSubject = PassthroughSubject<String, Never>()
    private(set) public lazy var returnPublisher = returnSubject.eraseToAnyPublisher()

    private let editingChangedSubject = PassthroughSubject<String, Never>()
    private(set) public lazy var editingChangedPublisher = editingChangedSubject.eraseToAnyPublisher()

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupLayout()
    }

}

// MARK: - Private

private extension InputFieldView {

    func setupLayout() {
        setupAppearance()
        addSubviews()
        setupConstraints()
        setupActionHandlers()
    }

    func setupAppearance() {
        titleLabel.font = standardAppearance.titleFont
        titleLabel.textColor = standardAppearance.titleColor

        textField.font = standardAppearance.textFieldFont
        textField.tintColor = standardAppearance.textFieldTintColor

        hintLabel.font = standardAppearance.hintFont

        contentView.layer.cornerRadius = standardAppearance.cornerRadius ?? 0
        contentView.layer.borderWidth = standardAppearance.borderWidth ?? 0

        state = .enabled
    }

    // MARK: States

    func setState(_ state: State?) {
        switch state {
        case .enabled:
            setEnabled()

        case .selected:
            setSelected()

        case .disabled:
            setDisabled()

        case .failed(let message):
            setFailed(message: message)

        case .none:
            fatalError("State cannot be nil")
        }
    }

    func setEnabled() {
        textField.isEnabled = true
        contentView.backgroundColor = standardAppearance.enabled?.contentBackgroundColor
        contentView.layer.borderColor = standardAppearance.enabled?.borderColor?.cgColor

        textField.textColor = standardAppearance.enabled?.textFieldTextColor

        hintLabel.textColor = standardAppearance.enabled?.hintColor
        hintLabel.text = hint

        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? C.emptyString,
            attributes: [.foregroundColor: standardAppearance.enabled?.placeholderColor ?? .gray]
        )
    }

    func setDisabled() {
        textField.isEnabled = false
        contentView.backgroundColor = standardAppearance.disabled?.contentBackgroundColor
        contentView.layer.borderColor = standardAppearance.disabled?.borderColor?.cgColor

        textField.textColor = standardAppearance.disabled?.textFieldTextColor

        hintLabel.textColor = standardAppearance.disabled?.hintColor
        hintLabel.text = hint

        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? C.emptyString,
            attributes: [.foregroundColor: standardAppearance.disabled?.placeholderColor ?? .gray]
        )
    }

    func setSelected() {
        contentView.backgroundColor = standardAppearance.selected?.contentBackgroundColor
        contentView.layer.borderColor = standardAppearance.selected?.borderColor?.cgColor

        textField.textColor = standardAppearance.selected?.textFieldTextColor

        hintLabel.textColor = standardAppearance.selected?.hintColor
        hintLabel.text = hint

        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? C.emptyString,
            attributes: [.foregroundColor: standardAppearance.selected?.placeholderColor ?? .gray]
        )
    }

    func setFailed(message: String?) {
        contentView.backgroundColor = standardAppearance.failed?.contentBackgroundColor
        contentView.layer.borderColor = standardAppearance.failed?.borderColor?.cgColor

        textField.textColor = standardAppearance.failed?.textFieldTextColor

        hintLabel.textColor = standardAppearance.failed?.hintColor
        hintLabel.text = (hint == nil) ? (nil) : (message ?? hint)

        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? C.emptyString,
            attributes: [.foregroundColor: standardAppearance.failed?.placeholderColor ?? .gray]
        )
    }

    func setupTraits(traits: InputFieldTraits) {
        isSecureTextEntry = traits.isSecureTextEntry
        hapticsAllowed = traits.hapticsAllowed
        setSecureTextEntryIfAllowed(isSecure: isSecureTextEntry)

        textField.textContentType = traits.textContentType
        textField.autocapitalizationType = traits.autocapitalizationType
        textField.autocorrectionType = traits.autocorrectionType
        textField.keyboardType = traits.keyboardType
        textField.returnKeyType = traits.returnKeyType
        textField.clearButtonMode = isSecureTextEntry ? .never : traits.clearButtonMode
    }

    func setupToolbarIfNeeded(traits: InputFieldTraits) {
        switch traits.keyboardType {
        case .phonePad, .decimalPad, .asciiCapableNumberPad, .namePhonePad, .numberPad:
            break

        default:
            return
        }

        let toolbar = UIToolbar()
        toolbar.barStyle = .default

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem

        if #available(iOS 14.0, *) {
            done = UIBarButtonItem(
                title: traits.numpadReturnKeyTitle,
                primaryAction: UIAction { [weak self] _ in self?.return() }
            )
        } else {
            done = UIBarButtonItem(
                title: traits.numpadReturnKeyTitle,
                style: .done,
                target: self,
                action: #selector(self.return)
            )
        }

        toolbar.items = [space, done]
        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
    }

    // MARK: Subviews

    func addSubviews() {
        [titleLabel, contentView, hintLabel].forEach {
            verticalStackView.addArrangedSubview($0)
        }

        [leftContainerImageView, textField].forEach {
            horizontalStackView.addArrangedSubview($0)
        }

        contentView.addSubview(horizontalStackView)
        addSubview(verticalStackView)

        horizontalStackView.isLayoutMarginsRelativeArrangement = true
        horizontalStackView.directionalLayoutMargins.leading = 16
        horizontalStackView.directionalLayoutMargins.trailing = 16
    }

    // MARK: Constraints

    func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.heightAnchor.constraint(equalToConstant: standardAppearance.height ?? 50),

            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: Action handlers

    func setupActionHandlers() {
        textField.addTarget(self, action: #selector(onEditingBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(onEditingEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(`return`), for: .editingDidEndOnExit)
    }

    func setupEyeButtonHandler() {
        eyeButton.addTarget(self, action: #selector(onEyeButtonPressed), for: .touchUpInside)
    }

    // MARK: Helper methods

    func setSecureTextEntryIfAllowed(isSecure: Bool) {
        guard isSecureTextEntry else { return }

        let eyeImage = isSecure
        ? standardAppearance.eyeImageHidden ?? UIImage(systemName: "eye")
        : standardAppearance.eyeImageVisible ?? UIImage(systemName: "eye.slash")

        eyeButton.isHidden = false
        eyeButton.setImage(eyeImage, for: .normal)
        textField.isSecureTextEntry = isSecure
    }

    func trimWhitespaceIfAllowed() {
        guard !isSecureTextEntry else { return }
        switch textField.textContentType {
        case .password?, .newPassword?:
            return

        default:
            textField.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

}

// MARK: - Event action handlers

private extension InputFieldView {

    @objc func onEditingBegin() {
        if case .enabled? = state {
            state = .selected
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.isSecureTextEntry else { return }

            let endPosition = self.textField.endOfDocument
            self.textField.selectedTextRange = self.textField.textRange(from: endPosition, to: endPosition)
        }
    }

    @objc func onEditingChanged() {
        if case .failed? = state {
            state = .selected
        }
        editingChangedSubject.send(text)
    }

    @objc func onEditingEnd() {
        state = .enabled
        setSecureTextEntryIfAllowed(isSecure: true)
        trimWhitespaceIfAllowed()

        // due to synchronous nature of publishers when executing on the same thread
        // willResignSubject is expected to modify the state before resigning
        willResignSubject.send(text)

        didResignSubject.send(text)
    }

    @objc func `return`() {
        if textField.delegate?.textFieldShouldReturn?(textField) ?? true {
            if let completionResponder = completionResponder {
                completionResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            returnSubject.send(text)
            hapticTap()
        }
    }

    @objc func onEyeButtonPressed() {
        textField.becomeFirstResponder()
        setSecureTextEntryIfAllowed(isSecure: !textField.isSecureTextEntry)
    }

}

// MARK: - Internal

internal extension InputFieldView {

    func setupCustomLeftView(leftImage: UIImage?, leftView: UIView?) {
        /// Left view/image
        leftContainerImageView.subviews.forEach { $0.removeFromSuperview() }
        leftContainerImageView.image = nil

        if let leftImage {
            leftContainerImageView.image = leftImage
            leftContainerImageView.isHidden = false
        } else if let leftView {
            leftContainerImageView.isHidden = false
            leftContainerImageView.addSubview(leftView)

            leftView.translatesAutoresizingMaskIntoConstraints = false
            leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            NSLayoutConstraint.activate([
                leftView.topAnchor.constraint(equalTo: leftContainerImageView.topAnchor),
                leftView.leadingAnchor.constraint(equalTo: leftContainerImageView.leadingAnchor),
                leftView.trailingAnchor.constraint(equalTo: leftContainerImageView.trailingAnchor),
                leftView.bottomAnchor.constraint(equalTo: leftContainerImageView.bottomAnchor)
            ])
        } else {
            leftContainerImageView.isHidden = true
        }
    }

    func setupCustomRightView(rightView rightSubview: UIView?) {
        /// Right view
        if let rightSubview, !isSecureTextEntry {
            horizontalStackView.addArrangedSubview(rightView)
            rightView.subviews.forEach { $0.removeFromSuperview() }
            rightView.addSubview(rightSubview)

            rightSubview.translatesAutoresizingMaskIntoConstraints = false
            rightSubview.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            rightSubview.setContentCompressionResistancePriority(.required, for: .horizontal)

            NSLayoutConstraint.activate([
                rightSubview.topAnchor.constraint(equalTo: rightView.topAnchor),
                rightSubview.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
                rightSubview.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
                rightSubview.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
            ])
        } else if isSecureTextEntry {
            horizontalStackView.addArrangedSubview(rightView)
            rightView.subviews.forEach { $0.removeFromSuperview() }
            rightView.addSubview(eyeButton)

            NSLayoutConstraint.activate([
                eyeButton.topAnchor.constraint(equalTo: rightView.topAnchor),
                eyeButton.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
                eyeButton.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
                eyeButton.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
            ])

            setupEyeButtonHandler()
        }
    }

}

// MARK: - Public

public extension InputFieldView {

    override var inputView: UIView? {
        get {
            textField.inputView
        }
        set {
            textField.inputView = newValue
        }
    }

    var isEnabled: Bool {
        get {
            textField.isEnabled
        }
        set {
            if case .enabled = state, newValue == false {
                state = .disabled
            } else if case .disabled = state, newValue == true {
                state = .enabled
            } else {
                textField.isEnabled = newValue
            }
        }
    }

    var isSelected: Bool { textField.isSelected }

    func setup(with model: Model, customAppearance: InputFieldAppearance? = nil) {
        if let customAppearance {
            standardAppearance = customAppearance
            setupAppearance()
        }

        /// Traits
        setupTraits(traits: model.traits ?? .default)
        setupToolbarIfNeeded(traits: model.traits ?? .default)

        setupCustomLeftView(leftImage: model.leftImage, leftView: model.leftView)
        setupCustomRightView(rightView: model.rightView)

        /// Input field title
        if let title = model.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        /// Placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: model.placeholder ?? C.emptyString,
            attributes: [.foregroundColor: standardAppearance.enabled?.placeholderColor ?? .gray]
        )

        /// Hint
        if let hintText = model.hint {
            hintLabel.text = hintText
            hint = hintText
        }

        /// Text
        textField.text = model.text
    }

    func fail(with errorMessage: String?) {
        state = .failed(errorMessage)
        hapticError()
    }

    func failSilently(with errorMessage: String?) {
        state = .failed(errorMessage)
    }

    func unfail() {
        if isSelected {
            state = .selected
            return
        }
        if isEnabled {
            state = .enabled
            return
        }
        state = .disabled
    }

    func beginEditing() {
        textField.becomeFirstResponder()
    }

    func setNextResponder(_ nextResponder: UIView?) {
        completionResponder = nextResponder
    }

    func attachTextFieldDelegate(_ delegate: any UITextFieldDelegate) {
        textField.delegate = delegate
    }

}

// MARK: - Internal

internal extension InputFieldView {

    /// Updates text in internal textfield without notifying Combine event subscribers. Checks if textfield
    /// is currently not being edited (textfield state is not `selected`) before changing the value.
    /// - Parameters:
    ///   - text: New text to set.
    ///   - force: When force is set to `true`, skips checking if textfield is being edited and always changes the value.
    func updateText(_ text: String, force: Bool = false) {
        guard state != .selected || force else {
            return
        }
        textField.text = text
    }

}

// MARK: - Tap gesture recognizer

public extension InputFieldView {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.becomeFirstResponder()
    }

    override var isFirstResponder: Bool {
        textField.isFirstResponder
    }

    override var canBecomeFirstResponder: Bool {
        false
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()

        guard state != .disabled else {
            if let completionResponder = completionResponder {
                completionResponder.becomeFirstResponder()
            }
            return false
        }

        textField.becomeFirstResponder()
        return false
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

}

// MARK: - Haptics

private extension InputFieldView {

    func hapticTap() {
        if hapticsAllowed {
            GRHapticsManager.shared.playSelectionFeedback()
        }
    }

    func hapticError() {
        if hapticsAllowed {
            GRHapticsManager.shared.playNotificationFeedback(.error)
        }
    }

}
