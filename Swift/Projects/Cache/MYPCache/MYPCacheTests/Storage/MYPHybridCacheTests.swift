//
//  MYPHybridCacheTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/8.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import MYPCache

class MYPHybridCacheTests: XCTestCase {
    private var cache: MYPHybridCache!
    private let key = "test123"
    private let testObj = Student(name: "xiaoming", age: 12)
    private let memory = MYPMemoryCache(with: MYPCacheMemoryConfig(expiry: .never, countLimit: 10, costLimit: 10, shouldRemoveAllObjectsOnMemoryWarning: true, shouldRemoveAllObjectsWhenEnteringBackground: true))
    private let disk = try? MYPDiskCache(with: MYPCacheDiskConfig(name: "diskTest", countLimit: 10, costLimit: 100000, expiry: .seconds(1000)))
    private var caches: [MYPStorageProtocol] = []
    override func setUp() {
        super.setUp()
        cache = MYPHybridCache(diskCahe: disk!, memoryCahe: memory)
        // Put setup code here. This method is called before the invocation of each test method in the class.
        caches.append(disk!)
        caches.append(memory)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(memory)
        XCTAssertNotNil(disk)
        XCTAssertNotNil(cache)
        XCTAssertEqual(caches.count, 2)
    }
    
    func testSet() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        let cacheObjc = try! disk?.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc)
        XCTAssertEqual(cacheObjc!, testObj)
        
        let cacheObjc2 = try? memory.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(cacheObjc2)
        XCTAssertEqual(cacheObjc2, testObj)
    }
    
    func testObject() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        caches.forEach { cache in
            let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
            XCTAssertNotNil(cacheObjc)
            XCTAssertEqual(cacheObjc, testObj)
            XCTAssertEqual(cacheObjc?.name, "xiaoming")
            XCTAssertEqual(cacheObjc?.age, 12)
        }
    }
    
    func testRemove() {
        try? cache.removeObejct(forKey: key)
        caches.forEach { cache in
            let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
            XCTAssertNil(cacheObjc)
        }
    }
    
    func testClear() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        try? cache.setObject(object: testObj, forKey: "test2", expiry: nil)
        try? cache.setObject(object: testObj, forKey: "test3", expiry: nil)
        try? cache.removeAll()
        
        caches.forEach { cache in
            XCTAssertNil(try? cache.object(ofType: Student.self, forKey: key))
            XCTAssertNil(try? cache.object(ofType: Student.self, forKey: "test2"))
            XCTAssertNil(try? cache.object(ofType: Student.self, forKey: "test3"))
        }
    }
    
    func testWarpper() {
        try? cache.removeAll()
        let warpper = try? cache.wapper(ofType: Student.self, forKey: key)
        XCTAssertNil(warpper)
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        caches.forEach { cache in
            let warpper1 = try? cache.wapper(ofType: Student.self, forKey: key)
            XCTAssertNotNil(warpper1)
            XCTAssertEqual(warpper1?.object.name, "xiaoming")
            XCTAssertEqual(warpper1?.object.age, 12)
        }
    }
    
    func testRemoveIfExpired() {
        let expiry = MYPCahceExpiry.date(Date().addingTimeInterval(-10))
        try? cache.setObject(object: testObj, forKey: key, expiry: expiry)
        try? cache.removeExpiredObjects()
        
        caches.forEach { cache in
            let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
            XCTAssertNil(cacheObjc)
        }
    }
    
    func testRemoveIfNotExpired() {
        try? cache.setObject(object: testObj, forKey: key, expiry: nil)
        try? cache.removeExpiredObjects()
        caches.forEach { cache in
            let cacheObjc = try? cache.object(ofType: Student.self, forKey: key)
            XCTAssertNotNil(cacheObjc)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
