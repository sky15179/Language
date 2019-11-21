//
//  MYPCacheAsyncTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/8.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest
@testable import MYPCache

class MYPCacheAsyncTests: XCTestCase {
    private var cache: MYPCacheAsync!
    private let key = "AsyncTest"
    private let testObj = Student(name: "xiaohei", age: 25)
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let memory = MYPMemoryCache(with: MYPCacheMemoryConfig(expiry: .never, countLimit: 10, costLimit: 10, shouldRemoveAllObjectsOnMemoryWarning: true, shouldRemoveAllObjectsWhenEnteringBackground: true))
        cache = MYPCacheAsync(cache: memory, queue: DispatchQueue(label: "async"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDisk() {
        let disk = try? MYPDiskCache(with: MYPCacheDiskConfig(name: "diskTest", countLimit: 10, costLimit: 100000, expiry: .seconds(1000)))
        XCTAssertNotNil(disk)
        cache = MYPCacheAsync(cache: disk!, queue: DispatchQueue(label: "async-disk"))
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
        let expectation = self.expectation(description: "AsyncCache")
        cache.setObject(object: testObj, forKey: key, expiry: nil, completion: { _ in
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        let expectation2 = self.expectation(description: "AsyncCache2")
        cache.object(ofType: Student.self, forKey: key, completion: { result in
            switch result {
            case .value(let value):
                XCTAssertEqual(value, self.testObj)
                expectation2.fulfill()
            default:
                XCTFail()
            }
        })
        wait(for: [expectation2], timeout: 1.0)
        
        cache.existObject(ofType: Student.self, forKey: key) { result in
            switch result {
            case .value(let value):
                XCTAssertTrue(value)
            case .error:
                XCTFail()
            }
        }

    }
    
    func testObject() {
        let expectation4 = self.expectation(description: "AsyncCache4")
        cache.removeAll { _ in
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 1.0)
        let expectation = self.expectation(description: "AsyncCache")
        cache.object(ofType: Student.self, forKey: key, completion: { result in
            switch result {
            case .value( _):
                XCTFail()
            case .error(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 1.0)
        let expectation2 = self.expectation(description: "AsyncCache2")
        cache.setObject(object: testObj, forKey: key, expiry: nil, completion: { _ in
            expectation2.fulfill()
        })
        wait(for: [expectation2], timeout: 1.0)
        let expectation3 = self.expectation(description: "AsyncCache3")
        cache.object(ofType: Student.self, forKey: key, completion: { result in
            switch result {
            case .value(let value):
                XCTAssertEqual(value, self.testObj)
                XCTAssertEqual(value.name, "xiaohei")
                XCTAssertEqual(value.age, 25)
                expectation3.fulfill()
            default:
                XCTFail()
            }
        })
        wait(for: [expectation3], timeout: 1.0)
    }
    
    func testRemove() {
        let expectation = self.expectation(description: "AsyncCache")
        for index in 0...20 {
            cache.setObject(object: testObj, forKey: key + "\(index)", expiry: nil, completion: { _ in
                if index == 20 {
                    expectation.fulfill()
                }
            })
        }
        wait(for: [expectation], timeout: 2.0)
        let expectation3 = self.expectation(description: "AsyncCache3")
        cache.removeObejct(forKey: key + "\(10)", completion: { _ in
            expectation3.fulfill()
        })
        wait(for: [expectation3], timeout: 1.0)
        let expectation2 = self.expectation(description: "AsyncCache2")
        cache.existObject(ofType: Student.self, forKey: key + "\(10)") { result in
            switch result {
            case .value:
                XCTFail()
            case .error:
                expectation2.fulfill()
            }
        }
        wait(for: [expectation2], timeout: 1.0)
    }

    func testClear() {
        let expectation = self.expectation(description: "AsyncCache")
        for index in 0...20 {
            cache.setObject(object: testObj, forKey: key + "\(index)", expiry: nil, completion: { _ in
                if index == 20 {
                    expectation.fulfill()
                }
            })
        }
        wait(for: [expectation], timeout: 2.0)
        let expectation3 = self.expectation(description: "AsyncCache3")
        cache.removeAll(completion: { _ in
            expectation3.fulfill()
        })
        wait(for: [expectation3], timeout: 1.0)
        let expectation2 = self.expectation(description: "AsyncCache2")
        for index in 0...20 {
            cache.existObject(ofType: Student.self, forKey: key + "\(10)") { result in
                switch result {
                case .value:
                    XCTFail()
                case .error:
                    if index == 20 {
                        expectation2.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation2], timeout: 2.0)

    }

    func testWarpper() {
        let expectation4 = self.expectation(description: "AsyncCache4")
        cache.removeAll { _ in
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 1.0)
        let expectation3 = self.expectation(description: "AsyncCache3")
        cache.wapper(ofType: Student.self, forKey: key) { (result) in
            switch result {
            case .value:
                XCTFail()
            case .error:
                expectation3.fulfill()
            }
        }
        wait(for: [expectation3], timeout: 1.0)
        let expectation = self.expectation(description: "AsyncCache")
        cache.setObject(object: testObj, forKey: key, expiry: nil, completion: { _ in
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)

        let expectation2 = self.expectation(description: "AsyncCache2")
        cache.wapper(ofType: Student.self, forKey: key) { (result) in
            switch result {
            case .value(let value):
                XCTAssertNotNil(value)
                XCTAssertEqual(value.object.name, "xiaohei")
                XCTAssertEqual(value.object.age, 25)
                expectation2.fulfill()
            case .error:
                XCTFail()
            }
        }
        wait(for: [expectation2], timeout: 1.0)
    }
    
    func testRemoveIfExpired() {
        let expiry = MYPCahceExpiry.date(Date().addingTimeInterval(-10))
        let expectation = self.expectation(description: "AsyncCache")
        cache.setObject(object: testObj, forKey: key, expiry: expiry, completion: { _ in
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        let expectation2 = self.expectation(description: "AsyncCache2")
        cache.removeExpiredObjects { _ in
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 1.0)
        
        let expectation3 = self.expectation(description: "AsyncCache3")
        cache.object(ofType: Student.self, forKey: key, completion: { result in
            switch result {
            case .value:
                XCTFail()
            case .error:
                expectation3.fulfill()
            }
        })
        wait(for: [expectation3], timeout: 1.0)
    }

    func testRemoveIfNotExpired() {
        let expiry = MYPCahceExpiry.date(Date().addingTimeInterval(1000))
        let expectation = self.expectation(description: "AsyncCache")
        cache.setObject(object: testObj, forKey: key, expiry: expiry, completion: { _ in
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        let expectation2 = self.expectation(description: "AsyncCache2")
        cache.removeExpiredObjects { _ in
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 1.0)
        
        let expectation3 = self.expectation(description: "AsyncCache3")
        cache.object(ofType: Student.self, forKey: key, completion: { result in
            switch result {
            case .value(let value):
                XCTAssertNotNil(value)
                XCTAssertEqual(value.name, "xiaohei")
                XCTAssertEqual(value.age, 25)
                expectation3.fulfill()
            case .error:
                XCTFail()
            }
        })
        wait(for: [expectation3], timeout: 1.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
