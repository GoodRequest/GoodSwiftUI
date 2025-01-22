//
//  GRButton.swift
//  sourcery_iOSUITests
//
//  Created by Matus Klasovity on 22/01/2025.
//

import XCTest

final class GRButton_iOSUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testGRButtonAccessibility() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let button = app.buttons["buttonts-sample-link"]

        XCTAssert(button.exists)
        // Go to the GRButtonSampleView
        button.tap()

        try app.performAccessibilityAudit()
    }

}
