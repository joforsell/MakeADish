//
//  MakeADishTests.swift
//  MakeADishTests
//
//  Created by Johan Forsell on 2022-05-04.
//

import XCTest
@testable import MakeADish

class FeedVCTests: XCTestCase {
    
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

class DishVCTests: XCTestCase {
    
    let vc = DishVC(dish: Dish(id: UUID(),
                               title: "Perfect Paella",
                               description: "The perfect Spanish paella with rice",
                               videoId: "wetw2",
                               ingredients: ["Rice", "Paellastuff", "Salt", "Pepper"],
                               tags: ["Spanish", "Low carb"],
                               ratings: [5, 1, 3, 2, 4]))

    
    func testDishVCMakesFiveStars() throws {
        vc.loadView()
        vc.viewDidLoad()
        
        XCTAssertEqual(vc.starsView.arrangedSubviews.count, 5)
    }
    
    func testDishVCGraysStarsIfNoRatings() throws {
        vc.dish.ratings = []
        vc.loadView()
        vc.viewDidLoad()
        
        XCTAssertEqual(vc.starsView.arrangedSubviews[0].tintColor, .gray)
        XCTAssertEqual(vc.starsView.arrangedSubviews[0].layer.opacity, 0.5)
    }
    
    func testDishVCGetsAverageRating() throws {
        let averageRating = vc.getRatingAverage(from: vc.dish.ratings)
        
        XCTAssertEqual(averageRating, 3)
    }
}
