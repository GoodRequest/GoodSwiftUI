# GoodSwiftUI - AI Usage Rules

This document provides structured rules and patterns for AI assistants to help developers use the GoodSwiftUI library correctly.

## ⚡ Critical AI Directive: Development Speed First

**Primary Goal**: Make developers faster, not slower.

### Decision Tree (Follow this every time)

```
User wants UI component
    │
    ├─ Is it a single simple component?
    │   └─ YES → Suggest native SwiftUI
    │
    ├─ Does it need validation?
    │   ├─ NO → Suggest native SwiftUI
    │   └─ YES → Continue to next question
    │
    ├─ Is it part of a design system?
    │   ├─ NO → Suggest native SwiftUI (faster)
    │   └─ YES → Continue to next question
    │
    └─ Multiple related components or complex form?
        ├─ NO → Suggest native SwiftUI
        └─ YES → Suggest GoodSwiftUI (saves time overall)
```

### Golden Rules

1. **Default to native SwiftUI** - Only suggest GoodSwiftUI when it genuinely saves time
2. **Start minimal** - Use Level 1 (basic) patterns first, add complexity only if requested
3. **Copy-paste first** - Provide complete templates, not piece-by-piece instructions
4. **Time-aware** - Always mention estimated implementation time
5. **Trade-off transparent** - Explain why GoodSwiftUI is/isn't worth it for their use case
6. **Minimize cognitive load** - Provide minimal appearance configs, don't make users configure everything

### Example AI Responses

**✅ Good Response (Honest about trade-offs, minimal config):**
> "For a single login form, I'd actually recommend native SwiftUI TextField and Button with custom modifiers (2-3 minutes). GoodSwiftUI would add setup overhead.
> 
> However, if you're building multiple forms, here's a quick setup using helpers (under 5 min):
> ```swift
> extension GRButtonAppearanceModel {
>     static let primary = .filled(background: .blue, foreground: .white)
> }
> ```
> This reduces the typical 9 parameters down to 2, maps to SwiftUI concepts you know (background/foreground), and gives you consistent styling across forms."

**❌ Bad Response (Blindly suggesting library with too many parameters):**
> "Let's use GoodSwiftUI! First install the package, then configure appearance with backgroundColor, disabledBackgroundColor, loadingTintColor, iconTintColor, iconDisabledTintColor, textColor, disabledTextColor, textFont, disabledTextFont..." 
> 
> *(Problems: No trade-off consideration, cognitive overload with 9 parameters, no helpers, slower than native SwiftUI)*

## Library Overview

GoodSwiftUI is a Swift Package containing 5 modules for iOS 15+:
- `GoodSwiftUI` - Core utilities (ReadableContentWidth modifier)
- `GRButton` - Customizable button styles
- `GRInputField` - Advanced input fields with validation
- `GRToggle` - Custom toggle/switch/checkbox styles
- `GRAsyncImage` - Async image loading with caching

## When to Use This Library

### ✅ USE When:
- Building **design system** with consistent styling across app
- Need **complex form validation** with multiple criteria
- Require **custom button states** (loading, disabled, icons)
- Want **standardized UI components** across large codebase
- Building **enterprise/team projects** where consistency matters
- Need **accessibility** features built-in

### ⚠️ DON'T USE When:
- Building **simple MVP** or prototype (use native SwiftUI)
- Need **one-off custom button** (use native Button with modifiers)
- Have **simple text field** without validation (use native TextField)
- Working on **small personal project** (overhead not worth it)
- Need **quick implementation** (initial setup takes time)

### Rule: Guide users toward simplest solution first

Before suggesting GoodSwiftUI components, ask:
- "Is native SwiftUI sufficient here?"
- "Does this need validation/custom styling?"
- "Is this a one-time use or reusable component?"

If native SwiftUI works, suggest that first.

## Quick Start (Fastest Path)

**Goal: Get users productive in under 5 minutes**

### Step 1: Add Package (30 seconds)
Xcode → File → Add Packages → `https://github.com/GoodRequest/GoodSwiftUI`

### Step 2: Copy-Paste Appearance Setup (1 minute)

**SIMPLIFIED VERSION - Reduces cognitive load**

```swift
// AppearanceConfig.swift - Create this file once
import GRButton
import GRToggle
import GRInputField

struct AppearanceConfig {
    static func configure() {
        InputFieldView.configureAppearance()
    }
}

// Helper to reduce parameters (add once, reuse everywhere)
extension GRButtonAppearanceModel {
    static func filled(background: Color, foreground: Color) -> Self {
        .init(
            backgroundColor: background,
            disabledBackgroundColor: background.opacity(0.4),
            loadingTintColor: foreground,
            iconTintColor: foreground,
            iconDisabledTintColor: foreground.opacity(0.4),
            textColor: foreground,
            disabledTextColor: foreground.opacity(0.4),
            textFont: .body.weight(.semibold),
            disabledTextFont: .body.weight(.semibold)
        )
    }
}

// Now defining appearances is simple - just 2 parameters!
extension GRButtonAppearanceModel {
    static let primary = .filled(background: .blue, foreground: .white)
    static let secondary = .filled(background: .gray, foreground: .blue)
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

### Step 3: Initialize in App (30 seconds)

```swift
@main
struct MyApp: App {
    init() { AppearanceConfig.configure() }
    var body: some Scene { WindowGroup { ContentView() } }
}
```

### Step 4: Use Components (3 minutes)

```swift
import SwiftUI
import GRButton
import GRInputField

struct ContentView: View {
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Input field - just bind and add title
            InputField(text: $email, title: "Email", placeholder: "email@example.com")
            
