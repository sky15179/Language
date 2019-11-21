//
//  learnReactiveSwiftTests.swift
//  learnReactiveSwiftTests
//
//  Created by 王智刚 on 2017/8/31.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import learnReactiveSwift

class learnReactiveSwiftTests: XCTestCase {
    var controller: TodoTableViewController1!
    
    override func setUp() {
        super.setUp()
        controller = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TodoTableViewController1") as! TodoTableViewController1
        _ = controller.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testState() {
        //初始
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TodoSection.todos.rawValue), 0)
        XCTAssertEqual(controller.title, "TODO - 0")
        XCTAssertFalse(controller.addBarItem.isEnabled)
        
        // ([], "") -> (dummy, "abc")
        controller.todoState = TodoState(todos: dummy, text: "abc")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TodoSection.todos.rawValue), 0)
        XCTAssertEqual(controller.title, "TODO - 5")
        XCTAssertTrue(controller.addBarItem.isEnabled)
        
        // (dummy, "abc") -> ([], "")
        controller.todoState = TodoState(todos: [], text: "")
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: TodoSection.todos.rawValue), 0)
        XCTAssertEqual(controller.title, "TODO - 0")
        XCTAssertFalse(controller.addBarItem.isEnabled)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
