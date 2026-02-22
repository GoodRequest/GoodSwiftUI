# GoodSwiftUI

[![iOS Version](https://img.shields.io/badge/iOS_Version->=_15.0-brightgreen?logo=apple&logoColor=green)]()
[![Swift Version](https://img.shields.io/badge/Swift_Version-5.5-green?logo=swift)](https://docs.swift.org/swift-book/)
[![Supported devices](https://img.shields.io/badge/Supported_Devices-iPhone/iPad-green)]()
[![Contains Test](https://img.shields.io/badge/Tests-YES-blue)]()
[![Dependency Manager](https://img.shields.io/badge/Dependency_Manager-SPM-red)](#installation)

A collection of useful and frequently used SwiftUI components for iOS development, including:

- **GRButton** - Customizable buttons with loading states and icons
- **GRInputField** - Advanced input fields with validation
- **GRToggle** - Custom toggles, checkboxes, and radio buttons
- **GRAsyncImage** - Async image loading with caching
- **ReadableContentWidth** - Content width constraints for better readability

Designed to help developers build consistent, accessible, and production-ready UIs faster.

## Installation

### Swift Package Manager

#### Xcode (Recommended)

1. Open your project in Xcode
2. Go to **File → Add Packages...**
3. Enter the repository URL: `https://github.com/GoodRequest/GoodSwiftUI`
4. Select the version and add the package

#### Package.swift

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
            ]
        )
    ]
)
```

## Quick Start

```swift
import SwiftUI
import GRButton
import GRInputField

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

## Documentation

### 📖 For Developers
**[Usage Guide](USAGE_GUIDE.md)** - Complete documentation with examples for all components:
- Installation and setup
- Component examples (GRButton, GRInputField, GRToggle, GRAsyncImage)
- Helper patterns to reduce cognitive load
- Best practices and accessibility
- SwiftUI property mapping

### 🤖 For AI Assistants
**[AI Usage Rules](AI_USAGE_RULES.md)** - Structured rules for AI coding assistants:
- Development speed optimizations
- When to use library vs native SwiftUI
- Copy-paste templates and patterns
- Progressive complexity levels
- Cognitive load reduction strategies

## Components

- **[GRButton](USAGE_GUIDE.md#grbutton)** - Buttons with loading states, icons, and custom appearances
- **[GRInputField](USAGE_GUIDE.md#grinputfield)** - Input fields with validation, formatting, and accessibility
- **[GRToggle](USAGE_GUIDE.md#grtoggle)** - Switches, checkboxes, and radio buttons
- **[GRAsyncImage](USAGE_GUIDE.md#grasyncimage)** - Async image loading with caching
- **[ReadableContentWidth](USAGE_GUIDE.md#readable-content-width)** - Content width constraints for iPad

## Sample Project

Explore the [GoodSwiftUI-Sample](GoodSwiftUI-Sample/) directory for complete examples and snapshot tests.

## License
GoodSwiftUI is released under the MIT license. See [LICENSE](LICENSE.md) for details.
