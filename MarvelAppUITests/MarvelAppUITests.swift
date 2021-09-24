//
//  MarvelAppUITests.swift
//  MarvelAppUITests
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import XCTest

final class MarvelAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
    }

    func testViewInitialized() {
        XCTAssertTrue(app.staticTexts["Marvel Characters"].exists)
        XCTAssertTrue(app.textFields["Filter input text"].exists)
        XCTAssertTrue(app.collectionViews["Collection of Characters"].exists)
    }

    func testLoadCharactersAndScroll() {
        // Needs network connection
        let collectionView = app.collectionViews["Collection of Characters"]
        XCTAssertTrue(collectionView.cells["Character Cell"]
            .waitForExistence(timeout: 10))

        app.swipeUp()

        // Uncomment the next few lines to check the endless scroll happening 🧙🏻‍♂️🔮
//        while true {
//            app.swipeUp()
//        }
    }

    func testLoadCharactersFromSearchTextField() {
        // Needs network connection
        let textField = app.textFields["Filter input text"]
        XCTAssertTrue(textField.exists)

        textField.tap()
        textField.typeText("Spider-Man")

        let collectionView = app.collectionViews["Collection of Characters"]
        XCTAssertTrue(collectionView.cells["Character Cell"]
            .waitForExistence(timeout: 10))

        app.swipeUp()
    }

    func testOpenCharacterDetailsScreen() {
        // Needs network connection
        let textField = app.textFields["Filter input text"]
        XCTAssertTrue(textField.exists)

        textField.tap()
        textField.typeText("Spider-Man")

        let collectionView = app.collectionViews["Collection of Characters"]
        let cell = collectionView.cells["Character Cell"].firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 10))

        cell.tap()

        XCTAssertTrue(app.staticTexts["Spider-Man (1602)"].waitForExistence(timeout: 10))
        let tableView = app.tables["Table of collections"]
        XCTAssertTrue(tableView.exists)
        let imageView = app.images["Character image"]
        XCTAssertTrue(imageView.exists)

        let comicsButton = app.buttons["Comics"]
        XCTAssertTrue(comicsButton.exists)
        comicsButton.tap()

        let seriesButton = app.buttons["Series"]
        XCTAssertTrue(seriesButton.exists)
        seriesButton.tap()
        
        let storiesButton = app.buttons["Stories"]
        XCTAssertTrue(storiesButton.exists)
        storiesButton.tap()

        XCTAssertEqual(tableView.tableRows.cells.count, 0)
    }
}
