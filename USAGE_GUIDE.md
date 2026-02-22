# GoodSwiftUI Usage Guide

A comprehensive guide to using the GoodSwiftUI library in your iOS projects.

> **Note**: This guide includes simplified helper patterns to reduce cognitive load and speed up development.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Components](#components)
  - [GRButton](#grbutton)
  - [GRInputField](#grinputfield)
  - [GRToggle](#grtoggle)
  - [GRAsyncImage](#grasyncimage)
  - [Readable Content Width](#readable-content-width)
- [Helper Patterns](#helper-patterns)
- [Best Practices](#best-practices)

---

## Installation

### Swift Package Manager

#### Option 1: Xcode (Recommended)

1. Open your project in Xcode
2. Go to **File → Add Packages...**
3. Enter the repository URL: `https://github.com/GoodRequest/GoodSwiftUI`
4. Select the version and add the package

#### Option 2: Package.swift

```swift
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/GoodRequest/GoodSwiftUI", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                .product(name: "GoodSwiftUI", package: "GoodSwiftUI"),
                // Or import individual modules:
                // .product(name: "GRButton", package: "GoodSwiftUI"),
                // .product(name: "GRInputField", package: "GoodSwiftUI"),
                // .product(name: "GRToggle", package: "GoodSwiftUI"),
                // .product(name: "GRAsyncImage", package: "GoodSwiftUI"),
            ]
        )
    ]
)
```

---

## Quick Start

Get up and running in under 5 minutes with this copy-paste setup:

### Step 1: Create Appearance Configuration File

```swift
// AppearanceConfig.swift
import GRButton
import GRToggle
import GRInputField

struct AppearanceConfig {
    static func configure() {
        InputFieldView.configureAppearance()
    }
}

// MARK: - Helper Functions (Reduces 9 parameters to 2)

extension GRButtonAppearanceModel {
    static func filled(background: Color, foreground: Color, font: Font = .body.weight(.semibold)) -> Self {
        .init(
            backgroundColor: background,
            disabledBackgroundColor: background.opacity(0.4),
            loadingTintColor: foreground,
            iconTintColor: foreground,
            iconDisabledTintColor: foreground.opacity(0.4),
            textColor: foreground,
            disabledTextColor: foreground.opacity(0.4),
            textFont: font,
            disabledTextFont: font
        )
    }
    
    static func outlined(tint: Color, font: Font = .body) -> Self {
        .init(
            backgroundColor: .clear,
            disabledBackgroundColor: .clear,
            loadingTintColor: tint,
            iconTintColor: tint,
            iconDisabledTintColor: tint.opacity(0.4),
            textColor: tint,
            disabledTextColor: tint.opacity(0.4),
            textFont: font,
            disabledTextFont: font
        )
    }
}

// MARK: - Appearance Definitions (Now just 2 parameters!)

extension GRButtonAppearanceModel {
    static let primary = .filled(background: .blue, foreground: .white)
    static let secondary = .outlined(tint: .blue)
}

extension GRToggleAppearance {
    static let `default` = GRToggleAppearance(
        tintColor: .blue,
        uncheckedBorderColor: .gray,
        checkedBackgroundColor: .blue.opacity(0.2),
        checkmarkImageTintColor: .white,
        checkmarkImage: Image(systemName: "checkmark")
    )
}
```

### Step 2: Initialize in Your App

```swift
@main
struct MyApp: App {
    init() {
        AppearanceConfig.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Step 3: Use Components

```swift
import SwiftUI
import GRButton
import GRInputField

struct ContentView: View {
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 20) {
            InputField(text: $email, title: "Email", placeholder: "email@example.com")
            
            Button("Submit") { }
                .buttonStyle(GRButtonStyle(appearance: .primary, size: .large(stretch: false)))
        }
        .padding()
    }
}
```

**Total setup time: Under 5 minutes** ✅

---

## Components

### GRButton

A highly customizable button component with support for icons, loading states, and various sizes.

#### SwiftUI Property Mapping

| SwiftUI Concept | GRButton Property |
|-----------------|-------------------|
| `.foregroundColor()` | `textColor` |
| `.background()` | `backgroundColor` |
| `.font()` | `textFont` |
| `.disabled(true)` | `disabledTextColor` / `disabledBackgroundColor` |
| Icon tint | `iconTintColor` |
| Loading indicator | `loadingTintColor` |

#### Basic Usage

```swift
import SwiftUI
import GRButton

Button("Click Me") {
    // Handle action
}
.buttonStyle(GRButtonStyle(appearance: .primary, size: .medium(stretch: false)))
```

#### Button Sizes

```swift
// Text buttons
.small(stretch: false)    // Height: ~36pt
.medium(stretch: false)   // Height: ~44pt
.large(stretch: false)    // Height: ~52pt

// Full-width buttons
.large(stretch: true)     // Takes full width

// Icon-only buttons (requires EmptyView label)
Button(action: {}) { EmptyView() }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        iconModel: .init(rightIcon: Image(systemName: "plus")),
        size: .circleSmall()     // 36x36pt
    ))

.circleMedium()           // 44x44pt
.square()                 // 44x44pt square
```

#### Button with Icons

```swift
// Left icon
Button("Continue") { }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        iconModel: .init(leftIcon: Image(systemName: "arrow.right")),
        size: .medium(stretch: false)
    ))

// Both icons
Button("Share") { }
    .buttonStyle(GRButtonStyle(
        appearance: .secondary,
        iconModel: .init(
            leftIcon: Image(systemName: "square.and.arrow.up"),
            rightIcon: Image(systemName: "chevron.right")
        ),
        size: .large(stretch: false)
    ))
```

#### Loading State

```swift
@State private var isLoading = false

Button("Submit") {
    isLoading.toggle()
}
.buttonStyle(GRButtonStyle(
    appearance: .primary,
    isLoading: isLoading,
    size: .medium(stretch: false)
))
```

#### Custom Appearance (Using Helper Functions)

```swift
// Instead of configuring 9 parameters, use helpers:
extension GRButtonAppearanceModel {
    static let custom = .filled(background: .green, foreground: .white)
    static let customOutlined = .outlined(tint: .green)
}
```

---

### GRInputField

Advanced input field component with validation, formatting, and rich customization options. Supports both SwiftUI and UIKit.

> **Important**: Call `InputFieldView.configureAppearance()` before using input fields.

#### SwiftUI Basic Usage

```swift
import SwiftUI
import GRInputField

struct MyView: View {
    @State private var text = ""
    
    init() {
        InputFieldView.configureAppearance()
    }
    
    var body: some View {
        InputField(
            text: $text,
            title: "Email",
            placeholder: "Enter your email",
            hint: "We'll never share your email"
        )
    }
}
```

#### Input Field with Validation

```swift
// Step 1: Define custom validation errors
enum RegistrationError: ValidationError {
    case invalidEmail
    case passwordTooShort
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 8 characters"
        }
    }
}

