//
//  GRButtonSnapshotTests.swift
//  GRButtonSnapshotTests
//
//  Created by Lukas Kubaliak on 27/06/2025.
//

import XCTest
import SnapshotTesting
import SwiftUI

@testable import GRButton

@MainActor final class GRButtonSnapshotTests: XCTestCase {
    
    // MARK: - Constants
    
    /// Constants used throughout the test suite.
    private enum Constants {
        /// Default button title text
        static let title = "Button"
        /// Left icon used in button tests
        static let leftImage = Image(systemName: "person")
        /// Right icon used in button tests
        static let rightImage = Image(systemName: "arrow.right")
    }
    
    // MARK: - Test Configuration
    
    /// Set to true to record new reference images instead of comparing against existing ones.
    private var shouldRecordNewReference = false
    
    /// Standard appearance configuration used across all button tests.
    /// This provides consistent styling for all snapshot comparisons.
    private var testAppearance: GRButtonAppearanceModel = .init(
        backgroundColor: .red,
        disabledBackgroundColor: .red.opacity(0.4),
        loadingTintColor: .white,
        iconTintColor: .white,
        iconDisabledTintColor: .white.opacity(0.4),
        textColor: .white,
        disabledTextColor: .white.opacity(0.4),
        textFont: .system(size: 17, weight: .medium),
        disabledTextFont: .system(size: 17, weight: .medium)
    )
    
    /// Creates a standard button with text content.
    /// Used for testing text-based button variants.
    private var baseButton: some View {
        Button(Constants.title) {}
            .fixedSize()
    }
    
    /// Creates a button with no visible content.
    /// Used for testing icon-only button variants like circle and square buttons.
    private var emptyButton: some View {
        Button(action: {}, label: { EmptyView() })
            .fixedSize()
    }
    
}

// MARK: - Standard Button Tests

extension GRButtonSnapshotTests {
    
    /// Tests the appearance of a small-sized button with text only.
    func testBaseButtonSmall() {
        let content = baseButton
            .buttonStyle(GRButtonStyle(appearance: testAppearance, size: .small()))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a medium-sized button with text only.
    func testBaseButtonMedium() {
        let content = baseButton
            .buttonStyle(GRButtonStyle(appearance: testAppearance, size: .medium()))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large-sized button with text only.
    func testBaseButtonLarge() {
        let content = baseButton
            .buttonStyle(GRButtonStyle(appearance: testAppearance, size: .large()))
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Left Icon Button Tests

extension GRButtonSnapshotTests {
    
    /// Tests the appearance of a small-sized button with a left icon and text.
    func testLeftIconButtonSmall() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(leftIcon: Constants.leftImage),
                    size: .small()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a medium-sized button with a left icon and text.
    func testLeftIconButtonMedium() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(leftIcon: Constants.leftImage),
                    size: .medium()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large-sized button with a left icon and text.
    func testLeftIconButtonLarge() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(leftIcon: Constants.leftImage),
                    size: .large()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Right Icon Button Tests

extension GRButtonSnapshotTests {
    
    /// Tests the appearance of a small-sized button with a right icon and text.
    func testRightIconButtonSmall() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(rightIcon: Constants.rightImage),
                    size: .small()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a medium-sized button with a right icon and text.
    func testRightIconButtonMedium() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(rightIcon: Constants.rightImage),
                    size: .medium()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large-sized button with a right icon and text.
    func testRightIconButtonLarge() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(rightIcon: Constants.rightImage),
                    size: .large()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Dual Icon Button Tests

extension GRButtonSnapshotTests {
    
    /// Tests the appearance of a small-sized button with both left and right icons and text.
    func testLeftRightIconButtonSmall() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(
                        leftIcon: Constants.leftImage,
                        rightIcon: Constants.rightImage
                    ),
                    size: .small()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a medium-sized button with both left and right icons and text.
    func testLeftRightIconButtonMedium() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(
                        leftIcon: Constants.leftImage,
                        rightIcon: Constants.rightImage
                    ),
                    size: .medium()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a large-sized button with both left and right icons and text.
    func testLeftRightIconButtonLarge() {
        let content = baseButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: GRButtonIconModel(
                        leftIcon: Constants.leftImage,
                        rightIcon: Constants.rightImage
                    ),
                    size: .large()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}

// MARK: - Special Button Shape Tests

extension GRButtonSnapshotTests {
    
    /// Tests the appearance of a small circular button with an icon.
    func testCircleSmallButton() {
        let content = emptyButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(rightIcon: Constants.rightImage),
                    size: .circleSmall()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a medium circular button with an icon.
    func testCircleMediumButton() {
        let content = emptyButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(rightIcon: Constants.rightImage),
                    size: .circleMedium()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
    /// Tests the appearance of a square button with an icon.
    func testSquareButton() {
        let content = emptyButton
            .buttonStyle(
                GRButtonStyle(
                    appearance: testAppearance,
                    iconModel: .init(rightIcon: Constants.rightImage),
                    size: .square()
                )
            )
        
        assertSnapshot(of: content, as: .image, record: shouldRecordNewReference)
    }
    
}
