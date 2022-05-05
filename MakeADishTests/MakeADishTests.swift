//
//  MakeADishTests.swift
//  MakeADishTests
//
//  Created by Johan Forsell on 2022-05-04.
//

import XCTest
@testable import MakeADish

class MakeADishTests: XCTestCase {
    
    func testFeedVCFetchAllDishes() throws {
        let vc = FeedVC(service: DishesServiceMock())
        
        let expectation = expectation(description: "Fetch dishes from server")
        
        vc.loadDishes() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertEqual(vc.dishes.count, 2)
        XCTAssertEqual(vc.dishes.first?.title, "Testdish")
    }
}