// Step 2: Apply validation
struct RegistrationView: View {
    @State private var email = ""
    @State private var validityGroup = ValidityGroup()
    
    var body: some View {
        InputField(
            text: $email,
            title: "Email",
            placeholder: "email@example.com"
        )
        .validationCriteria {
            Criterion.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                .failWith(error: RegistrationError.invalidEmail)
        }
        .validityGroup($validityGroup)
        
        Button("Validate All Fields") {
            validityGroup.validateAll()
            if validityGroup.allValid() {
                // Proceed
            }
        }
    }
}
```

#### Secure Input Field (Password)

```swift
@State private var password = ""

InputField(
    text: $password,
    title: "Password",
    hint: "At least 8 characters"
)
.inputFieldTraits(
    returnKeyType: .done,
    isSecureTextEntry: true
)
.setEyeButtonAccessibilityLabel(
    showLabel: "Show password",
    hideLabel: "Hide password"
)
```

#### Formatted Input Field

```swift
@State private var percent: Double = 0.5

InputField(
    value: $percent,
    format: .percent.precision(.fractionLength(0..<2)),
    title: "Discount (%)",
    placeholder: "0 %"
)
.inputFieldTraits(keyboardType: .numbersAndPunctuation)
```

#### Custom Left and Right Views

```swift
@State private var phoneNumber = ""

