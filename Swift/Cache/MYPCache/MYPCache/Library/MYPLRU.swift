//
//  MYPLRU.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/2.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

public protocol MYPLRUObj: Equatable {
    var key: String { get }
    var cost: UInt { get set}
}

class MYPLRU<T: MYPLRUObj> {
    
    private typealias NodeType = MYPLinkList<T>.Node
    
    //MARK: Porperty - Public
    
    var totalCost: UInt = 0
    var totalCount: UInt {
        return linkList.count
    }
    var firstObject: T? {
        return linkList.first?.value
    }
    var lastObject: T? {
        return linkList.last?.value
    }
    
    //MARK: Porperty - Private
    
    fileprivate let linkList = MYPLinkList<T>()
    private var cacheDict = [String: NodeType]()
    
    //MARK: Method - Public
    
    public func set(object: T, forKey key: String) {
        if let node = cacheDict[key] {
            totalCost -= node.value.cost
            totalCost += node.value.cost
            node.value = object
            linkList.bringNodeToHead(node: node)
        } else {
            totalCost += object.cost
            let newNode = NodeType(object)
            linkList.insertNode(atIndex: 0, node: newNode)
            cacheDict[key] = newNode
        }
    }
    
    public func object(forKey key: String) -> T? {
        return cacheDict[key]?.value
    }
    
    public func allObjects() -> [T?] {
        return linkList.allValues() 
    }
    
    @discardableResult public func removeObject(forKey key: String) -> T? {
        var result: T? 
        if let node = cacheDict[key] {
            totalCost -= node.value.cost
            cacheDict.removeValue(forKey: key)
            linkList.remove(node: node)
            result = node.value
        } else {
            result = nil
        }
        return result
    }
    
    @discardableResult public func removeLastObject() -> T? {
        var result: T?
        if let tail = linkList.tailNode {
            totalCost -= tail.value.cost
            cacheDict.removeValue(forKey: tail.value.key)
            linkList.remove(node: tail)
            result = tail.value
        } else {
            result = nil
        }
        return result
    }
    
    public func removeAll() {
        linkList.removeAll()
        cacheDict.removeAll()
        totalCost = 0
    }
    
    public subscript(key: String) -> T? {
        set {
            if let new = newValue {
                self.set(object: new, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
        
        get {
            return self.object(forKey: key)
        }
    }
}

// MARK: - 提供lru迭代能力

class MYPLRUGenerator<T: MYPLRUObj>: MYPFastGeneratorType {
    typealias Element = T
    fileprivate let lru: MYPLRU<T>
    fileprivate let linkedListGenerator: MYPLinkListGenerator<T>
    
    fileprivate init(linkedListGenerator: MYPLinkListGenerator<T>, lru: MYPLRU<T>) {
        self.lru = lru
        self.linkedListGenerator = linkedListGenerator
    }
    
    func next() -> Element? {
        if let node = linkedListGenerator.next() {
            self.lru.linkList.bringNodeToHead(node: node)
            return node.value
        }
        return nil
    }
    
    func shift() {
        if let node = linkedListGenerator.next() {
            self.lru.linkList.bringNodeToHead(node: node)
        }
    }
}

extension MYPLRU: Sequence{
    typealias Iterator = MYPLRUGenerator<T>
    func makeIterator() -> Iterator {
        var generator: Iterator
        generator = MYPLRUGenerator(linkedListGenerator: self.linkList.makeIterator(), lru: self)
        return generator
    }
}