            // Button - apply style
            Button("Submit") { }
                .buttonStyle(GRButtonStyle(appearance: .primary, size: .large(stretch: false)))
        }
        .padding()
    }
}
```

**Total time: Under 5 minutes to working UI**

---

## Progressive Adoption Strategy

### Rule: Start simple, add complexity only when needed

#### Level 1: Basic Components (No validation, no custom logic)
```swift
// Just styling, no validation
InputField(text: $name, title: "Name")
Button("Save") { save() }
    .buttonStyle(GRButtonStyle(appearance: .primary, size: .medium(stretch: false)))
```
**When**: MVP, prototypes, simple screens  
**Time**: 30 seconds per component

#### Level 2: Add Validation (When you need it)
```swift
enum FormError: ValidationError {
    case empty
    var errorDescription: String? { "Required field" }
}

InputField(text: $name, title: "Name")
    .validationCriteria {
        Criterion.nonEmpty.failWith(error: FormError.empty)
    }
```
**When**: Forms with requirements  
**Time**: +2 minutes for validation setup

#### Level 3: Full Form (Multiple fields with coordination)
```swift
@State private var validityGroup = ValidityGroup()

InputField(text: $email, title: "Email")
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)

Button("Submit") {
    validityGroup.validateAll()
    if validityGroup.allValid() { submit() }
}
```
**When**: Complex forms, registration flows  
**Time**: +5 minutes for full setup

### Rule: Suggest appropriate level based on user needs

- User says "simple form" → Level 1
- User says "validate email" → Level 2  
- User says "registration with multiple fields" → Level 3

---

## Installation Pattern

### Rule: Always use SPM (Swift Package Manager)

**Correct Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/GoodRequest/GoodSwiftUI", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "GoodSwiftUI", package: "GoodSwiftUI"),
            // OR import specific modules:
            .product(name: "GRButton", package: "GoodSwiftUI"),
            .product(name: "GRInputField", package: "GoodSwiftUI"),
            .product(name: "GRToggle", package: "GoodSwiftUI"),
            .product(name: "GRAsyncImage", package: "GoodSwiftUI"),
        ]
    )
]
```

## Reducing Cognitive Load (Critical)

### Problem: Too Many Parameters

**User Feedback**: *"When I know SwiftUI, I have to think about which appearance properties map to native SwiftUI properties. Too many customizable parameters."*

### Solution: Minimal Configuration Pattern

**Rule: Provide minimal appearance configs with sensible defaults**

#### ❌ DON'T: Give users all parameters to configure
```swift
// Too much cognitive load - 9 parameters!
extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: .blue,
        disabledBackgroundColor: .blue.opacity(0.4),
        loadingTintColor: .white,
        iconTintColor: .white,
        iconDisabledTintColor: .white.opacity(0.4),
        textColor: .white,
        disabledTextColor: .white.opacity(0.4),
        textFont: .systemFont(ofSize: 17, weight: .semibold),
        disabledTextFont: .systemFont(ofSize: 17, weight: .semibold)
    )
}
```

#### ✅ DO: Start with minimal config, show how to customize only what's needed
```swift
// Minimal - just the essentials (3 parameters)
extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: .blue,
        textColor: .white,
        textFont: .body
    )
}

// User can add more ONLY if needed:
// - Add disabledBackgroundColor only if default doesn't work
// - Add custom fonts only if needed
// - etc.
```

### Pre-built Appearance Presets (Copy-Paste Ready)

**Rule: Give users ready-made presets, not empty templates**

#### Preset 1: iOS Native Style (Fastest - 10 seconds)
```swift
import GRButton
import GRToggle

extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: .blue,
        disabledBackgroundColor: .gray,
        loadingTintColor: .white,
        iconTintColor: .white,
        iconDisabledTintColor: .white.opacity(0.5),
        textColor: .white,
        disabledTextColor: .white.opacity(0.5),
        textFont: .body.weight(.semibold),
        disabledTextFont: .body.weight(.semibold)
    )
    
    static let secondary = GRButtonAppearanceModel(
        backgroundColor: .clear,
        disabledBackgroundColor: .clear,
        loadingTintColor: .blue,
        iconTintColor: .blue,
        iconDisabledTintColor: .gray,
        textColor: .blue,
        disabledTextColor: .gray,
        textFont: .body,
        disabledTextFont: .body
    )
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

#### Preset 2: Material Design Style
```swift
import GRButton

extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: Color(red: 0.38, green: 0.49, blue: 0.95),  // Material Blue
        disabledBackgroundColor: Color.gray.opacity(0.3),
        loadingTintColor: .white,
        iconTintColor: .white,
        iconDisabledTintColor: .white.opacity(0.5),
        textColor: .white,
        disabledTextColor: .white.opacity(0.5),
        textFont: .system(size: 14, weight: .medium).uppercaseSmallCaps(),
        disabledTextFont: .system(size: 14, weight: .medium).uppercaseSmallCaps()
    )
}
```

#### Preset 3: Minimal/Modern Style
```swift
import GRButton

extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: .black,
        disabledBackgroundColor: .gray.opacity(0.3),
        loadingTintColor: .white,
        iconTintColor: .white,
        iconDisabledTintColor: .gray,
        textColor: .white,
        disabledTextColor: .gray,
        textFont: .system(size: 16, weight: .regular),
        disabledTextFont: .system(size: 16, weight: .regular)
    )
}
```

### Progressive Customization Pattern

**Rule: Start simple, customize only what user needs**

```swift
// Step 1: Start with preset (10 seconds)
extension GRButtonAppearanceModel {
    static let primary = .iosNative  // Use preset
}

