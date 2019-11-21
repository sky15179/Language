//
//  LRU.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/13.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation
import QuartzCore


protocol LRUObj {
    var key:String{ get }
    var cost:Int{set get}
}

class LRU<T:LRUObj> {
    fileprivate typealias NodeType = LinkList<T>.Node
    var totalCost:Int = 0
    var totalCount:Int {
        return lindkedList.count
    }
    fileprivate var lindkedList:LinkList<T> = LinkList<T>()
    fileprivate var _dict:NSMutableDictionary = NSMutableDictionary()
    var releaseOnMainThread:Bool = true
    var releaseAsynchronously:Bool = false
    
    public func set(object:T,forKey key:String) {
        if let node:NodeType = _dict.value(forKey: key) as? NodeType {
            totalCost -= node.vaule.cost
            totalCost += object.cost
            node.vaule = object
            lindkedList.bringNodeToHead(node: node)
        }else{
            let newNode:NodeType = NodeType(object)
            totalCost += newNode.vaule.cost
            lindkedList.insertNode(atIndex: 0, node: newNode)
            _dict.setValue(newNode, forKey: key)
        }
    }
    
    public func object(forKey key:String) -> T? {
        let node:NodeType? = _dict.object(forKey: key) as? NodeType
        return node?.vaule
    }
    
    public func allObjects() -> [T] {
        return lindkedList.allValues()
    }
    
    @discardableResult public func removeObject(forKey key:String) -> T? {
        let node:NodeType? = _dict.object(forKey: key) as? NodeType
        let result = node?.vaule
        if let removeNode = node {
            totalCost -= removeNode.vaule.cost
            _dict.removeObject(forKey: key)
            lindkedList.remove(node: removeNode)
        }
        return result
    }
    
    public func removeAll() {
        _dict.removeAllObjects()
        lindkedList.removeAll()
        totalCost = 0
    }
    
    @discardableResult public func removeLastObject() -> T? {
        if let last:NodeType = lindkedList.tail {
            _dict.removeObject(forKey: last.vaule.key)
            totalCost -= last.vaule.cost
            return lindkedList.removeLast()
        }
        return nil
    }
    
    public func firstObject() -> T? {
        return lindkedList.first?.vaule
    }
    
    public func lastObject() -> T? {
        return lindkedList.last?.vaule
    }
    
    public subscript(key:String) -> T? {
        set{
            if let newValue = newValue{
                self.set(object: newValue, forKey: key)
            }else{
                removeObject(forKey: key)
            }
        }
        
        get{
            return self.object(forKey: key)
        }
    }
    
}

class LRUGenerator<T:LRUObj>:FastGeneratorType {
    typealias Element = T
    fileprivate let lru: LRU<T>
    fileprivate let linkedListGenerator: LinkListGenerator<T>
    
    fileprivate init(linkedListGenerator:LinkListGenerator<T>,lru:LRU<T>) {
        self.lru = lru
        self.linkedListGenerator = linkedListGenerator
    }
    
    func next() -> Element? {
        if let node = linkedListGenerator.next() {
            self.lru.lindkedList.bringNodeToHead(node: node)
            return node.vaule
        }
        return nil
    }
    
    func shift() {
        if let node = linkedListGenerator.next() {
            self.lru.lindkedList.bringNodeToHead(node: node)
        }

    }
}


// MARK: - 提供lru迭代能力
extension LRU:Sequence{
    typealias Iterator = LRUGenerator<T>
    func makeIterator() -> Iterator {
        var generator:Iterator
        generator = LRUGenerator(linkedListGenerator: self.lindkedList.makeIterator(), lru: self)
        return generator
    }
}

