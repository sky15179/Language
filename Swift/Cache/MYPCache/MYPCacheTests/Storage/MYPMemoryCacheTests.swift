//
//  MYPMemoryCacheTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/6.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import MYPCache
class MYPMemoryCacheTests: XCTestCase {
    private let key = "test123"
    private let testObj = Student(name: "xiaoming", age: 12)
    private var memory: MYPMemoryCache!
    private let config = MYPCacheMemoryConfig(expiry: .never, countLimit: 10, costLimit: 10, shouldRemoveAllObjectsOnMemoryWarning: true, shouldRemoveAllObjectsWhenEnteringBackground: true)
    override func setUp() {
        super.setUp()
        memory = MYPMemoryCache(with: config)
        memory.didEnterBackgroundClosure = { (cache: MYPMemoryCache) -> Void in
            print("memorycache进入后台")
        }
        
        memory.didReceiveMemoryWarningClosure = { (cache: MYPMemoryCache) -> Void in
            print("memorycache收到内存警告")
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(memory)
        XCTAssertNotNil(memory.didReceiveMemoryWarningClosure)
        XCTAssertNotNil(memory.didEnterBackgroundClosure)
    }
    
    func testSet() {
        memory.setObject(object: testObj, forKey: key)
        let cacheObjc = try? memory.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
        XCTAssertEqual(cacheObjc, testObj)
    }
    
    func testObject() {
        memory.setObject(object: testObj, forKey: key)
        let cacheObjc = try? memory.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
        XCTAssertEqual(cacheObjc, testObj)
        XCTAssertEqual(cacheObjc?.name, "xiaoming")
        XCTAssertEqual(cacheObjc?.age, 12)
    }
    
    func testRemove() {
        memory.removeObejct(forKey: key)
        let cacheObjc = try? memory.object(ofType: Student.self, forKey: key)
        XCTAssertNil(cacheObjc)
    }
    
    func testClear() {
        memory.setObject(object: testObj, forKey: key)
        memory.setObject(object: testObj, forKey: "test2")
        memory.setObject(object: testObj, forKey: "test3")
        memory.removeAll()
        XCTAssertNil(try? memory.object(ofType: Student.self, forKey: key))
        XCTAssertNil(try? memory.object(ofType: Student.self, forKey: "test2"))
        XCTAssertNil(try? memory.object(ofType: Student.self, forKey: "test3"))
    }
    
    func testWarpper() {
        let warpper = try? memory.wapper(ofType: Student.self, forKey: key)
        XCTAssertNil(warpper)
        memory.setObject(object: testObj, forKey: key)
        let warpper1 = try? memory.wapper(ofType: Student.self, forKey: key)
        XCTAssertNotNil(warpper1)
        XCTAssertEqual(warpper1?.object.name, "xiaoming")
        XCTAssertEqual(warpper1?.object.age, 12)
    }
    
    func testRemoveIfExpired() {
        let expiry = MYPCahceExpiry.date(Date().addingTimeInterval(-10))
        memory.setObject(object: testObj, forKey: key, expiry: expiry)
        memory.removeExpiredObjects()
        let cacheObjc = try? memory.object(ofType: Student.self, forKey: key)
        XCTAssertNil(cacheObjc)
    }
    
    func testRemoveIfNotExpired() {
        memory.setObject(object: testObj, forKey: key)
        memory.removeExpiredObjects()
        let cacheObjc = try? memory.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
    }
    
    func testProperty() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
