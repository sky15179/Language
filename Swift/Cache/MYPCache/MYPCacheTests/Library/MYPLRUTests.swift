//
//  MYPLRUTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/6.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import MYPCache

class MYPLRUTests: XCTestCase {
    private let testObjc = MYPMemoryCacheObject(key: "test", value: "123", cost: 2, time: .seconds(1000))
    private let lru = MYPLRU<MYPMemoryCacheObject>()
    private var lru2: MYPLRU<MYPMemoryCacheObject>!
    override func setUp() {
        super.setUp()
        lru2 = MYPLRU<MYPMemoryCacheObject>()
        lru2.set(object: testObjc, forKey: testObjc.key)
        let testObjc2 = MYPMemoryCacheObject(key: "test2", value: "456", cost: 4, time: .seconds(2000))
        lru2.set(object: testObjc2, forKey: testObjc2.key)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmpty() {
        XCTAssertNotNil(lru)
        XCTAssertNil(lru.firstObject)
        XCTAssertNil(lru.lastObject)
        XCTAssertEqual(lru.totalCost, 0)
        XCTAssertEqual(lru.totalCount, 0)
    }
    
    func testProperty() {
        let lru1 = MYPLRU<MYPMemoryCacheObject>()
        lru1.set(object: testObjc, forKey: testObjc.key)
        XCTAssertNotNil(lru1.firstObject)
        XCTAssertNotNil(lru1.lastObject)
        XCTAssertEqual(lru1.firstObject?.value as! String, lru1.lastObject?.value as! String)
        XCTAssertEqual(lru1.firstObject?.value as! String, "123")
        XCTAssertEqual(lru1.totalCost, 2)
        XCTAssertEqual(lru1.totalCount, 1)
    }
    
    func testSetObject() {
        let lru1 = MYPLRU<MYPMemoryCacheObject>()
        lru1.set(object: testObjc, forKey: testObjc.key)
        XCTAssertNotNil(lru1.firstObject)
        XCTAssertNotNil(lru1.lastObject)
        XCTAssertEqual(lru1.firstObject?.value as! String, lru1.lastObject?.value as! String)
        XCTAssertEqual(lru1.firstObject?.value as! String, "123")
        XCTAssertEqual(lru1.totalCost, 2)
        XCTAssertEqual(lru1.totalCount, 1)
        
        let testObjc2 = MYPMemoryCacheObject(key: "test2", value: "456", cost: 4, time: .seconds(1000))
        lru1.set(object: testObjc2, forKey: testObjc2.key)
        XCTAssertEqual(lru1.totalCost, 6)
        XCTAssertEqual(lru1.totalCount, 2)
        XCTAssertEqual(lru1.firstObject?.value as! String, "456")
        XCTAssertEqual(lru1.lastObject?.value as! String, "123")
    }
    
    func testObject() {
        let lru1 = MYPLRU<MYPMemoryCacheObject>()
        lru1.set(object: testObjc, forKey: testObjc.key)
        
        let testObjc2 = MYPMemoryCacheObject(key: "test2", value: "456", cost: 4, time: .seconds(1000))
        lru1.set(object: testObjc2, forKey: testObjc2.key)
        XCTAssertEqual(lru1.object(forKey: testObjc.key)?.value as! String, "123")
        XCTAssertEqual(lru1.object(forKey: testObjc2.key)?.value as! String, "456")
    }
    
    func testAllObjects() {
        XCTAssertEqual(lru2.allObjects().count, 2)
        XCTAssertEqual(lru2.allObjects()[0]?.value as! String, "456")
        XCTAssertEqual(lru2.allObjects()[1]?.value as! String, "123")
    }
    
    func testRemove() {
        let lru3 = MYPLRU<MYPMemoryCacheObject>()
        lru3.set(object: testObjc, forKey: testObjc.key)
        let testObjc2 = MYPMemoryCacheObject(key: "test2", value: "456", cost: 4, time: .seconds(1000))
        lru3.set(object: testObjc2, forKey: testObjc2.key)
        
        XCTAssertNotNil(lru3.object(forKey: testObjc.key))
        lru3.removeObject(forKey: testObjc.key)
        XCTAssertNil(lru3.object(forKey: testObjc.key))
        XCTAssertEqual(lru3.totalCount, 1)
    }
    
    /// 测试简便和序列拓展的系列能力
    func testOther() {
        let totalCost2 = lru2.reduce(0) { (result, obj) in
            result + obj.cost
        }
        
        XCTAssertEqual(totalCost2, lru2.totalCost)
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
