//
//  ImageFeedUITests.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

import XCTest

final class ImageFeed_UITests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {

        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 3))

        authButton.tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()

        let passwordsTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordsTextField.waitForExistence(timeout: 5))
        passwordsTextField.tap()
        passwordsTextField.typeText("")
        passwordsTextField.swipeUp()
        webView.swipeUp()

        webView.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))

        print(app.debugDescription)
    }

    func testFeed() {
        print(app.debugDescription)
        let table = app.tables.element(boundBy: 0)
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        table.swipeUp()
        sleep(4)
        table.swipeDown()
        sleep(5)

        let cellToLike = table.cells.element(boundBy: 0)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 3))

        cellToLike.buttons.firstMatch.tap()
        sleep(4)
        cellToLike.buttons.firstMatch.tap()

        sleep(3)
        cellToLike.tap()

        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))

        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Дмитрий Дмитриев"].exists)
        XCTAssertTrue(app.staticTexts["@alikagn"].exists)

        app.buttons["logout button"].tap()
    }
}