// Step 2: Customize ONLY what's needed (if required)
extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: .myBrandColor,      // ← Only change this
        textColor: .white,                    // ← And this
        textFont: .body                       // ← Keep simple
        // Let other properties use sensible defaults
    )
}
```

### Appearance Configuration Helper

**Rule: Provide this helper for common cases**

```swift
// One-liner appearance creator
extension GRButtonAppearanceModel {
    static func filled(
        background: Color,
        foreground: Color,
        font: Font = .body.weight(.semibold)
    ) -> GRButtonAppearanceModel {
        GRButtonAppearanceModel(
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
    
    static func outlined(
        tint: Color,
        font: Font = .body
    ) -> GRButtonAppearanceModel {
        GRButtonAppearanceModel(
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

// Usage: Simple and intuitive
extension GRButtonAppearanceModel {
    static let primary = .filled(background: .blue, foreground: .white)
    static let secondary = .outlined(tint: .blue)
}
```

### SwiftUI Properties Mapping Guide

**Rule: When user asks "how do I do X in SwiftUI?", show the mapping**

| SwiftUI Concept | GRButton Property | Notes |
|-----------------|-------------------|-------|
| `.foregroundColor()` | `textColor` | Text color |
| `.background()` | `backgroundColor` | Button background |
| `.font()` | `textFont` | Text font |
| `.disabled(true)` | `disabledTextColor` | Auto-applied when disabled |
| Icon tint | `iconTintColor` | For SF Symbols |
| Loading indicator | `loadingTintColor` | When `isLoading: true` |

**Example mapping:**
```swift
// Native SwiftUI (what user knows)
Button("Click") { }
    .foregroundColor(.white)
    .background(.blue)
    .font(.body.weight(.semibold))

// GoodSwiftUI equivalent
Button("Click") { }
    .buttonStyle(GRButtonStyle(
        appearance: .init(
            backgroundColor: .blue,      // ← .background()
            textColor: .white,           // ← .foregroundColor()
            textFont: .body.weight(.semibold)  // ← .font()
        ),
        size: .medium(stretch: false)
    ))
```

---

## Component 1: GRButton

### API Structure
```swift
.buttonStyle(GRButtonStyle(
    appearance: GRButtonAppearanceModel,  // Required: visual styling
    iconModel: GRButtonIconModel?,         // Optional: left/right icons
    isLoading: Bool = false,               // Optional: loading state
    size: GRButtonStyleSize                // Required: size configuration
))
```

### Rule: Use helper functions to reduce parameters

**Don't make users configure 9 parameters. Use helpers:**

```swift
import GRButton

// Step 1: Add helpers (do this once)
extension GRButtonAppearanceModel {
    static func filled(background: Color, foreground: Color) -> Self {
        .init(
            backgroundColor: background,
            disabledBackgroundColor: background.opacity(0.4),
            loadingTintColor: foreground,
            iconTintColor: foreground,
            iconDisabledTintColor: foreground.opacity(0.4),
            textColor: foreground,
            disabledTextColor: foreground.opacity(0.4),
            textFont: .body.weight(.semibold),
            disabledTextFont: .body.weight(.semibold)
        )
    }
}

// Step 2: Define appearances (simple now!)
extension GRButtonAppearanceModel {
    static let primary = .filled(background: .blue, foreground: .white)
    static let secondary = .filled(background: .green, foreground: .white)
}

// Step 3: Use in views
Button("Text") { action }
    .buttonStyle(GRButtonStyle(appearance: .primary, size: .medium(stretch: false)))
```

### Button Size Options

```swift
// Text buttons (stretch parameter controls full width)
.small(stretch: Bool)    // Height: ~36pt
.medium(stretch: Bool)   // Height: ~44pt
.large(stretch: Bool)    // Height: ~52pt

// Icon-only buttons
.circleSmall()           // 36x36pt circle
.circleMedium()          // 44x44pt circle
.square()                // 44x44pt square
```

### Rule: Icon-only buttons require empty label

**Correct:**
```swift
Button(action: {}) { EmptyView() }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        iconModel: .init(rightIcon: Image(systemName: "plus")),
        size: .circleSmall()
    ))
```

**Incorrect:**
```swift
Button("Text") { }  // ❌ Don't use text with icon-only sizes
    .buttonStyle(GRButtonStyle(..., size: .circleSmall()))
```

### Complete Button Examples

```swift
// Basic text button
Button("Continue") { }
    .buttonStyle(GRButtonStyle(appearance: .primary, size: .medium(stretch: false)))

// Button with left icon
Button("Continue") { }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        iconModel: .init(leftIcon: Image(systemName: "arrow.right")),
        size: .medium(stretch: false)
    ))

// Button with both icons
Button("Share") { }
    .buttonStyle(GRButtonStyle(
        appearance: .secondary,
        iconModel: .init(
            leftIcon: Image(systemName: "square.and.arrow.up"),
            rightIcon: Image(systemName: "chevron.right")
        ),
        size: .large(stretch: false)
    ))

// Loading button
@State private var isLoading = false

Button("Submit") { isLoading.toggle() }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        isLoading: isLoading,
        size: .medium(stretch: false)
    ))

// Icon-only circle button
Button(action: {}) { EmptyView() }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        iconModel: .init(rightIcon: Image(systemName: "plus")),
        size: .circleMedium()
    ))
```

---

## Component 2: GRInputField

### Critical Setup Rule

**ALWAYS call `InputFieldView.configureAppearance()` before using input fields.**

```swift
// Option 1: In App struct
import GRInputField

@main
struct MyApp: App {
    init() {
        InputFieldView.configureAppearance()  // ✓ Required
    }
    var body: some Scene { WindowGroup { ContentView() } }
}

// Option 2: In View init
struct MyView: View {
    init() {
        InputFieldView.configureAppearance()  // ✓ Required
    }
    var body: some View { /* ... */ }
}
```

### Input Field API Patterns

#### Pattern 1: Simple Text Field
```swift
import GRInputField

@State private var text = ""