InputField(
    text: $phoneNumber,
    title: "Phone Number",
    placeholder: "123456789",
    leftView: {
        Text("+1")
            .foregroundColor(.gray)
            .padding(.leading, 8)
    },
    rightView: {
        Button {
            phoneNumber = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
    }
)
```

#### Advanced Validation with Multiple Criteria

```swift
@State private var password = ""
@State private var validityGroup = ValidityGroup()

InputField(
    text: $password,
    title: "Password",
    placeholder: "Enter password"
)
.validationCriteria {
    // Minimum length
    Criterion { $0?.count ?? 0 >= 8 }
        .failWith(error: RegistrationError.passwordTooShort)
        .realtime()
    
    // Must contain uppercase
    Criterion { $0?.range(of: "[A-Z]", options: .regularExpression) != nil }
        .failWith(error: RegistrationError.noUppercase)
        .realtime()
    
    // Must contain number
    Criterion { $0?.range(of: "[0-9]", options: .regularExpression) != nil }
        .failWith(error: RegistrationError.noNumber)
        .realtime()
}
.validityGroup($validityGroup)
```

#### Focus Management

```swift
enum FormFields: Int, CaseIterable, Hashable {
    case email, password, confirmPassword
}

@FocusState private var focusedField: FormFields?

InputField(text: $email, title: "Email")
    .bindFocusState($focusedField, to: .email)
    .inputFieldTraits(returnKeyType: .next)

InputField(text: $password, title: "Password")
    .bindFocusState($focusedField, to: .password)
    .inputFieldTraits(returnKeyType: .next)

InputField(text: $confirmPassword, title: "Confirm Password")
    .bindFocusState($focusedField, to: .confirmPassword)
    .inputFieldTraits(returnKeyType: .done)
```

#### Input Field Modifiers

```swift
InputField(text: $text, title: "Username")
    // Keyboard configuration
    .inputFieldTraits(
        textContentType: .username,
        keyboardType: .emailAddress,
        returnKeyType: .done,
        autocapitalizationType: .none,
        autocorrectionType: .no,
        clearButtonMode: .whileEditing,
        isSecureTextEntry: false,
        hapticsAllowed: true
    )
    
    // Input restrictions (regex)
    .allowedInput("^[a-zA-Z0-9_]{0,20}$")
    
    // Accessibility (5 methods available)
    .setAccessibilityLabel("Username input field")
    .setAccessibilityIdentifier("usernameTextField")
    .setAccessibilityHint("Enter your username")
    .setAccessibilityValue(text)
    
    // Validation
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)
    
    // Focus
    .bindFocusState($focusState, to: .username)
    
    // Actions
    .onSubmit { print("Submitted") }
    .onResign { print("Resigned") }
    .onEditingChanged { print("Changed") }
    
    // Custom appearance
    .inputFieldAppearance(.custom)
    
    // State
    .disabled(false)
```

#### Custom Input Field Appearance

```swift
extension InputFieldAppearance {
    static let custom = InputFieldAppearance(
        titleFont: .systemFont(ofSize: 14, weight: .medium),
        titleColor: .label,
        textFieldTintColor: .systemBlue,
        textFieldFont: .systemFont(ofSize: 16),
        hintFont: .systemFont(ofSize: 12),
        borderWidth: 1,
        cornerRadius: 8,
        height: 56,
        eyeImageHidden: UIImage(systemName: "eye.slash"),
        eyeImageVisible: UIImage(systemName: "eye"),
        enabled: .default,
        selected: InputFieldViewStateAppearance(
            borderColor: .systemBlue,
            contentBackgroundColor: .systemBackground
        ),
        disabled: .default,
        failed: InputFieldViewStateAppearance(
            borderColor: .systemRed,
            hintColor: .systemRed
        )
    )
}

// Usage
InputField(text: $text, title: "Custom")
    .inputFieldAppearance(.custom)
```

#### Validity Group Management

```swift
@State private var validityGroup = ValidityGroup()

