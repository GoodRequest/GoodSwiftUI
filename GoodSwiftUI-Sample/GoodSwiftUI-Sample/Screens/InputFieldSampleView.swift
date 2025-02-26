//
//  InputFieldSampleView.swift
//  GoodSwiftUI-Sample
//
//  Created by Filip Šašala on 25/06/2024.
//

import SwiftUI
import GRInputField

struct InputFieldSampleView: View {

    // Custom validation error with error descriptions
    enum RegistrationError: ValidationError {

        case notFilip
        case pinTooShort

        var errorDescription: String? {
            switch self {
            case .notFilip:
                "Your name is not Filip"

            case .pinTooShort:
                "PIN code must be at least 6 numbers long"
            }
        }

    }

    // Iterable enum with Integer raw values for managing SwiftUI focus state
    // and specifying the ordering of input fields
    enum LoginFields: Int, CaseIterable, Equatable, Hashable {
        case name, pin
    }

    // MARK: - Wrappers

    // MARK: - View state

    @FocusState private var focusState: LoginFields?
    @State private var validityGroup = ValidityGroup()

    @State private var name: String = ""
    @State private var password: String = ""
    @State private var percent: Double = 0.5

    @State private var nameEnabled: Bool = true
    @State private var passwordEnabled: Bool = true
    @State private var showsRightAlert: Bool = false

    // MARK: - Properties

    // MARK: - Initialization

    init() {
        // Set up appearance during app launch or screen init()
        InputFieldView.configureAppearance()
    }

    // MARK: - Computed properties

    // MARK: - Example

    var body: some View {
        ScrollView {
            VStack {
                nameInputField
                pinCodeInputField
                customViewsInputField
                formattedInputField

                // Input field controls
                VStack(spacing: 16) {
                    validityGroups

                    Divider()

                    metadata

                    Divider()

                    disableToggles
                }
                .padding()
                .background { Color(uiColor: UIColor.secondarySystemBackground) }
                .clipShape(.rect(cornerRadius: 12))
                .padding(.vertical)
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Input fields")
    }

}

// MARK: - Examples

extension InputFieldSampleView {

    private var nameInputField: some View {
        // Text field
        InputField(text: $name, title: "Name", placeholder: "Jožko", hint: "Text is limited to 10 characters")
            .inputFieldStyle(.custom)

        // "Continue" keyboard action button
            .inputFieldTraits(returnKeyType: .continue)
            .allowedInput("^.{0,10}$")

        // Validates name to be equal to "Filip", otherwise fails with custom error
            .validationCriteria {
                Criterion.matches("Filip")
                    .failWith(error: RegistrationError.notFilip)
            }

        // Validity group to check for validity
            .validityGroup($validityGroup)

        // Focus state binding to advance focus from keyboard action button (Continue)
            .bindFocusState($focusState, to: .name)
            .disabled(!nameEnabled)
    }

    private var pinCodeInputField: some View {
        // Text field
        InputField(text: $password, title: "PIN code", hint: "At least 6 numbers")

        // Multiple custom traits
            .inputFieldTraits(
                keyboardType: .numberPad,
                numpadReturnKeyTitle: "Done",
                isSecureTextEntry: true
            )

        // Custom validation criteria closure
            .validationCriteria {
                Criterion { password in
                    password?.count ?? 0 >= 6
                }
                .failWith(error: RegistrationError.pinTooShort)
            }

            .validityGroup($validityGroup)
            .bindFocusState($focusState, to: .pin)
            .disabled(!passwordEnabled)
    }

    private var percentFormattedInputField: some View {
        // Text field with custom formatter
        InputField(
            value: $percent,
            format: .percent.precision(.fractionLength(0..<2)),
            title: "Percent (%)",
            placeholder: "0 %"
        )
        .inputFieldTraits(keyboardType: .numbersAndPunctuation)
        .onSubmit {
            print("Submit action")
        }
        .onResign {
            print("Resign action")
        }
        .onEditingChanged {
            print("Value changed")
        }
    }

    private var customViewsInputField: some View {
        InputField(
            text: .constant("Custom views"),
            title: "Left and right input views",
            placeholder: nil,
            hint: nil,
            leftView: {
                Text("+421 \(password)")
            },
            rightView: {
                Button {
                    showsRightAlert.toggle()
                } label: {
                    VStack {
                        Text("Hello")
                        Text("world")
                    }
                }
            }
        )
        .alert("Alert", isPresented: $showsRightAlert, actions: {})
    }

    private var validityGroups: some View {
        Group {
            // Checking validity state on fields
            // Doesn't reflect state visible to the user, but the actual validity of data
            if validityGroup.allValid() {
                Text("Internal validation state: ") + Text("valid").foregroundColor(.green)
            } else {
                Text("Internal validation state: ") + Text("invalid").foregroundColor(.red)
            }

            // Invoking validation of the whole validity group
            // State visible to the user is changed to reflect validity of data
            Button("Force validation on all fields") {
                validityGroup.validateAll()
            }

            // State visible to the user is reset to default and
            // all data is revalidated in the background.
            Button("Remove validation metadata") {
                validityGroup.removeAll()
            }
        }
    }

}

// MARK: - Internal

extension InputFieldSampleView {

    private var metadata: some View {
        Group {
            Text("Internal metadata:")
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [GridItem(.fixed(100)), GridItem()], content: {
                Text("Focus state")
                Text(String(describing: focusState))

                ForEach(Array(validityGroup), id: \.key) { id, state in
                    let uuidString = id.uuidString
                    let startIndex = uuidString.startIndex
                    let endIndex = uuidString.index(startIndex, offsetBy: 6)

                    Text(String(uuidString[startIndex...endIndex]))

                    Text(String(describing: state))
                }
            })
        }
    }

    private var disableToggles: some View {
        Group {
            Toggle("Name enabled", isOn: $nameEnabled)
            Toggle("PIN enabled", isOn: $passwordEnabled)
        }
    }

    private var formattedInputField: some View {
        Group {
            percentFormattedInputField

            Text("Native input field + percent format style")
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField(
                value: $percent,
                format: .percent.precision(.fractionLength(0..<2)),
                label: { Text("Percent (%)") }
            )
            .keyboardType(.numbersAndPunctuation)

            Text("Current value slider (0 - 1)")
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Slider(value: $percent)
        }
    }

}

// MARK: - SwiftUI preview

#Preview {
    InputFieldSampleView()
}