InputField(
    text: Binding<String>,           // Text binding
    title: String,                   // Label above field
    placeholder: String?,            // Placeholder text
    hint: String?                    // Helper text below
)
```

#### Pattern 2: Formatted Value Field
```swift
import GRInputField

@State private var value: Double = 0

InputField(
    value: Binding<Value>,           // Value binding
    format: FormatStyle,             // Format style (e.g., .percent)
    title: String,
    placeholder: String?,
    hint: String?
)
```

#### Pattern 3: Field with Custom Views
```swift
import GRInputField

InputField(
    text: Binding<String>,
    title: String,
    placeholder: String?,
    hint: String?,
    leftView: () -> LeftView,        // Optional left view
    rightView: () -> RightView       // Optional right view
)
```

### Validation System

#### Rule: Define ValidationError enum first

```swift
// Step 1: Define errors
enum FormError: ValidationError {
    case empty
    case tooShort
    case invalidFormat
    
    var errorDescription: String? {  // Required protocol method
        switch self {
        case .empty: return "This field is required"
        case .tooShort: return "Must be at least 6 characters"
        case .invalidFormat: return "Invalid format"
        }
    }
}

// Step 2: Apply validation
InputField(text: $email, title: "Email")
    .validationCriteria {
        Criterion.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
            .failWith(error: FormError.invalidFormat)
    }
```

#### Validation Criterion Patterns

```swift
// Predefined criteria
Criterion.nonEmpty                   // Field not empty
Criterion.matches("regex")           // Regex match

// Custom criteria
Criterion { value in
    value?.count ?? 0 >= 6          // Custom validation logic
}
.failWith(error: FormError.tooShort)
.realtime()                         // Validate on every change (optional)

// Multiple criteria
.validationCriteria {
    Criterion { $0?.count ?? 0 >= 8 }
        .failWith(error: FormError.tooShort)
        .realtime()
    
    Criterion { $0?.range(of: "[A-Z]", options: .regularExpression) != nil }
        .failWith(error: FormError.noUppercase)
        .realtime()
}
```

### Validity Group Pattern

**Rule: Use ValidityGroup for multi-field forms**

```swift
// Step 1: Create validity group state
@State private var validityGroup = ValidityGroup()

// Step 2: Attach to all fields
InputField(text: $field1, title: "Field 1")
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)

InputField(text: $field2, title: "Field 2")
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)

// Step 3: Use group methods
Button("Submit") {
    validityGroup.validateAll()      // Force show all validation errors
    if validityGroup.allValid() {    // Check if all fields valid
        submitForm()
    }
}

Button("Clear") {
    validityGroup.removeAll()        // Clear all validation messages
}
```

### Focus Management Pattern

```swift
// Step 1: Define focus enum
enum FormFields: Int, CaseIterable, Hashable {
    case email, password, confirm
}

// Step 2: Create focus state
@FocusState private var focusedField: FormFields?

// Step 3: Bind to fields
InputField(text: $email, title: "Email")
    .inputFieldTraits(returnKeyType: .next)
    .bindFocusState($focusedField, to: .email)

InputField(text: $password, title: "Password")
    .inputFieldTraits(returnKeyType: .next)
    .bindFocusState($focusedField, to: .password)

InputField(text: $confirm, title: "Confirm")
    .inputFieldTraits(returnKeyType: .done)
    .bindFocusState($focusedField, to: .confirm)
```

### Input Field Modifiers Reference

#### Input Field Traits modifier - available traits

```swift
extension InputField {

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
    ) -> Self { ... }

}
```

#### Examples

```swift
InputField(text: $text, title: "Username")
    // Keyboard configuration
    .inputFieldTraits(
        autocapitalizationType: .none,
        keyboardType: .emailAddress,
        returnKeyType: .done,
        isSecureTextEntry: false
    )
    
    // Input restrictions (regex)
    .allowedInput("^[a-zA-Z0-9]{0,20}$")
    
    // Accessibility
    .setAccessibilityLabel("Username input")
    .setAccessibilityIdentifier("usernameField")
    .setEyeButtonAccessibilityLabel(showLabel: "Show", hideLabel: "Hide")
    
    // Validation
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)
    
    // Actions
    .onSubmit { print("Submitted") }
    .onResign { print("Resigned") }
    .onEditingChanged { print("Changed") }

    // Focus - must be last, because it will erase InputField to some View
    .bindFocusState($focusState, to: .username)
    
    // State
    .disabled(false)
```

### Secure Input Field (Password) Pattern

```swift
@State private var password = ""

InputField(text: $password, title: "Password")
    .inputFieldTraits(
        keyboardType: .default,
        isSecureTextEntry: true         // Enables eye button
    )
    .setEyeButtonAccessibilityLabel(
        showLabel: "Show password",
        hideLabel: "Hide password"
    )
```

### Formatted Input Examples

```swift
// Percentage
@State private var percent: Double = 0.5
InputField(
    value: $percent,
    format: .percent.precision(.fractionLength(0..<2)),
    title: "Discount (%)"
)
.inputFieldTraits(keyboardType: .numbersAndPunctuation)

// Currency
@State private var amount: Decimal = 0
InputField(
    value: $amount,
    format: .currency(code: "USD"),
    title: "Amount"
)
.inputFieldTraits(keyboardType: .decimalPad)

// Custom format style
struct PinCodeFormatStyle: ParseableFormatStyle {
    typealias Strategy = PinCodeParseStrategy
    typealias FormatInput = String
    typealias FormatOutput = String
    
    func format(_ value: String) -> String {
        // Add spaces every 3 chars: "123 456"
        let stride = value.count <= 6 ? 3 : 4
        return String(value.enumerated().map {
            $0 > 0 && $0 % stride == 0 ? [" ", $1] : [$1]
        }.joined())
    }
    
