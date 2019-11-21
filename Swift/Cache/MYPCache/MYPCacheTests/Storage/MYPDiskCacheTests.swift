//
//  MYPDiskCacheTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/1.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import MYPCache

class MYPDiskCacheTests: XCTestCase {
    
    private let key = "student1"
    private var diskCache: MYPDiskCache!
    private let config = MYPCacheDiskConfig(name: "testDisk")
    private let fileMgr = FileManager.default
    private let testStudent = Student(name: "小明", age: 11)
    
    override func setUp() {
        super.setUp()
        diskCache = try! MYPDiskCache(with: config)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
       try? diskCache.removeAll()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let exist = fileMgr.fileExists(atPath: diskCache.path)
        XCTAssertTrue(exist)
        XCTAssert(config.costLimit == UInt.max)
        XCTAssert(config.countLimit == UInt.max)
    }
    
    func testDefaultPath() throws {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let path = "\(paths.first!)/\(config.name)"
        XCTAssertEqual(diskCache.path, path)
    }
    
    func testCustomPath() throws {
        let url = try! fileMgr.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let cache = try MYPDiskCache(with: MYPCacheDiskConfig(name: "testDiskCustom", directory: url))
        
        XCTAssertEqual(cache.path, url.appendingPathComponent("testDiskCustom", isDirectory: true).path)
    }
    
    func testSetObject() throws {
        try diskCache.setObject(object: testStudent, forKey: key)
        let exist = fileMgr.fileExists(atPath: diskCache.makeFilePath(for: key))
        XCTAssertTrue(exist)
    }
    
    func testOject() throws {
        try diskCache.setObject(object: testStudent, forKey: key)
        let exist = fileMgr.fileExists(atPath: diskCache.makeFilePath(for: key))
        XCTAssertTrue(exist)
        let obj = try diskCache.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(obj)
        XCTAssertEqual(obj, testStudent)
    }
    
    func testCacheWrapper() throws {
        var warpper: MYPCacheWrapper<Student>?
        do {
            warpper = try diskCache.wapper(ofType: Student.self, forKey: key)
        } catch {
        }
        XCTAssertNil(warpper)
        try diskCache.setObject(object: testStudent, forKey: key)
        warpper = try diskCache.wapper(ofType: Student.self, forKey: key)
        let attributes = try fileMgr.attributesOfItem(atPath: diskCache.makeFilePath(for: key))
        let expiry = MYPCahceExpiry.date(attributes[FileAttributeKey.modificationDate] as! Date)
        XCTAssertEqual(warpper?.object, testStudent)
        XCTAssertEqual(warpper?.object.name, testStudent.name)
        XCTAssertEqual(warpper?.object.age, testStudent.age)
        XCTAssertEqual(warpper?.expiry.date, expiry.date)
    }
    
    func testRemoveObjectIfExpiredWhenExpired() throws {
        let expiry = MYPCahceExpiry.date(Date().addingTimeInterval(-1000000))
        try diskCache.setObject(object: testStudent, forKey: key, expiry: expiry)
        try diskCache.removeObjectIfExpired(forKey: key)
        let exist = fileMgr.fileExists(atPath: diskCache.makeFilePath(for: key))
        XCTAssertFalse(exist)
        var obj: Student?
        do {
            obj = try diskCache.object(ofType: Student.self, forKey: key)
        } catch {
        }
        
        XCTAssertNil(obj)
    }
    
    func testRemoveObjectIfExpiredWhenNotExpired() throws {
        try diskCache.setObject(object: testStudent, forKey: key)
        try diskCache.removeObjectIfExpired(forKey: key)
        let exist = fileMgr.fileExists(atPath: diskCache.makeFilePath(for: key))
        XCTAssertTrue(exist)
        let obj = try diskCache.object(ofType: Student.self, forKey: key)
        XCTAssertNotNil(obj)
    }
    
    func testRemoveAll() throws {
        
        try given("先创建一些文件") {
            try diskCache.setObject(object: testStudent, forKey: key)
        }
        
        do {
            try diskCache.removeAll()
        } catch {
            XCTFail(error.localizedDescription)
        }
        let exist = fileMgr.fileExists(atPath: diskCache.path)
        XCTAssertTrue(exist)
        let contents = try fileMgr.contentsOfDirectory(atPath: diskCache.path)
        XCTAssertEqual(contents.count, 0)
    }
    
    func testCreateDirectory() throws {
        do {
            try diskCache.removeAll()
            XCTAssertTrue(fileMgr.fileExists(atPath: diskCache.path))
            try diskCache.createDirectory()
            let contents = try? fileMgr.contentsOfDirectory(atPath: diskCache.path)
            XCTAssertEqual(contents?.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testClearExpired() throws {
        let expiry1: MYPCahceExpiry = .date(Date().addingTimeInterval(-100000))
        let expiry2: MYPCahceExpiry = .date(Date().addingTimeInterval(100000))
        let key1 = "item1"
        let key2 = "item2"
        try diskCache.setObject(object: testStudent, forKey: key1, expiry: expiry1)
        try diskCache.setObject(object: testStudent, forKey: key2, expiry: expiry2)
        try diskCache.removeExpiredObjects()
        var object1: Student?
        let object2 = try diskCache.object(ofType: Student.self, forKey: key2)
        
        do {
            object1 = try diskCache.object(ofType: Student.self, forKey: key1)
        } catch {}
        
        XCTAssertNil(object1)
        XCTAssertNotNil(object2)
    }
    
    func testMakeFileName() throws {
        XCTAssertEqual(diskCache.makeFileName(for: key), MD5(key))
    }
    
    func testMakeFilePath() throws {
        XCTAssertEqual(diskCache.makeFilePath(for: key), "\(diskCache.path)/\(diskCache.makeFileName(for: key))")
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
