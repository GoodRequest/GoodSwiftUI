# Snapshot Testing in GoodSwiftUI

This document provides guidance on working with snapshot tests in the GoodSwiftUI project.

## Requirements

**Important:** Snapshot tests must be run with the following configuration:

- Device: iPhone 16 Pro (iPhone17,1)
- iOS Version: 18.6
- Appearance: Light Mode

Running tests on different devices, iOS versions, or in dark mode will cause tests to fail.

## Overview

The GoodSwiftUI project uses [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) library for visual regression testing of UI components. Snapshot tests capture the appearance of UI components and compare them against reference images to detect unintended visual changes.

## Components with Snapshot Tests

The project currently includes snapshot tests for the following components:

- **GRButton**: Various button styles, sizes, and states
- **GRToggle**: Toggle components including switches, checkboxes, and radio buttons
- **GRInputField**: Text input fields in different states and configurations

## Running Snapshot Tests

To run snapshot tests:

1. Open the GoodSwiftUI-Sample project in Xcode
2. Select the appropriate test target (`GoodSwiftUI-SnapshotTests`)
3. Press ⌘+U or navigate to **Product > Test** to run all tests
4. To run individual test classes, navigate to the test file and click the diamond icon next to the class or method name

## Regenerating Snapshots

When you make intentional UI changes that affect the appearance of components, you'll need to regenerate the reference snapshots:

1. Open the relevant test file (e.g., `GRButtonSnapshotTests.swift`)
2. Change the `shouldRecordNewReference` property from `false` to `true`:
   ```swift
   private var shouldRecordNewReference = true
   ```
3. Run the tests – this will generate new reference images
4. After successful generation, set `shouldRecordNewReference` back to `false`
5. Commit the new reference images to the repository

## Adding New Snapshot Tests

To add new snapshot tests for existing or new components:

1. Create a new test file if testing a new component, or add to an existing test file
2. Import the required modules:
   ```swift
   import XCTest
   import SnapshotTesting
   import SwiftUI

   @testable import YourComponentModule
   ```
3. Create a test class that inherits from `XCTestCase`&#x20;
4. Define a `shouldRecordNewReference` property (default to `false`)
5. Create test methods that:
   - Set up the component with the desired configuration
   - Call `assertSnapshot(of:as:record:)` with your component
6. Run the tests with `shouldRecordNewReference = true` to generate initial reference images

**Example:**

```swift
@MainActor final class NewComponentSnapshotTests: XCTestCase {
    private var shouldRecordNewReference = false
    
    func testComponentAppearance() {
        let content = YourComponent()
            .fixedSize()
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
}
```

## Best Practices

- Always use `.fixedSize()` on SwiftUI views to ensure consistent sizing
- Test components in all relevant states (enabled, disabled, error states, etc.)
- Test different sizes and configurations
- Review snapshot diffs carefully before accepting new reference images

## Troubleshooting

If snapshot tests are failing unexpectedly:

1. Check if the UI component has intentionally changed – if so, regenerate the snapshots
2. Verify that the test environment is consistent (device, OS version, etc.)
3. Consider using tolerance parameters if dealing with minor rendering differences:
   ```swift
   assertSnapshot(of: content, as: .image(precision: 0.98), record: shouldRecordNewReference)
   ```