var body: some View {
    VStack {
        // Your input fields with .validityGroup($validityGroup)
        
        // Check if all fields are valid
        if validityGroup.allValid() {
            Text("Form is valid ✓").foregroundColor(.green)
        }
        
        // Force validation on all fields
        Button("Submit") {
            validityGroup.validateAll()
            
            if validityGroup.allValid() {
                // Process form
                submitForm()
            }
        }
        
        // Clear validation messages
        Button("Clear Validation") {
            validityGroup.removeAll()
        }
    }
}
```

#### Accessibility Features

Input fields support comprehensive accessibility:

```swift
InputField(text: $username, title: "Username")
    // For screen readers
    .setAccessibilityLabel("Username input")
    
    // For UI testing
    .setAccessibilityIdentifier("usernameField")
    
    // Provide additional context
    .setAccessibilityHint("Enter your username between 3-20 characters")
    
    // Dynamic value for screen readers
    .setAccessibilityValue(username)
    
    // Secure field eye button labels
    .setEyeButtonAccessibilityLabel(
        showLabel: "Show password",
        hideLabel: "Hide password"
    )
```

---

### GRToggle

Custom toggle styles including switches, checkboxes, and radio buttons.

#### Switch Style

```swift
import SwiftUI
import GRToggle

@State private var isEnabled = false

// Standard sizes
Toggle(isOn: $isEnabled) {
    Text("Enable notifications")
}
.toggleStyle(GRSwitchStyle(appearance: .default, size: .default))

Toggle(isOn: $isEnabled) {
    Text("Small switch")
}
.toggleStyle(GRSwitchStyle(appearance: .default, size: .small))

Toggle(isOn: $isEnabled) {
    Text("Large switch")
}
.toggleStyle(GRSwitchStyle(appearance: .default, size: .large))
```

#### Toggle Alignment

**New Feature**: Control toggle position with `alignment` parameter

```swift
// Toggle on the right (default)
Toggle(isOn: $isEnabled) {
    Text("Enable notifications")
}
.toggleStyle(GRSwitchStyle(
    appearance: .default,
    size: .large,
    alignment: .trailing  // Toggle on right (default)
))

// Toggle on the left
Toggle(isOn: $isEnabled) {
    Text("Enable notifications")
}
.toggleStyle(GRSwitchStyle(
    appearance: .default,
    size: .large,
    alignment: .leading  // Toggle on left
))
```

#### Checkbox Style

```swift
@State private var isChecked = false

Toggle(isOn: $isChecked) {
    Text("I agree to terms and conditions")
}
.toggleStyle(GRToggleStyle(
    appearance: .default,
    style: .checkbox,
    size: .large,
    alignment: .trailing  // Optional alignment
))
```

#### Radio Button Style

```swift
@State private var selectedOption = false

Toggle(isOn: $selectedOption) {
    Text("Option A")
}
.toggleStyle(GRToggleStyle(
    appearance: .default,
    style: .radio,
    size: .large
))
```

#### Radio Button Group Pattern

```swift
enum PaymentMethod: String, CaseIterable {
    case card = "Credit Card"
    case paypal = "PayPal"
    case crypto = "Cryptocurrency"
}

@State private var selectedMethod: PaymentMethod = .card

VStack(alignment: .leading, spacing: 12) {
    ForEach(PaymentMethod.allCases, id: \.self) { method in
        Toggle(isOn: Binding(
            get: { selectedMethod == method },
            set: { if $0 { selectedMethod = method } }
        )) {
            Text(method.rawValue)
        }
        .toggleStyle(GRToggleStyle(
            appearance: .default,
            style: .radio,
            size: .large
        ))
    }
}
```

#### Circular Check Style

```swift
@State private var isSelected = false

Toggle(isOn: $isSelected) {
    Text("Select item")
}
.toggleStyle(GRToggleStyle(
    appearance: .default,
    style: .circularCheck,
    size: .large
))
```

#### Custom Toggle Appearance

```swift
extension GRToggleAppearance {
    static let custom = GRToggleAppearance(
        tintColor: .green,
        uncheckedBorderColor: .gray,
        checkedBackgroundColor: .green.opacity(0.2),
        checkmarkImageTintColor: .white,
        checkmarkImage: Image(systemName: "checkmark"),
        disabledOpacity: 0.3
    )
}

