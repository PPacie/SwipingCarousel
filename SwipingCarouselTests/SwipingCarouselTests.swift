//
//  SwipingCarouselTests.swift
//  SwipingCarouselTests
//
//  Created by Pablo Paciello on 8/1/17.
//  Copyright © 2017 PPacie. All rights reserved.
//

import XCTest
@testable import SwipingCarousel

class SwipingCarouselTests: XCTestCase {
    
    var cellManager: SwpingCarouselCellManager!
    var cell: SwipingCarouselCollectionViewCell!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cell = SwipingCarouselCollectionViewCell()
        let initialSize = CGSize(width: 210, height: 278)
        cell.frame.size = initialSize
        cell.bounds.size = initialSize
        cellManager = SwpingCarouselCellManager(withCell: cell)
        cellManager.originalPoint = CGPoint(x: 165.0, y: 301.5)
    }
    
    override func tearDown() {
        cell = nil
        cellManager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSwipingSideCells() {
        //After swiping up or down over a cell which is not the one in the middle of the screen, the cell should go back to its original position.
        cellManager.swipeDistanceOnY = 200
        cell.frame.size.height = 200
        cellManager.afterSwipeAction()
        
        XCTAssertEqual(cell.center, cellManager.originalPoint, "Cell Should go back to CenterY position")
    }
    
    
    func testSwipingDownNoDeletion() {
        //After swiping down over a cell which has deleteOnSwipeDown disabled, the cell should go back to its original position.
        cellManager.swipeDistanceOnY = 300
        cell.deleteOnSwipeDown = false
        cellManager.downAction()
        
        XCTAssertEqual(cell.center, cellManager.originalPoint, "Cell Should go back to CenterY if Delete is disabled")
    }
    
    func testSwipingDownAndDeletion() {
        //After swiping down over a cell which has deleteOnSwipeDown enabled, the cell should go to the maxY possible, disappearing from Screen.
        cellManager.swipeDistanceOnY = 300
        cell.deleteOnSwipeDown = true
        cellManager.downAction()
        
        XCTAssertNotEqual(cell.center, cellManager.originalPoint, "Cell Should go off screen")
    }
    
    func testSwipingUpNoDeletion() {
        //After swiping up over a cell which has deleteOnSwipeUp disabled, the cell should go back to its original position.
        cellManager.swipeDistanceOnY = -300
        cell.deleteOnSwipeUp = false
        cellManager.upAction()
        
        XCTAssertEqual(cell.center, cellManager.originalPoint, "Cell Should go back to CenterY if Delete is disabled")
    }
    
    func testSwipingUpAndDeletion() {
        //After swiping up over a cell which has deleteOnSwipeUp enabled, the cell should go to the maxY possible, disappearing from Screen.
        cellManager.swipeDistanceOnY = -300
        cell.deleteOnSwipeUp = true
        cellManager.upAction()
        
        XCTAssertNotEqual(cell.center, cellManager.originalPoint, "Cell Should go off screen")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
