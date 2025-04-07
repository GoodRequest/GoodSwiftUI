//
//  GoodSwiftUI_UITestsLaunchTests.swift
//  GoodSwiftUI-UITests
//
//  Created by Filip Šašala on 24/03/2025.
//

import XCTest

final class InputFieldViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor func testValidationSuite() {
        let app = XCUIApplication()
        app.launch()

        // Navigate to Input fields screen
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Input fields"]/*[[".cells.buttons[\"Input fields\"]",".buttons[\"Input fields\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        /*
         I. Initial state
            - no errors are visible
            - internal state is invalid (no data is entered)
         */
        XCTAssertFalse(app.staticTexts["Your name is not Filip"].exists)
        XCTAssertFalse(app.staticTexts["PIN code must be at least 6 numbers long"].exists)
        XCTAssertFalse(app.staticTexts["PIN code is too long"].exists)

        XCTAssertTrue(app.staticTexts["Text is limited to 10 characters"].exists)
        XCTAssertTrue(app.staticTexts["At least 6 numbers"].exists)

        XCTAssertTrue(app.staticTexts["Internal validation state: invalid"].exists)
        XCTAssertFalse(app.staticTexts["Internal validation state: valid"].exists)

        /*
         II. Validate RegEx limitation to 10 characters by typing 11-letter word
         */
        let nameInputField = app.otherElements["nameTextField"]
        let nameInputFieldTextField = nameInputField.textFields.element
        nameInputField.tap()

        app.slowlyTypeText("GoodRequest") // 11 characters
        XCTAssertEqual(nameInputFieldTextField.value as? String, "GoodReques")

        /*
         III. Validate standard validation of name - error
         */
        app.keyboards.buttons["Pokračovať"].tap()
        XCTAssertTrue(app.staticTexts["Your name is not Filip"].exists)

        /*
         IV. Delete text and validate placeholder
         */
        nameInputField.tap()
        app.deleteText(letters: 10)
        XCTAssertEqual(nameInputFieldTextField.placeholderValue, "Jožko")

        /*
         V. Validate standard validation of name - success
         */
        app.slowlyTypeText("Filip")
        app.keyboards.buttons["Pokračovať"].tap()
        XCTAssertTrue(app.staticTexts["Text is limited to 10 characters"].exists)

        /*
         VI. Validate PIN code entry with random number
             - Number keyboard
             - "Done" button in toolbar above keyboard
             - Secure text entry
             - Eye button
             - Automatic text hiding on focus loss
         */
        let randomPin = Int.random(in: 100000..<999999)
        let randomPinString = String(randomPin)
        let randomPinSpaced = "\(randomPinString.prefix(3)) \(randomPinString.suffix(3))"
        app.slowlyTypeText(randomPinString)
        app.toolbars.buttons["Done"].tap()

        let pinTextField = app.otherElements["pinTextField"]
        let pinTextFieldSecureField = pinTextField.secureTextFields.element

        // 7 dots - 6 numbers + formatter space in between
        XCTAssertEqual(pinTextFieldSecureField.value as? String, "•••••••")
        XCTAssertTrue(app.staticTexts["At least 6 numbers"].exists)

        pinTextField.buttons["show"].tap()
        let pinTextFieldStandardField = pinTextField.textFields.element
        XCTAssertEqual(pinTextFieldStandardField.value as? String, randomPinSpaced)

        app.toolbars.buttons["Done"].tap()
        XCTAssertFalse(pinTextFieldStandardField.exists)
        XCTAssertEqual(pinTextFieldSecureField.value as? String, "•••••••")

        /*
         VII. Validity group test
              - Check internal validation state (invalid when focused)
              - Check visible validation state (invalid when keyboard is dismissed)
         */
        XCTAssertFalse(app.staticTexts["Internal validation state: invalid"].exists)
        XCTAssertTrue(app.staticTexts["Internal validation state: valid"].exists)

        nameInputField.tap()
        app.deleteText(letters: 1)
        app.waitASecond()

        XCTAssertTrue(app.staticTexts["Internal validation state: invalid"].exists)
        XCTAssertFalse(app.staticTexts["Internal validation state: valid"].exists)

        // For some reason existence check here causes focus state to change
        // when running under UI Automation. Delay doesn't seem to help either.
        // app.waitASecond()
        // XCTAssertTrue(app.staticTexts["Text is limited to 10 characters"].exists)

        app.keyboards.buttons["Pokračovať"].tap()
        app.toolbars.buttons["Done"].tap()

        XCTAssertTrue(app.staticTexts["Internal validation state: invalid"].exists)
        XCTAssertFalse(app.staticTexts["Internal validation state: valid"].exists)
        XCTAssertTrue(app.staticTexts["Your name is not Filip"].exists)

        /*
         VIII. Custom rightView button presents alert
         */
        let customViewsInputField = app.otherElements["customViewsInputField"]
        let customViewsInputFieldRightButton = customViewsInputField.buttons["Hello, world"]

        customViewsInputFieldRightButton.tap()
        XCTAssertTrue(app.alerts["Right button alert"].waitForExistence(timeout: 1))
        app.alerts["Right button alert"].buttons["OK"].tap()

        /*
         IX. LeftView text is synchronized with PIN code
             - Formatter keeps value stored as unformatted, only displays with formatting applied
         */
        XCTAssertTrue(customViewsInputField.staticTexts["+421 \(randomPinString)"].exists)

        /*
         X. Realtime validation
         */
        pinTextField.tap()
        app.slowlyTypeText("1234") // assumes auto clear on secure text fields
        app.waitASecond()

        XCTAssertFalse(app.staticTexts["At least 6 numbers"].exists)
        XCTAssertTrue(app.staticTexts["PIN code must be at least 6 numbers long"].exists)
        XCTAssertFalse(app.staticTexts["PIN code is too long"].exists)

        app.slowlyTypeText("56")
        app.waitASecond()

        XCTAssertTrue(app.staticTexts["At least 6 numbers"].exists)
        XCTAssertFalse(app.staticTexts["PIN code must be at least 6 numbers long"].exists)
        XCTAssertFalse(app.staticTexts["PIN code is too long"].exists)

        app.slowlyTypeText("789")
        app.waitASecond()

        XCTAssertFalse(app.staticTexts["At least 6 numbers"].exists)
        XCTAssertFalse(app.staticTexts["PIN code must be at least 6 numbers long"].exists)
        XCTAssertTrue(app.staticTexts["PIN code is too long"].exists)

        app.toolbars.buttons["Done"].tap()
    }

}

// MARK: - Helper extensions

extension XCUIApplication {

    func waitASecond() {
        let expectation = XCTestExpectation(description: "timeout")
        _ = XCTWaiter.wait(for: [expectation], timeout: 1)
    }

    func slowlyTypeText(_ string: String) {
        waitASecond()
        for letter in string {
            if letter.isUppercase {
                self.keyboards.buttons["shift"].tap()
            }
            self.keys[String(letter)].tap()
        }
    }

    func deleteText(letters count: Int) {
        waitASecond()
        for _ in 0..<count {
            self/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards",".otherElements[\"UIKeyboardLayoutStar Preview\"]",".keys[\"Vymazať\"]",".keys[\"delete\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[3,0]]@END_MENU_TOKEN@*/.tap()
        }
    }

}
