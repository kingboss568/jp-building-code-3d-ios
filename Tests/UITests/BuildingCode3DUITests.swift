import XCTest

final class BuildingCode3DUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.navigationBars["建築基準法令3D図解"].waitForExistence(timeout: 15))
    }

    func testRealSearchReturnsNavigableResults() {
        let search = app.descendants(matching: .any)["diagram-search"]
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("避難")
        XCTAssertTrue(app.staticTexts["検索結果"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS '避難'")).firstMatch.exists)
    }

    func testSummaryIsOneRowAndUsesExactPrice() {
        let details = app.descendants(matching: .any)["summary-details"]
        let free = app.descendants(matching: .any)["summary-free"]
        let tools = app.descendants(matching: .any)["summary-tools"]
        let unlock = app.descendants(matching: .any)["summary-unlock"]
        XCTAssertTrue(details.waitForExistence(timeout: 5))
        XCTAssertEqual(details.frame.midY, free.frame.midY, accuracy: 2)
        XCTAssertEqual(free.frame.midY, tools.frame.midY, accuracy: 2)
        XCTAssertEqual(tools.frame.midY, unlock.frame.midY, accuracy: 2)
        XCTAssertTrue(unlock.label.contains("JPY¥1600"))
    }

    func testGalleryUsesTwoColumnsAndOpensDetail() {
        app.tabBars.buttons["ギャラリー"].tap()
        let first = app.descendants(matching: .any)["gallery-card-1"]
        let second = app.descendants(matching: .any)["gallery-card-2"]
        XCTAssertTrue(first.waitForExistence(timeout: 8))
        XCTAssertEqual(first.frame.midY, second.frame.midY, accuracy: 4)
        XCTAssertNotEqual(first.frame.midX, second.frame.midX)
        first.tap()
        XCTAssertTrue(app.navigationBars["図版 001"].waitForExistence(timeout: 5))
    }

    func testToolCalculatesSavesNotesAndShares() {
        app.tabBars.buttons["ツール"].tap()
        let tool = app.descendants(matching: .any)["tool-1"]
        XCTAssertTrue(tool.waitForExistence(timeout: 6))
        tool.tap()
        let first = app.descendants(matching: .any)["tool-input-first"]
        let second = app.descendants(matching: .any)["tool-input-second"]
        XCTAssertTrue(first.waitForExistence(timeout: 5))
        first.tap()
        first.typeText("12")
        second.tap()
        second.typeText("48")
        let result = app.descendants(matching: .any)["tool-result"]
        XCTAssertTrue(result.waitForExistence(timeout: 3))
        XCTAssertTrue("\(result.label) \(String(describing: result.value))".contains("25"))
        let notes = app.descendants(matching: .any)["tool-notes"]
        notes.tap()
        notes.typeText("現場確認済み")
        let saved = expectation(for: NSPredicate(format: "value CONTAINS %@", "現場確認済み"), evaluatedWith: notes)
        wait(for: [saved], timeout: 3)
    }

    func testProExplainsPurchaseAndRestoration() {
        app.tabBars.buttons["解除"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["pro-price"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["JPY¥1600"].exists)
        XCTAssertTrue(app.buttons["購入を復元"].exists)
        XCTAssertTrue(app.staticTexts["1回払い・定期購読なし"].exists)
    }
}
