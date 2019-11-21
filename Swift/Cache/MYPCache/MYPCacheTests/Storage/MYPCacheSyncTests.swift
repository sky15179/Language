//
//  MYPCacheSyncTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/6.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

@testable import MYPCache

class MYPCacheSyncTests: XCTestCase {
    private var cache: MYPCacheSync!
    private let key = "test123"
    private let testObj = Student(name: "xiaoming", age: 12)
    override func setUp() {
        super.setUp()
        let memory = MYPMemoryCache(with: MYPCacheMemoryConfig(expiry: .never, countLimit: 10, costLimit: 10, shouldRemoveAllObjectsOnMemoryWarning: true, shouldRemoveAllObjectsWhenEnteringBackground: true))

        cache = MYPCacheSync(cache: memory, serialQueue: DispatchQueue(label: "test"))
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDisk() {
        let disk = try? MYPDiskCache(with: MYPCacheDiskConfig(name: "diskTest", countLimit: 10, costLimit: 100000, expiry: .seconds(1000)))
        XCTAssertNotNil(disk)
        cache = MYPCacheSync(cache: disk!, serialQueue: DispatchQueue(label: "test"))
        testSet()
        testObject()
        testRemove()
        testWarpper()
        testRemoveIfExpired()
        testRemoveIfNotExpired()
        testClear()
    }
    
    func testInit() {
        XCTAssertNotNil(cache)
    }
    
    func testSet() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
        XCTAssertEqual(cacheObjc, testObj)
    }
    
    func testObject() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
        XCTAssertEqual(cacheObjc, testObj)
        XCTAssertEqual(cacheObjc?.name, "xiaoming")
        XCTAssertEqual(cacheObjc?.age, 12)
    }
    
    func testRemove() {
        try? cache.removeObejct(forKey: key)
        let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
        XCTAssertNil(cacheObjc)
    }
    
    func testClear() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        try? cache.setObject(object: testObj, forKey: "test2", expiry: nil)
        try? cache.setObject(object: testObj, forKey: "test3", expiry: nil)
        try? cache.removeAll()
        XCTAssertNil(try? cache.object(ofType: Student.self, forKey: key))
        XCTAssertNil(try? cache.object(ofType: Student.self, forKey: "test2"))
        XCTAssertNil(try? cache.object(ofType: Student.self, forKey: "test3"))
    }
    
    func testWarpper() {
        let warpper = try? cache.wapper(ofType: Student.self, forKey: key)
        XCTAssertNil(warpper)
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        let warpper1 = try? cache.wapper(ofType: Student.self, forKey: key)
        XCTAssertNotNil(warpper1)
        XCTAssertEqual(warpper1?.object.name, "xiaoming")
        XCTAssertEqual(warpper1?.object.age, 12)
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
