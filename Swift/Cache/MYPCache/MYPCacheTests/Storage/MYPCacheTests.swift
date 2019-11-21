//
//  MYPCacheTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import MYPCache

class MYPCacheTests: XCTestCase {
    private var cache: MYPCahe!
    private let disConfig: MYPCacheDiskConfig = MYPCacheDiskConfig(name: "diskTest", countLimit: 10, costLimit: 100000, expiry: .seconds(1000))
    private let memoryConfig: MYPCacheMemoryConfig = MYPCacheMemoryConfig(expiry: .never, countLimit: 10, costLimit: 10, shouldRemoveAllObjectsOnMemoryWarning: true, shouldRemoveAllObjectsWhenEnteringBackground: true)
    private let key = "AsyncTest222"
    private let testObj = Student(name: "xiaohong", age: 6)

    override func setUp() {
        super.setUp()
        
        cache = try! MYPCahe(with: disConfig, memoryConfig: memoryConfig)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(cache)
    }
    
    func testSet() {
        try? cache.setObject(object: testObj, forKey: key)
        XCTAssertTrue(try! cache.existObject(ofType: Student.self, forKey: key))
        let obj = try! cache.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(obj)
        XCTAssertEqual(obj, testObj)
        XCTAssertEqual(obj.name, "xiaohong")
        XCTAssertEqual(obj.age, 6)
    }
    
    func testObject() {
        do {
            let _ = try cache.object(ofType: Student.self, forKey: key + "1")
        } catch {
            XCTAssertNotNil(error)
        }
        try? cache.setObject(object: testObj, forKey: key + "1", expiry: nil)
        let cacheObjc = try? cache.object(ofType: Student.self, forKey: key + "1")
        XCTAssertNotNil(cacheObjc)
        XCTAssertEqual(cacheObjc, testObj)
        XCTAssertEqual(cacheObjc?.name, "xiaohong")
        XCTAssertEqual(cacheObjc?.age, 6)
        
    }

    func testRemove() {
        try? cache.setObject(object: testObj, forKey: key)
        XCTAssertTrue(try! cache.existObject(ofType: Student.self, forKey: key))
        try? cache.removeObejct(forKey: key)
        XCTAssertFalse(try! cache.existObject(ofType: Student.self, forKey: key))

    }

    func testClear() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        try? cache.setObject(object: testObj, forKey: "test2", expiry: nil)
        try? cache.setObject(object: testObj, forKey: "test3", expiry: nil)
        XCTAssertTrue(try! cache.existObject(ofType: Student.self, forKey: key))
        XCTAssertTrue(try! cache.existObject(ofType: Student.self, forKey: "test2"))
        XCTAssertTrue(try! cache.existObject(ofType: Student.self, forKey: "test3"))
        try? cache.removeAll()
        XCTAssertNil(try? cache.object(ofType: Student.self, forKey: key))
        XCTAssertNil(try? cache.object(ofType: Student.self, forKey: "test2"))
        XCTAssertNil(try? cache.object(ofType: Student.self, forKey: "test3"))
    }

    func testWarpper() {
        try? cache.removeAll()
        let warpper = try? cache.wapper(ofType: Student.self, forKey: key)
        XCTAssertNil(warpper)
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        let warpper1 = try? cache.wapper(ofType: Student.self, forKey: key)
        XCTAssertNotNil(warpper1)
        XCTAssertEqual(warpper1?.object.name, "xiaohong")
        XCTAssertEqual(warpper1?.object.age, 6)
    }

    func testRemoveIfExpired() {
        let expiry = MYPCahceExpiry.date(Date().addingTimeInterval(-10))
        try? cache.setObject(object: testObj, forKey: key, expiry: expiry)
        try? cache.removeExpiredObjects()
        let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
        XCTAssertNil(cacheObjc)
    }
    
    func testRemoveIfNotExpired() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        try? cache.removeExpiredObjects()
        let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