    var parseStrategy: PinCodeParseStrategy { PinCodeParseStrategy() }
}

struct PinCodeParseStrategy: ParseStrategy {
    typealias ParseInput = String
    typealias ParseOutput = String
    
    func parse(_ value: String) throws -> String {
        value.replacingOccurrences(of: " ", with: "")
    }
}

@State private var pin = ""
InputField(value: $pin, format: PinCodeFormatStyle(), title: "PIN")
```

### Custom Left/Right Views Pattern

```swift
@State private var phoneNumber = ""
@State private var showPassword = false

// Left view example (prefix)
InputField(
    text: $phoneNumber,
    title: "Phone",
    placeholder: "123456789",
    leftView: {
        Text("+1")
            .foregroundColor(.gray)
            .padding(.leading, 8)
    }
)

// Right view example (clear button)
InputField(
    text: $text,
    title: "Search",
    rightView: {
        Button {
            text = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
    }
)
```

### Complete Input Field Examples

```swift
// Email field with validation
@State private var email = ""
@State private var validityGroup = ValidityGroup()

enum ValidationErrors: ValidationError {
    case invalidEmail
    var errorDescription: String? { "Invalid email address" }
}

InputField(
    text: $email,
    title: "Email",
    placeholder: "email@example.com",
    hint: "We'll never share your email"
)
.inputFieldTraits(
    autocapitalizationType: .none,
    keyboardType: .emailAddress,
    returnKeyType: .next
)
.validationCriteria {
    Criterion.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        .failWith(error: ValidationErrors.invalidEmail)
}
.validityGroup($validityGroup)
.setAccessibilityLabel("Email input")
.setAccessibilityIdentifier("emailField")

// Password field with multiple validations
@State private var password = ""

InputField(text: $password, title: "Password", hint: "At least 8 characters with uppercase")
    .inputFieldTraits(isSecureTextEntry: true)
    .validationCriteria {
        Criterion { $0?.count ?? 0 >= 8 }
            .failWith(error: ValidationErrors.tooShort)
            .realtime()
        
        Criterion { $0?.range(of: "[A-Z]", options: .regularExpression) != nil }
            .failWith(error: ValidationErrors.noUppercase)
            .realtime()
    }
    .validityGroup($validityGroup)
```

---

## Component 3: GRToggle

### API Structure

```swift
.toggleStyle(GRSwitchStyle(
    appearance: GRSwitchAppearance,
    size: GRSwitchSize              // .small or .large
))

.toggleStyle(GRToggleStyle(
    appearance: GRToggleAppearance,
    style: GRToggleVariant,         // .checkbox, .radio, .circularCheck
    size: GRToggleSize,             // .small or .large
    alignment: GRAlignment          // .leading or .trailing (position of the box/circle to the text)
))
```

### Rule: Define appearance extensions first

```swift
import GRToggle

// Switch appearance
extension GRSwitchAppearance {
    static let primary: GRSwitchAppearance = .init(
        activeBackgroundColor: Color,           // On state background
        inactiveBackgroundColor: Color,         // Off state background
        thumbColor: Color,                      // Toggle thumb color
        disabledActiveBackgroundColor: Color,   // Disabled on state
        disabledInactiveBackgroundColor: Color, // Disabled off state
        disabledThumbColor: Color               // Disabled thumb
    )
}

// Toggle appearance (checkbox/radio)
extension GRToggleAppearance {
    static let primary: GRToggleAppearance = .init(
        tintColor: Color,                       // Active/selected color
        uncheckedBorderColor: Color,            // Border when unchecked
        checkedBackgroundColor: Color,          // Background when checked
        checkmarkImageTintColor: Color,         // Checkmark color
        checkmarkImage: Image                   // Checkmark icon
    )
}
```

### Toggle Examples

```swift
@State private var isOn = false

// Switch (iOS-style toggle)
Toggle(isOn: $isOn) {
    Text("Enable notifications")
}
.toggleStyle(GRSwitchStyle(appearance: .primary, size: .large))

// Checkbox
Toggle(isOn: $isOn) {
    Text("I agree to terms and conditions")
}
.toggleStyle(GRToggleStyle(
    appearance: .primary,
    style: .checkbox,
    size: .large,
    alignment: .leading
))

// Radio button
Toggle(isOn: $isOn) {
    Text("Option A")
}
.toggleStyle(GRToggleStyle(
    appearance: .primary,
    style: .radio,
    size: .small
))

// Circular check
Toggle(isOn: $isOn) {
    Text("Select item")
}
.toggleStyle(GRToggleStyle(
    appearance: .primary,
    style: .circularCheck,
    size: .large
))

// Disabled state
Toggle(isOn: $isOn) {
    Text("Disabled option")
}
.toggleStyle(GRToggleStyle(appearance: .primary, style: .checkbox, size: .small))
.disabled(true)
```

### Radio Button Group Pattern

```swift
// Rule: Use enum for radio group state
enum PaymentMethod: String, CaseIterable {
    case card = "Credit Card"
    case paypal = "PayPal"
    case crypto = "Cryptocurrency"
}

@State private var selectedMethod: PaymentMethod = .card

VStack(alignment: .leading) {
    ForEach(PaymentMethod.allCases, id: \.self) { method in
        Toggle(isOn: Binding(
            get: { selectedMethod == method },
            set: { if $0 { selectedMethod = method } }
        )) {
            Text(method.rawValue)
        }
        .toggleStyle(GRToggleStyle(
            appearance: .primary,
            style: .radio,
            size: .large
        ))
    }
}
```

---

## Component 4: GRAsyncImage

### API Structure

```swift
GRAsyncImage(
    url: URL?,                                // Image URL
    loadingPlaceholder: (() -> View)? = nil,  // Loading view
    failurePlaceholder: (() -> View)? = nil   // Error view
)
```

### Usage Patterns

```swift
import GRAsyncImage

// Basic usage
GRAsyncImage(url: URL(string: "https://example.com/image.jpg"))
    .frame(width: 200, height: 200)

// With loading indicator
GRAsyncImage(
    url: imageURL,
    loadingPlaceholder: {
        ProgressView()
    }
)
.frame(width: 200, height: 200)

// With failure placeholder
GRAsyncImage(
    url: imageURL,
    failurePlaceholder: {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.red)
            Text("Failed to load")
                .font(.caption)
        }
    }
)
.frame(width: 200, height: 200)

