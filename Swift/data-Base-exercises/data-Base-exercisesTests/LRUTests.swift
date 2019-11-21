//
//  LRUTests.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/14.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

class LRUTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let memory1 = MemoryCacheObject(key: "测试1", value: 1 as AnyObject, cost: 5)
        let memory2 = MemoryCacheObject(key: "测试2", value: 2 as AnyObject, cost: 5)
        let lru = LRU<MemoryCacheObject>()
        XCTAssertNotNil(lru)
        XCTAssertNotNil(memory2)
        lru.set(object: memory1, forKey: memory1.key)
        lru.set(object: memory2, forKey: memory2.key)
        XCTAssert(lru.totalCost == 10)
        XCTAssert(lru.totalCount == 2)
        XCTAssert(lru.object(forKey: "测试2")?.value as! Int == 2)
        XCTAssert(lru["测试2"]?.value as! Int == 2)
        XCTAssert(lru.firstObject()?.value as! Int == 2)
        XCTAssert(lru.lastObject()?.value as! Int == 1)
        let arr = lru.allObjects()
        let arr2 = [2,1]
        
        for i in 0..<arr.count {
            XCTAssert(arr[i].value as! Int == arr2[i])
        }
        
        let iterator = lru.makeIterator()
        var tmp = 0
        while let node = iterator.next() {
            XCTAssert(node.value as! Int == arr2[tmp])
            tmp += 1
        }
        XCTAssert(tmp == 2)

        lru.removeObject(forKey: "测试1")
        XCTAssert(lru.totalCost == 5)
        XCTAssert(lru.totalCount == 1)
        XCTAssert(lru.firstObject()?.value as! Int == 2)
        
        lru.removeLastObject()
        XCTAssert(lru.totalCost == 0)
        XCTAssert(lru.totalCount == 0)
        
        XCTAssert(lru.lastObject() == nil)
        
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
