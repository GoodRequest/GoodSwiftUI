//
//  GRToggleSnapshotTests.swift
//  GoodSwiftUI-Sample
//
//  Created by Lukas Kubaliak on 30/06/2025.
//

import XCTest
import SnapshotTesting
import SwiftUI

@testable import GRToggle

@MainActor final class GRToggleSnapshotTests: XCTestCase {
    
    // MARK: - Test Configuration
    
    /// Appearance model for switch-style toggles used in tests.
    private let switchAppearance = GRSwitchAppearance(activeBackgroundColor: .red)
    
    /// Appearance model for custom toggle styles (checkbox, radio, etc.).
    private let toggleAppearance = GRToggleAppearance(
        tintColor: .red,
        uncheckedBorderColor: .gray,
        checkedBackgroundColor: .red.opacity(0.2),
        checkmarkImageTintColor: .white,
        checkmarkImage: Image(systemName: "checkmark")
    )
    
    /// Set to true to record new reference images instead of comparing against existing ones.
    private var shouldRecordNewReference = false
    
    // MARK: - Toggle Views
    
    /// Toggle view with ON state, used for enabled toggle tests.
    private var toggleOn: some View {
        Toggle(isOn: .constant(true)) {}
            .fixedSize()
    }
    
    /// Toggle view with OFF state, used for disabled toggle tests.
    private var toggleOff: some View {
        Toggle(isOn: .constant(false)) {}
            .fixedSize()
    }
    
}

// MARK: - Switch Style Toggle Tests

extension GRToggleSnapshotTests {
    
    /// Tests the appearance of a large-sized switch toggle in enabled (ON) state.
    func testLargeToggleEnabled() {
        let content = toggleOn
            .toggleStyle(GRSwitchStyle(appearance: switchAppearance, size: .large))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large-sized switch toggle in disabled (OFF) state.
    func testLargeToggleDisabled() {
        let content = toggleOff
            .toggleStyle(GRSwitchStyle(appearance: switchAppearance, size: .large))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small-sized switch toggle in enabled (ON) state.
    func testSmallToggleEnabled() {
        let content = toggleOn
            .toggleStyle(GRSwitchStyle(appearance: switchAppearance, size: .small))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small-sized switch toggle in disabled (OFF) state.
    func testSmallToggleDisabled() {
        let content = toggleOff
            .toggleStyle(GRSwitchStyle(appearance: switchAppearance, size: .small))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Circular Check Style Toggle Tests

extension GRToggleSnapshotTests {

    /// Tests the appearance of a large circular check toggle in enabled (ON) state.
    func testLargeCheckCircleEnabled() {
        let content = toggleOn
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .circularCheck,
                    size: .large
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large circular check toggle in disabled (OFF) state.
    func testLargeCheckCircleDisabled() {
        let content = toggleOff
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .circularCheck,
                    size: .large
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small circular check toggle in enabled (ON) state.
    func testSmallCheckCircleEnabled() {
        let content = toggleOn
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .circularCheck,
                    size: .small
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small circular check toggle in disabled (OFF) state.
    func testSmallCheckCircleDisabled() {
        let content = toggleOff
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .circularCheck,
                    size: .small
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Checkbox Style Toggle Tests

extension GRToggleSnapshotTests {
    
    /// Tests the appearance of a large checkbox toggle in enabled (ON) state.
    func testLargeCheckBoxEnabled() {
        let content = toggleOn
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .checkbox,
                    size: .large
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large checkbox toggle in disabled (OFF) state.
    func testLargeCheckBoxDisabled() {
        let content = toggleOff
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .checkbox,
                    size: .large
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small checkbox toggle in enabled (ON) state.
    func testSmallCheckBoxEnabled() {
        let content = toggleOn
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .checkbox,
                    size: .small
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small checkbox toggle in disabled (OFF) state.
    func testSmallCheckBoxDisabled() {
        let content = toggleOff
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .checkbox,
                    size: .small
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Radio Style Toggle Tests

extension GRToggleSnapshotTests {
    
    /// Tests the appearance of a large radio toggle in enabled (ON) state.
    func testLargeRadioEnabled() {
        let content = toggleOn
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .radio,
                    size: .large
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large radio toggle in disabled (OFF) state.
    func testLargeRadioDisabled() {
        let content = toggleOff
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .radio,
                    size: .large
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small radio toggle in enabled (ON) state.
    func testSmallRadioEnabled() {
        let content = toggleOn
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .radio,
                    size: .small
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a small radio toggle in disabled (OFF) state.
    func testSmallRadioDisabled() {
        let content = toggleOff
            .toggleStyle(
                GRToggleStyle(
                    appearance: toggleAppearance,
                    style: .radio,
                    size: .small
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}
