//
//  InputFieldSampleView.swift
//  GoodSwiftUI-Sample
//
//  Created by Filip Šašala on 25/06/2024.
//

import SwiftUI
import GRInputField

struct InputFieldSampleView: View {

    enum RegistrationError: ValidationError {

        case notFilip
        case pinTooShort

        var localizedDescription: String {
            switch self {
            case .notFilip:
                "Your name is not Filip"

            case .pinTooShort:
                "PIN code must be at least 6 numbers long"
            }
        }

    }

    enum LoginFields: Int, CaseIterable, Equatable, Hashable {
        case name, pin
    }

    // MARK: - Wrappers

    // MARK: - View state

    @FocusState private var focusState: LoginFields?
    @State private var validityGroup = ValidityGroup()

    @State private var name: String = ""
    @State private var password: String = ""

    @State private var nameEnabled: Bool = true
    @State private var passwordEnabled: Bool = true

    // MARK: - Properties

    // MARK: - Initialization

    init() {
        // Set up appearance during app launch or screen init()
        InputFieldView.configureAppearance()
    }

    // MARK: - Computed properties

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack {
                // Text field
                InputField(text: $name, title: "Name", placeholder: "Jožko")

                    // "Continue" keyboard action button
                    .inputFieldTraits(returnKeyType: .continue)

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

                // Input field controls
                VStack(spacing: 16) {

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

                    Divider()

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

                    Divider()

                    Toggle("Name enabled", isOn: $nameEnabled)
                    Toggle("PIN enabled", isOn: $passwordEnabled)
                }
                .padding(.vertical)
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

}

// MARK: - SwiftUI preview

#Preview {
    InputFieldSampleView()
}

// MARK: - UIKit preview

@available(iOS 17.0, *)
#Preview {
    let _: () = InputFieldView.configureAppearance()

    let inputField = InputFieldView(frame: CGRect(x: 0, y: 100, width: 250, height: 56))
    inputField.setup(with: .init(
        title: "Title",
        text: .placeholder(length: 20),
        leftImage: nil,
        rightButton: nil,
        placeholder: "Placeholder",
        hint: " ",
        traits: .default
    ))

    let validableInputField = ValidableInputFieldView(frame: CGRect(x: 0, y: 100, width: 250, height: 56))
    validableInputField.setup(with: .init(
        title: "Title",
        text: .placeholder(length: 8),
        leftImage: nil,
        rightButton: nil,
        placeholder: "Placeholder",
        hint: " ",
        traits: .init(isSecureTextEntry: true)
    ))

    inputField.setNextResponder(validableInputField)
    validableInputField.setValidationCriteria { Criterion.nonEmpty }
    validableInputField.setPostValidationAction { result in print("Hello validation - \(result)") }

    let stackView = UIStackView(arrangedSubviews: [
        inputField, validableInputField
    ])

    stackView.axis = .vertical
    stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true

    return stackView
}
