//
//  CoderTests.swift
//  CoderTests
//
//  Created by 王智刚 on 2018/3/30.
//  Copyright © 2018年 王智刚. All rights reserved.
//

import XCTest
@testable import Coder

#if DEBUG
    
protocol DictionaryValue {
    var value: Any { get }
}
extension Int: DictionaryValue { var value: Any { return self } }
extension Float: DictionaryValue { var value: Any { return self } }
extension String: DictionaryValue { var value: Any { return self } }
extension Bool: DictionaryValue { var value: Any { return self } }
    extension DictionaryValue {
        var value: Any {
            let mirror = Mirror(reflecting: self)
            let array = mirror.children.flatMap { label, value -> (String, DictionaryValue) in
                guard let label = label else {
                    fatalError("invalid key in \(self.self)")
                }
                guard let value = value as? DictionaryValue else {
                    fatalError("invalid value in \(self.self)")
                }
                return (label, value)
            }
            return Dictionary(uniqueKeysWithValues: array)
        }
    }
    
#endif


class CoderTests: XCTestCase {
    
    struct Student: DictionaryValue {
        let name: String
        let age: Int
        let height: Float
    }
    
    override func setUp() {
        super.setUp()
        let student1 = Student(name: "小明", age: 19, height: 100)
        #if DEBUG
            print("value++:\(student1.value)")
        #endif
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