// Complete example with both
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
                Image(systemName: "photo")
                    .font(.largeTitle)
                Text("Image unavailable")
                    .font(.caption)
            }
            .foregroundColor(.gray)
        }
    }
)
.frame(width: 300, height: 200)
.cornerRadius(12)
.clipped()
```

### List Pattern

**Rule: Always set consistent frame sizes for optimal caching**

```swift
List(items) { item in
    HStack(spacing: 12) {
        GRAsyncImage(url: item.thumbnailURL)
            .frame(width: 60, height: 60)  // ✓ Consistent sizing
            .cornerRadius(8)
            .clipped()
        
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            Text(item.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Grid pattern
LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
    ForEach(images) { image in
        GRAsyncImage(url: image.url)
            .frame(width: 150, height: 150)  // ✓ Consistent sizing
            .cornerRadius(12)
            .clipped()
    }
}
```

---

## Component 5: Readable Content Width

### API

```swift
// Modifier
.fittingReadableWidth(alignment: Alignment = .center)

// View wrapper
FittingReadableWidth(alignment: Alignment = .center) {
    content
}
```

### Usage Pattern

**Rule: Use for long-form content on iPad/large screens**

```swift
import GoodSwiftUI

// Article/blog post pattern
ScrollView {
    VStack(alignment: .leading, spacing: 20) {
        Text("Article Title")
            .font(.largeTitle)
        
        Text("""
        Long form content that benefits from readable width constraints.
        This ensures text doesn't span the full width on iPad.
        """)
        .font(.body)
        
        Image("article-image")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    .padding()
    .fittingReadableWidth(alignment: .leading)
}

// Form pattern
Form {
    Section {
        InputField(text: $name, title: "Name")
        InputField(text: $email, title: "Email")
    }
}
.fittingReadableWidth()

// Using view wrapper
FittingReadableWidth(alignment: .center) {
    VStack {
        Text("Centered content")
        Text("Within readable bounds")
    }
}
```

---

## Common Patterns & Best Practices

### Pattern: Complete Form with All Components

```swift
import SwiftUI
import GRButton
import GRInputField
import GRToggle

struct RegistrationForm: View {
    // MARK: - State
    @State private var email = ""
    @State private var password = ""
    @State private var agreeToTerms = false
    @State private var validityGroup = ValidityGroup()
    @State private var isSubmitting = false
    @FocusState private var focusedField: FormField?
    
    enum FormField: Int, CaseIterable, Hashable {
        case email, password
    }
    
    enum FormError: ValidationError {
        case invalidEmail, passwordTooShort, mustAgreeToTerms
        
        var errorDescription: String? {
            switch self {
            case .invalidEmail: return "Please enter a valid email"
            case .passwordTooShort: return "Password must be at least 8 characters"
            case .mustAgreeToTerms: return "You must agree to the terms"
            }
        }
    }
    
    // MARK: - Init
    init() {
        InputFieldView.configureAppearance()
    }
    
    // MARK: - Body
    var body: some View {
        Form {
            Section {
                InputField(
                    text: $email,
                    title: "Email",
                    placeholder: "email@example.com"
                )
                .inputFieldTraits(
                    autocapitalizationType: .none,
                    keyboardType: .emailAddress,
                    returnKeyType: .next,
                )
                .validationCriteria {
                    Criterion.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                        .failWith(error: FormError.invalidEmail)
                }
                .validityGroup($validityGroup)
                .bindFocusState($focusedField, to: .email)
                
                InputField(
                    text: $password,
                    title: "Password",
                    hint: "At least 8 characters"
                )
                .inputFieldTraits(
                    returnKeyType: .done,
                    isSecureTextEntry: true
                )
                .validationCriteria {
                    Criterion { $0?.count ?? 0 >= 8 }
                        .failWith(error: FormError.passwordTooShort)
                }
                .validityGroup($validityGroup)
                .bindFocusState($focusedField, to: .password)
            }
            
            Section {
                Toggle(isOn: $agreeToTerms) {
                    Text("I agree to the terms and conditions")
                }
                .toggleStyle(GRToggleStyle(
                    appearance: .default,
                    style: .checkbox,
                    size: .large
                ))
            }
            
            Section {
                Button("Create Account") {
                    submitForm()
                }
                .buttonStyle(GRButtonStyle(
                    appearance: .primary,
                    isLoading: isSubmitting,
                    size: .large(stretch: true)
                ))
                .disabled(!canSubmit)
            }
        }
    }
    
    // MARK: - Methods
    private var canSubmit: Bool {
        !email.isEmpty && !password.isEmpty && agreeToTerms && !isSubmitting
    }
    
    private func submitForm() {
        validityGroup.validateAll()
        
        guard validityGroup.allValid() && agreeToTerms else {
            return
        }
        
        isSubmitting = true
        // Perform submission...
    }
}

// MARK: - Appearance Configuration
extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(
        backgroundColor: .blue,
        disabledBackgroundColor: .blue.opacity(0.4),
        loadingTintColor: .white,
        iconTintColor: .white,
        iconDisabledTintColor: .white.opacity(0.4),
        textColor: .white,
        disabledTextColor: .white.opacity(0.4),
        textFont: .systemFont(ofSize: 17, weight: .semibold),
        disabledTextFont: .systemFont(ofSize: 17, weight: .semibold)
    )
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

### Rule: Import Order

```swift
// System frameworks first
import SwiftUI
import UIKit

// GoodSwiftUI components
import GoodSwiftUI      // Core utilities
import GRButton         // If using buttons
import GRInputField     // If using input fields
import GRToggle         // If using toggles
import GRAsyncImage     // If using async images
```

### Rule: Appearance Configuration Checklist

```swift
// ✓ DO: Configure in App init
@main
struct MyApp: App {
    init() {
        InputFieldView.configureAppearance()
        configureAppearances()
    }
    
    var body: some Scene {
        WindowGroup { ContentView() }
    }
    
    private func configureAppearances() {
        // Configure all appearance extensions here
    }
}

// ✓ DO: Create appearance extensions file
// File: Appearance+Extensions.swift
import GRButton
import GRToggle

extension GRButtonAppearanceModel {
    static let primary = /* ... */
    static let secondary = /* ... */
}

extension GRSwitchAppearance {
    static let `default` = /* ... */
}

extension GRToggleAppearance {
    static let `default` = /* ... */
}
```

### Rule: Accessibility Checklist

```swift
// Always provide accessibility support

// Buttons
Button("Submit") { }
    .buttonStyle(GRButtonStyle(appearance: .primary))
    .accessibilityLabel("Submit form")
    .accessibilityHint("Double tap to submit the registration form")

// Input Fields
InputField(text: $username, title: "Username")
    .setAccessibilityLabel("Username input field")
    .setAccessibilityIdentifier("usernameTextField")  // For UI tests

// Secure Fields
InputField(text: $password, title: "Password")
    .inputFieldTraits(isSecureTextEntry: true)
    .setEyeButtonAccessibilityLabel(
        showLabel: "Show password",
        hideLabel: "Hide password"
    )

// Toggles
Toggle(isOn: $isEnabled) {
    Text("Enable notifications")
        .accessibilityLabel("Enable push notifications")
}
.toggleStyle(GRToggleStyle(...))
```

### Rule: Error Handling Pattern

```swift
// Always define ValidationError enums with descriptive messages

enum FormValidationError: ValidationError {
    // Cases
    case emptyField(fieldName: String)
    case invalidFormat(fieldName: String, expected: String)
    case tooShort(fieldName: String, minimum: Int)
    case tooLong(fieldName: String, maximum: Int)
    
    // Required protocol conformance
    var errorDescription: String? {
        switch self {
        case .emptyField(let name):
            return "\(name) is required"
        case .invalidFormat(let name, let expected):
            return "\(name) must be in \(expected) format"
        case .tooShort(let name, let min):
            return "\(name) must be at least \(min) characters"
        case .tooLong(let name, let max):
            return "\(name) must be no more than \(max) characters"
        }
    }
}

// Usage
InputField(text: $email, title: "Email")
    .validationCriteria {
        Criterion.nonEmpty
            .failWith(error: FormValidationError.emptyField(fieldName: "Email"))
        
        Criterion.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
            .failWith(error: FormValidationError.invalidFormat(
                fieldName: "Email",
                expected: "email@example.com"
            ))
    }
```

---

## Quick Reference: Common Mistakes to Avoid

### ❌ DON'T: Forget InputFieldView configuration
```swift
// ❌ This will cause issues
struct MyView: View {
    var body: some View {
        InputField(text: $text, title: "Name")  // Will not work correctly
    }
}
```

### ✓ DO: Configure before use
```swift
// ✓ Correct
init() {
    InputFieldView.configureAppearance()
}
```

### ❌ DON'T: Use text with icon-only button sizes
```swift
// ❌ Wrong
Button("Text") { }
    .buttonStyle(GRButtonStyle(appearance: .primary, size: .circleSmall()))
```

### ✓ DO: Use EmptyView for icon-only buttons
```swift
// ✓ Correct
Button(action: {}) { EmptyView() }
    .buttonStyle(GRButtonStyle(
        appearance: .primary,
        iconModel: .init(rightIcon: Image(systemName: "plus")),
        size: .circleSmall()
    ))
```

### ❌ DON'T: Forget to define appearance models
```swift
// ❌ Wrong - .primary doesn't exist by default
.buttonStyle(GRButtonStyle(appearance: .primary))
```

### ✓ DO: Define appearance extensions first
```swift
// ✓ Correct
extension GRButtonAppearanceModel {
    static let primary = GRButtonAppearanceModel(/* ... */)
}
```

### ❌ DON'T: Skip validity group for multi-field forms
```swift
// ❌ Wrong - no coordinated validation
InputField(text: $email, title: "Email")
    .validationCriteria { /* ... */ }

InputField(text: $password, title: "Password")
    .validationCriteria { /* ... */ }

Button("Submit") { submitForm() }  // Can't validate all at once
```

### ✓ DO: Use validity group
```swift
// ✓ Correct
@State private var validityGroup = ValidityGroup()

InputField(text: $email, title: "Email")
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)

InputField(text: $password, title: "Password")
    .validationCriteria { /* ... */ }
    .validityGroup($validityGroup)

Button("Submit") {
    validityGroup.validateAll()
    if validityGroup.allValid() { submitForm() }
}
```

### ❌ DON'T: Skip frame sizes on GRAsyncImage
```swift
// ❌ May cause layout issues and inefficient caching
List(items) { item in
    GRAsyncImage(url: item.url)  // No frame
}
```

### ✓ DO: Always specify frame sizes
```swift
// ✓ Correct
List(items) { item in
    GRAsyncImage(url: item.url)
        .frame(width: 60, height: 60)
}
```

---

## Development Speed Optimization

### Rule: Prioritize speed over perfection initially

**Problem**: Initial setup feels slow  
**Solution**: Provide copy-paste templates

### Copy-Paste Templates (Save 10+ minutes)

#### Template 1: Simple Form (2 minutes to implement)
```swift
import SwiftUI
import GRButton
import GRInputField

struct SimpleFormView: View {
    @State private var field1 = ""
    @State private var field2 = ""
    
    init() { InputFieldView.configureAppearance() }
    
    var body: some View {
        Form {
            InputField(text: $field1, title: "Field 1", placeholder: "Enter value")
            InputField(text: $field2, title: "Field 2", placeholder: "Enter value")
            
            Button("Submit") { submit() }
                .buttonStyle(GRButtonStyle(appearance: .primary, size: .large(stretch: true)))
        }
    }
    
    func submit() {
        // Your logic
    }
}
```

#### Template 2: Form with Validation (5 minutes to implement)
```swift
import SwiftUI
import GRButton
import GRInputField

struct ValidatedFormView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var validityGroup = ValidityGroup()
    
    enum FormError: ValidationError {
        case invalidEmail, passwordTooShort
        var errorDescription: String? {
            switch self {
            case .invalidEmail: return "Invalid email"
            case .passwordTooShort: return "Password too short"
            }
        }
    }
    
    init() { InputFieldView.configureAppearance() }
    
    var body: some View {
        Form {
            InputField(text: $email, title: "Email", placeholder: "email@example.com")
                .inputFieldTraits(autocapitalizationType: .none, keyboardType: .emailAddress)
                .validationCriteria {
                    Criterion.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                        .failWith(error: FormError.invalidEmail)
                }
                .validityGroup($validityGroup)
            
            InputField(text: $password, title: "Password")
                .inputFieldTraits(isSecureTextEntry: true)
                .validationCriteria {
                    Criterion { $0?.count ?? 0 >= 8 }
                        .failWith(error: FormError.passwordTooShort)
                }
                .validityGroup($validityGroup)
            
            Button("Submit") {
                validityGroup.validateAll()
                if validityGroup.allValid() { submit() }
            }
            .buttonStyle(GRButtonStyle(appearance: .primary, size: .large(stretch: true)))
        }
    }
    
    func submit() {
        // Your logic
    }
}
```

#### Template 3: List with Images (3 minutes to implement)
```swift
import SwiftUI
import GRAsyncImage

struct Item: Identifiable {
    let id = UUID()
    let title: String
    let imageURL: URL?
}

struct ItemListView: View {
    let items: [Item] = [] // Your data
    
    var body: some View {
        List(items) { item in
            HStack(spacing: 12) {
                GRAsyncImage(url: item.imageURL)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                Text(item.title)
            }
        }
    }
}
```

### Rule: Use snippet libraries

**Suggest users create Xcode snippets for:**
1. Appearance configuration block
2. InputField with validation
3. Button with style
4. ValidityGroup setup

**Example snippet creation:**
```
// Xcode → Editor → Create Code Snippet
// Title: "GoodSwiftUI Input Field with Validation"
// Completion: grinput
// Platform: iOS
```

### Time Comparison Guide

**Help users understand trade-offs:**

| Task | Native SwiftUI | GoodSwiftUI | When Worth It? |
|------|----------------|-------------|----------------|
| Single text field | 30 sec | 1 min | No - use native |
| Styled button | 1 min | 1.5 min | No - use native |
| Form with validation | 10 min | 5 min | ✅ Yes |
| Multi-field form | 20 min | 8 min | ✅ Yes |
| Design system setup | N/A | 10 min | ✅ Yes (reusable) |
| Async images with cache | 15 min | 2 min | ✅ Yes |

**Rule**: If task is faster with native SwiftUI, suggest that instead.

---

## Summary Checklist for AI

When helping users implement GoodSwiftUI:

**Before suggesting GoodSwiftUI:**
- [ ] Ask: "Is native SwiftUI sufficient?"
- [ ] Check: Does user need validation/consistency?
- [ ] Determine complexity level needed (1, 2, or 3)

**When implementing:**
- [ ] Import correct module(s): `import GRButton`, `import GRInputField`, etc.
- [ ] Call `InputFieldView.configureAppearance()` if using GRInputField
- [ ] **Use helper functions** (`.filled()`, `.outlined()`) to reduce parameters
- [ ] Provide ready-made presets, don't make users configure everything
- [ ] Show SwiftUI property mapping when relevant
- [ ] Use `EmptyView()` for icon-only buttons (circle/square sizes)
- [ ] Create `ValidityGroup` for multi-field forms
- [ ] Define `ValidationError` enums with `errorDescription`
- [ ] Use `@FocusState` for focus management in forms
- [ ] Set frames on `GRAsyncImage` for optimal caching
- [ ] Add accessibility labels and identifiers
- [ ] Use `.realtime()` for immediate validation feedback when appropriate

**Speed & cognitive load optimization:**
- [ ] Provide copy-paste templates from this document
- [ ] Start with Level 1 (simple), add complexity only if needed
- [ ] Use helper functions to minimize parameters (e.g., `.filled(background:foreground:)`)
- [ ] Provide complete presets (iOS Native, Material, Minimal)
- [ ] Suggest Xcode snippets for repeated patterns
- [ ] Map to SwiftUI concepts user already knows

---

## Platform Requirements

- **iOS**: 15.0+
- **Swift**: 5.5+
- **Xcode**: 13.0+
- **Package Manager**: Swift Package Manager only

---

## Additional Resources

- **Repository**: https://github.com/GoodRequest/GoodSwiftUI
- **Sample App**: `GoodSwiftUI-Sample/` directory in repository
- **Dependencies**: GoodExtensions-iOS (automatically included)

