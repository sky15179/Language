//
//  MYPLinkListTests.swift
//  MYPCacheTests
//
//  Created by 王智刚 on 2017/11/2.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

@testable import MYPCache

class MYPLinkListTests: XCTestCase {
    private let linkList = MYPLinkList<Int>()
    private let testList = MYPLinkList<Int>(array: [1,2,3])
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let link2 = MYPLinkList<Int>(array: [1, 2, 3])
        let link3 = MYPLinkList<String>(array: ["1", "2", "3","4"])
        let obj1 = MYPMemoryCacheObject(key: "a", value: "a")
        let obj2 = MYPMemoryCacheObject(key: "b", value: "b")
        let obj3 = MYPMemoryCacheObject(key: "c", value: "c")
        let link4 = MYPLinkList<MYPMemoryCacheObject>(array: [obj1 ,obj2, obj3])
        XCTAssertNotNil(link2)
        XCTAssertNotNil(link3)
        XCTAssertNotNil(link4)
        
        XCTAssertEqual(link2.count, 3)
        XCTAssertEqual(link3.count, 4)
        XCTAssertEqual(link4.count, 3)
        link2.enumerated().forEach { offset, node in
            XCTAssertEqual(offset, node.value - 1)
        }
        
        link3.enumerated().forEach { offset, node in
            XCTAssertEqual(offset, Int(node.value)! - 1)
        }
        link4.enumerated().forEach { (arg) in
            let (offset, node) = arg
            XCTAssertEqual(node.value.value as! String, ["a", "b", "c"][offset])
        }
    }
    
    func testEmpty() {
        let linkList1 = MYPLinkList<Int>()
        XCTAssertNotNil(linkList1)
        XCTAssertEqual(linkList1.count, 0)
    }
    
    func testOneNode() {
        let list = MYPLinkList<Int>(array: [1,2,3])
        XCTAssertNotNil(list)
        XCTAssertEqual(list.count, 3)
    }
    
    func testAtIndex() {
        testList.enumerated().forEach { offset, _ in
            XCTAssertEqual(testList.value(atIndex: UInt(offset)), offset + 1)
            XCTAssertEqual(testList.node(atIndex: UInt(offset))?.value, offset + 1)
        }

        XCTAssertEqual(testList.allValues().count, 3)
        testList.allValues().enumerated().forEach { (offset, value) in
            if let value = value {
                XCTAssertEqual(value, offset + 1)
            } else {
                XCTFail("错误")
            }
        }
        let (pre, next) = testList.nodeBeforeAndAfter(atIndex: 1)

        if let pre2 = pre, let next2 = next {
            XCTAssertEqual(pre2.value, 1)
            XCTAssertEqual(next2.value, 2)
        } else {
            XCTFail("链表节点错误")
        }
    }
    
    func testAppend() {
        let list = testList
        list.append(5)
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list.last?.value, 5)
        list.append(MYPLinkList<Int>.Node(6))
        XCTAssertEqual(list.count, 5)
        XCTAssertEqual(list.last?.value, 6)
        let list2 = MYPLinkList<Int>(array: [7, 8, 9])
        list.append(list2)
        XCTAssertEqual(list.count, 8)
        XCTAssertEqual(list.last?.value, 9)
        XCTAssertEqual(list.last?.previous?.value, 8)
        XCTAssertEqual(list.last?.previous?.previous?.value, 7)
    }
    
    func testRemove() {
        let list = testList
        XCTAssertEqual(list.removeFirst()?.value, 1)
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.first?.value, 2)
        
        let list2 = MYPLinkList<Int>(array: [1,2,3])
        XCTAssertEqual(list2.removeLast()?.value, 3)
        XCTAssertEqual(list2.count, 2)
        XCTAssertEqual(list2.last?.value, 2)

        let list3 = MYPLinkList<Int>(array: [1,2,3])
        XCTAssertEqual(list3.remove(atIndex: 1), 2)
        XCTAssertEqual(list3.count, 2)
        XCTAssertEqual(list3.value(atIndex: 1), 3)

        list3.removeAll()
        XCTAssertEqual(list3.count, 0)

        let list4 = MYPLinkList<Int>(array: [1,2,3])
        if let node = list4.node(atIndex: 1) {
            list4.remove(node: node)
            XCTAssertEqual(list4.count, 2)
            XCTAssertEqual(list4.value(atIndex: 1), 3)
        } else {
            XCTFail("取出元素错误")
        }
}
    
    func testProperty()  {
        XCTAssertEqual(testList.first?.value, 1)
        XCTAssertEqual(testList.last?.value, 3)
        XCTAssertEqual(testList.count, 3)
        
        let link = MYPLinkList<Int>(array: [])
        XCTAssertTrue(link.isEmpty)
        XCTAssertFalse(testList.isEmpty)
    }
    
    func testInsert() {
        let link = testList
        link.insert(value: 5, index: 0)
        XCTAssertEqual(link.count, 4)
        XCTAssertEqual(link.first?.value, 5)
        let newNode = MYPLinkList<Int>.Node(8)
        link.insertNode(atIndex: link.count - 1, node: newNode)
        XCTAssertEqual(link.last?.value, 8)
        let newNode2 = MYPLinkList<Int>.Node(9)
        link.insertNode(atIndex: 0, node: newNode2)
        XCTAssertEqual(link.first?.value, 9)
        
        let link3 = MYPLinkList<Int>()
        link3.insertNode(atIndex: 0, node: newNode2)
    }
    
    func testMove() {
        let link = testList
        let newNode = MYPLinkList<Int>.Node(10)
        link.bringNodeToHead(node: newNode)
        XCTAssertEqual(link.count, 4)
        XCTAssertEqual(link.first?.value, 10)
        
        if let node = link.node(atIndex: 1) {
            link.bringNodeToHead(node: node)
            XCTAssertEqual(link.count, 4)
            XCTAssertEqual(link.first?.value, 1)
            XCTAssertEqual(link.value(atIndex: 1), 10)
        } else {
            XCTFail("取出元素发生错误")
        }
        
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