// MARK: - UIKit preview

@available(iOS 17.0, *)
#Preview {
    InputFieldSampleViewController()
}


private final class InputFieldSampleViewController: UIViewController {

    enum PercentError: ValidationError {
        case tooSmall
        case notPercent

        var localizedDescription: String {
            switch self {
            case .tooSmall:
                "Too small"
            case .notPercent:
                "Not a percent value"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let _: () = InputFieldView.configureAppearance()

        let inputField = InputFieldView(frame: CGRect(x: 0, y: 100, width: 250, height: 56))
        inputField.setup(with: .init(
            title: "Title",
            text: .placeholder(length: 20),
            leftImage: nil,
            rightView: nil,
            placeholder: "Placeholder",
            hint: " ",
            traits: .default
        ))

        let validableInputField = ValidableInputFieldView(frame: CGRect(x: 0, y: 100, width: 250, height: 56))
        validableInputField.setup(with: .init(
            title: "Title",
            text: .placeholder(length: 8),
            leftImage: nil,
            rightView: nil,
            placeholder: "Placeholder",
            hint: " ",
            traits: .init(isSecureTextEntry: true)
        ))

        let formattableInputField = FormattableValidableInputFieldView<Double, FloatingPointFormatStyle.Percent>(
            formatter: .percent.precision(.fractionLength(0..<2)),
            frame: CGRect(x: 0, y: 100, width: 250, height: 56)
        )
        formattableInputField.setup(with: .init(
            title: "Title",
            text: "0 %",
            leftImage: nil,
            rightView: nil,
            placeholder: "Placeholder",
            hint: " ",
            traits: .init(keyboardType: .numberPad)
        ))

        inputField.setNextResponder(validableInputField)
        validableInputField.setNextResponder(formattableInputField)

        validableInputField.setValidationCriteria { Criterion.nonEmpty }
        validableInputField.setPostValidationAction { result in print("Hello validation - \(String(describing: result))") }

        formattableInputField.setValidationCriteria {
            Criterion(predicate: { text in
                text?.last == "%"
            })
            .failWith(error: PercentError.notPercent)

            Criterion(predicate: { [weak formattableInputField] _ in
                guard let value = formattableInputField?.value else { return false }
                return value > 0.5
            })
            .failWith(error: PercentError.tooSmall)
        }

        let stackView = UIStackView(arrangedSubviews: [
            inputField, validableInputField, formattableInputField, UIView()
        ])

        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
