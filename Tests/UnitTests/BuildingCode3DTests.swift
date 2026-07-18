import XCTest
@testable import BuildingCode3D

final class BuildingCode3DTests: XCTestCase {
    func testToolCatalogContainsOneHundredUniqueWorkingTools() {
        XCTAssertEqual(ToolCatalog.tools.count, 100)
        XCTAssertEqual(Set(ToolCatalog.tools.map(\.id)).count, 100)
        XCTAssertEqual(Set(ToolCatalog.tools.map(\.title)).count, 100)
        XCTAssertTrue(ToolCatalog.tools.allSatisfy { !$0.checklist.isEmpty })
    }

    func testCalculationModesProduceRealResults() {
        XCTAssertEqual(ToolMode.multiply.calculate(12, 3), 36)
        XCTAssertEqual(ToolMode.divide.calculate(12, 3), 4)
        XCTAssertEqual(ToolMode.percentage.calculate(12, 48), 25)
        XCTAssertEqual(ToolMode.difference.calculate(12, 3), 9)
        XCTAssertEqual(ToolMode.sum.calculate(12, 3), 15)
        XCTAssertNil(ToolMode.divide.calculate(12, 0))
        XCTAssertNil(ToolMode.checklist.calculate(12, 3))
    }

    func testAllResourceLinksAreSecure() {
        XCTAssertEqual(ResourceCatalog.resources.count, 10)
        XCTAssertTrue(ResourceCatalog.resources.allSatisfy { $0.url.scheme == "https" })
    }

    func testPriceCopyIsExact() {
        XCTAssertEqual(AppConfig.fixedPrice, "JPY¥1600")
    }
}

