//
//  ExpresstionTests.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/30.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

class ExpresstionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let result = expression.run("2*3+4*6/2-10")
        XCTAssert(result?.0 == 8)
        
        let result1 = myExpression.intParser.run("1")

        let expressions: [myExpression] = [
            // (1+2)*3
            .infix(.infix(.int(1), "+", .int(2)), "*", .int(3)),
            // A0*3
            .infix(.reference("A", 0), "*", .int(3)),
            // SUM(A0:A1)
            .function("SUM", .infix(.reference("A", 0), ":", .reference("A", 1)))
        ]
        evaluate(expressions: expressions)
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