Toggle(isOn: $isChecked) {
    Text("Custom checkbox")
}
.toggleStyle(GRToggleStyle(
    appearance: .custom,
    style: .checkbox,
    size: .large
))
```

---

### GRAsyncImage

Asynchronous image loading component with built-in caching.

#### Basic Usage

```swift
import SwiftUI
import GRAsyncImage

GRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .frame(width: 200, height: 200)
    .cornerRadius(12)
```

#### With Custom Placeholders

```swift
GRAsyncImage(
    url: URL(string: "https://example.com/image.jpg"),
    loadingPlaceholder: {
        ZStack {
            Color.gray.opacity(0.2)
            ProgressView()
        }
    },
    failurePlaceholder: {
        ZStack {
            Color.gray.opacity(0.2)
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Text("Failed to load image")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
)
.frame(width: 300, height: 200)
.cornerRadius(12)
```

#### In a List

```swift
List(items) { item in
    HStack(spacing: 12) {
        GRAsyncImage(url: item.thumbnailURL)
            .frame(width: 60, height: 60)
            .cornerRadius(8)
        
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            Text(item.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
```

#### In a Grid

```swift
LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
    ForEach(images) { image in
        GRAsyncImage(url: image.url)
            .frame(width: 150, height: 150)
            .aspectRatio(contentMode: .fill)
            .clipped()
            .cornerRadius(12)
    }
}
```

---

### Readable Content Width

A modifier that constrains content to a readable width, particularly useful for iPad and larger screens.

#### Basic Usage

```swift
import SwiftUI
import GoodSwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            Text("This text will be constrained to a readable width")
            // More content...
        }
        .fittingReadableWidth()
    }
}
```

#### With Custom Alignment

```swift
VStack(alignment: .leading, spacing: 16) {
    Text("Left-aligned content")
        .font(.title)
    Text("Also left-aligned")
    Text("All within readable width")
}
.fittingReadableWidth(alignment: .leading)
```

#### Using FittingReadableWidth View

```swift
FittingReadableWidth(alignment: .center) {
    VStack(spacing: 20) {
        Text("Centered content")
        Text("Within readable width")
    }
}
```

#### Best Use Cases

```swift
ScrollView {
    VStack(spacing: 20) {
        // Long-form content benefits from readable width
        Text("Article Title")
            .font(.largeTitle)
            .bold()
        
        Text("""
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        Long paragraphs are easier to read when constrained to
        a reasonable width, especially on iPad and larger displays.
        """)
        .font(.body)
        
        Image("article-image")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
    .fittingReadableWidth()
}
```

---

## Helper Patterns

### Reducing Cognitive Load with Helper Functions

Instead of configuring 9 parameters for each button appearance, use helper functions:

```swift
// Add these helper functions once to your project
extension GRButtonAppearanceModel {
    /// Creates a filled button appearance (9 params → 2 params)
    static func filled(
        background: Color,
        foreground: Color,
        font: Font = .body.weight(.semibold)
    ) -> Self {
        .init(
            backgroundColor: background,
            disabledBackgroundColor: background.opacity(0.4),
            loadingTintColor: foreground,
            iconTintColor: foreground,
            iconDisabledTintColor: foreground.opacity(0.4),
            textColor: foreground,
            disabledTextColor: foreground.opacity(0.4),
            textFont: font,
            disabledTextFont: font
        )
    }
    
    /// Creates an outlined button appearance (9 params → 2 params)
    static func outlined(
        tint: Color,
        font: Font = .body
    ) -> Self {
        .init(
            backgroundColor: .clear,
            disabledBackgroundColor: .clear,
            loadingTintColor: tint,
            iconTintColor: tint,
            iconDisabledTintColor: tint.opacity(0.4),
            textColor: tint,
            disabledTextColor: tint.opacity(0.4),
            textFont: font,
            disabledTextFont: font
        )
    }
}

// Now defining appearances is simple!
extension GRButtonAppearanceModel {
    static let primary = .filled(background: .blue, foreground: .white)
    static let secondary = .outlined(tint: .blue)
    static let danger = .filled(background: .red, foreground: .white)
}
```

---

## Best Practices

### 1. Configure Appearance Early

For `GRInputField`, call `InputFieldView.configureAppearance()` early in your app lifecycle:

```swift
@main
struct MyApp: App {
    init() {
        InputFieldView.configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Create Reusable Appearance Extensions

Define your app's button, toggle, and input field appearances in a centralized file:

```swift
// AppearanceExtensions.swift
import GRButton
import GRToggle

// Use helper functions for simplicity
extension GRButtonAppearanceModel {
    static let primary = .filled(background: .accentColor, foreground: .white)
    static let secondary = .outlined(tint: .accentColor)
}

extension GRToggleAppearance {
    static let `default` = GRToggleAppearance(
        tintColor: .accentColor,
        uncheckedBorderColor: .gray,
        checkedBackgroundColor: .accentColor.opacity(0.2),
        checkmarkImageTintColor: .white,
        checkmarkImage: Image(systemName: "checkmark")
    )
}
```

### 3. Use Validity Groups for Forms

Group related input fields using `ValidityGroup` for coordinated validation:

```swift
@State private var validityGroup = ValidityGroup()

Form {
    InputField(text: $email, title: "Email")
        .validityGroup($validityGroup)
        .validationCriteria { /* ... */ }
    
    InputField(text: $password, title: "Password")
        .validityGroup($validityGroup)
        .validationCriteria { /* ... */ }
}

Button("Submit") {
    validityGroup.validateAll()
    if validityGroup.allValid() {
        submitForm()
    }
}
```

### 4. Leverage Focus State for Better UX

Use `@FocusState` with input fields for smooth keyboard navigation:

```swift
enum FormField: Int, CaseIterable, Hashable {
    case firstName, lastName, email
}

@FocusState private var focusedField: FormField?

// Each field
InputField(text: $firstName, title: "First Name")
    .bindFocusState($focusedField, to: .firstName)
    .inputFieldTraits(returnKeyType: .next)
```

### 5. Optimize Image Loading

For lists with many images, ensure frames are set to optimize caching:

```swift
LazyVStack {
    ForEach(items) { item in
        GRAsyncImage(url: item.imageURL)
            .frame(width: 300, height: 200) // Consistent sizing helps caching
            .cornerRadius(12)
    }
}
```

### 6. Use Modular Imports

Import only the components you need to reduce compilation time:

```swift
import GRButton      // Only buttons
import GRInputField  // Only input fields
// vs
import GoodSwiftUI   // All components
```

### 7. Accessibility First

Always set accessibility labels for better accessibility:

```swift
InputField(text: $username, title: "Username")
    .setAccessibilityLabel("Username input field")
    .setAccessibilityIdentifier("usernameField") // For UI tests
    .setAccessibilityHint("Enter your username")

Button("Submit") { }
    .buttonStyle(GRButtonStyle(appearance: .primary))
    .accessibilityLabel("Submit form")
```

### 8. Testing

Use accessibility identifiers for UI testing:

```swift
InputField(text: $text, title: "Email")
    .setAccessibilityIdentifier("emailTextField")

// In UI tests
let emailField = app.textFields["emailTextField"]
emailField.tap()
emailField.typeText("test@example.com")
```

### 9. When to Use This Library

**✅ Use GoodSwiftUI when:**
- Building a design system with consistent styling
- Need complex form validation
- Require custom button states (loading, disabled, icons)
- Want standardized UI components across a large codebase
- Building enterprise/team projects where consistency matters

**⚠️ Consider native SwiftUI when:**
- Building a simple MVP or prototype
- Need a one-off custom component
- Working on a small personal project
- Need the fastest possible implementation

---

## Additional Resources

- [GitHub Repository](https://github.com/GoodRequest/GoodSwiftUI)
- [Sample Project](https://github.com/GoodRequest/GoodSwiftUI/tree/main/GoodSwiftUI-Sample)
- [AI Usage Rules](AI_USAGE_RULES.md) - For AI assistants
- [Issue Tracker](https://github.com/GoodRequest/GoodSwiftUI/issues)

---

## License

GoodSwiftUI is released under the MIT license. See [LICENSE](LICENSE.md) for details.

