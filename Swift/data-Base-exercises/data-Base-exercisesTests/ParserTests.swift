//
//  ParserTests.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/29.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }
    
    func testExample() {
        
        let digt = character{
            CharacterSet.decimalDigits.contains($0)
        }
        let result = digt.run("345")
        
        XCTAssert(result?.0 == "3")
        XCTAssert(result?.1 == "45")
        
        let result2 = digt.many.run("345")
        
        XCTAssert((result2?.0)! == ["3","4","5"])
        XCTAssert(result2?.1 == "")
        
        //        let integer = digt.many.map{
        //            Int(String($0))!
        //        }
        
        
        let  result3 = integer.run("567")
        
        XCTAssert(result3?.0 == 567)
        XCTAssert(result3?.1 == "")
        
        let  result4 = integer.run("567abc")
        
        XCTAssert(result4?.0 == 567)
        XCTAssert(result4?.1 == "abc")
        
        let multiplication = integer.follow(by: character{$0 == "*"}).follow(by: integer)
        let result5 = multiplication.run("2*3")
        XCTAssert(result5?.1 == "")
        let tuple = result5?.0
        let tuple2 = tuple?.0
        XCTAssert(tuple?.1 == 3)
        XCTAssert(tuple2?.0 == 2)
        XCTAssert(tuple2?.1 == "*")
        
        XCTAssert(curriedMultiply(2)("*")(3) == 6)
        
        let p1 = integer.map(curriedMultiply)
        let multiplication3 = p1.follow(by: character{$0 == "*"}).map{ f,op in f(op) }.follow(by: integer).map{ f,x in f(x) }
        let result6 = multiplication3.run("3*4")
        XCTAssert(result6?.0 == 12)
        XCTAssert(result6?.1 == "")
        
        let multiplication4 = p1<*>character{ $0 == "*" }<*>integer
        let result7 = multiplication4.run("5*6")
        
        XCTAssert(result7?.0 == 30)
        XCTAssert(result7?.1 == "")
        
        let multiplication5 = curriedMultiply<^>integer<*>character{ $0 == "*" }<*>integer
        
        let result8 = multiplication5.run("5*6")
        XCTAssert(result8?.0 == 30)
        XCTAssert(result8?.1 == "")
        
        let star = character{ $0 == "+" }
        let plus = character{ $0 == "*" }
        
        XCTAssert((star<|>plus).run("+")?.0 == "+")
        XCTAssert((star<|>plus).run("+")?.1 == "")
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
