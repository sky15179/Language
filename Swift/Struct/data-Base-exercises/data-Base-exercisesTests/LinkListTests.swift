//
//  LinkListTests.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/14.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import XCTest

class LinkListTests: XCTestCase {
    
    override func setUp() {


        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        super.setUp()
        let arr = [1,3,5,7,4,6,9]
        let linkList = LinkList(array: arr)
        XCTAssertNotNil(linkList)
        XCTAssert(linkList.count == arr.count)
        XCTAssert(linkList.head?.vaule == arr.first)
        XCTAssert(linkList.last?.vaule == arr.last)
        XCTAssert(linkList.isEmpty == arr.isEmpty)
        XCTAssert(linkList.node(atIndex: 2)?.vaule == arr[2])
        XCTAssert(linkList[2] == arr[2])
        let (b,a) = linkList.nodeBeforeAndAfter(atIndex: 1)
        XCTAssert(b?.vaule == 1)
        XCTAssert(a?.vaule == 3)
        
        let (b1,a1) = linkList.nodeBeforeAndAfter(atIndex: 0)
        XCTAssert(b1?.vaule == nil)
        XCTAssert(a1?.vaule == 1)
        
        let (b2,a2) = linkList.nodeBeforeAndAfter(atIndex: linkList.count - 1)
        XCTAssert(b2?.vaule == 6)
        XCTAssert(a2?.vaule == 9)
        
        let subscripttest = linkList[1]
        
        XCTAssert(subscripttest == 3)
        
        let linkList2:LinkList<Int> = [22,33]
        XCTAssert(linkList2[0] == 22)
        XCTAssert(linkList2[1] == 33)
        linkList.append(linkList2)
        XCTAssert(linkList.last?.vaule == 33)
        XCTAssert(linkList.last?.previous?.vaule == 22)
        
        linkList.append(10)
        XCTAssert(linkList.last?.vaule == 10)
        linkList.insert(atInex: 2, vaule: 100)
        XCTAssert(linkList.node(atIndex: 2)?.vaule == 100)
        let node = linkList.node(atIndex: 4)
        let count = linkList.count
        let removeVaule = linkList.remove(atIndex: 4)
        XCTAssert(node?.vaule == removeVaule)
        XCTAssert(count - 1 == linkList.count)
        
        let linkList3:LinkList<Int> = [7,8]
        linkList2.insert(atIndex: 0, list: linkList3)
        XCTAssert(linkList2[0] == 7)
        XCTAssert(linkList2[1] == 8)
        XCTAssert(linkList2[2] == 22)
        XCTAssert(linkList2[3] == 33)
        
        XCTAssert(linkList2.findNode(atIndex: 3)?.vaule == 33)
        XCTAssert(linkList2.findNode(atIndex: 2)?.vaule == 22)
        linkList2.bringNodeToHead(node: linkList2.node(atIndex: 2)!)
        XCTAssert(linkList2[0] == 22)
        
        let removeValue2 = linkList2.remove(atIndex: 3)
        XCTAssert(removeValue2 == 33)
        XCTAssert(linkList2.count == 3)
        XCTAssert(linkList2.last?.vaule == 8)
        
        let fiterList = linkList.fiter(){
            $0 == 9
        }
        
        
        XCTAssert(fiterList.count == 1)
        let mapList = linkList.map{
            $0 * 2
        }
        
        for index in 1..<linkList.count {
            let oriVaule = linkList.node(atIndex: index)?.vaule
            let newV = mapList.node(atIndex: index)?.vaule
            XCTAssert(oriVaule! * 2 == newV)
        }
        
        linkList2.reverse()
        XCTAssert(linkList2[0] == 8)
        XCTAssert(linkList2[1] == 7)
        XCTAssert(linkList2[2] == 22)
        let arrC = [8,7,22]
        let arrR = linkList2.allValues()
        XCTAssert(arrR == arrC)
        
        let iterator = linkList2.makeIterator()
        var tmp = 0
        
        while let node = iterator.next() {
            XCTAssert(node.vaule == linkList2[tmp])
            tmp += 1
        }
        
        
        let arr5 = [Int]()
        let node5 = LinkList<Int>.LinkListNode(1)
        let node6 = LinkList<Int>.LinkListNode(2)
        
        let linkList5 = LinkList(array: arr5)
        linkList5.insert(atInex: 0, node:node5)
        linkList5.insert(atInex: 0, node:node6)
        XCTAssert(linkList5.count == 2)
        XCTAssertNotNil(linkList5.last)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
