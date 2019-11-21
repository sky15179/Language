//
//  LinkList.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/7.
//  Copyright © 2017年 王智刚. All rights reserved.
//  双向链表

import Foundation

public final class LinkList<T>{
    public class LinkListNode<T> {
        var vaule:T
        var next:LinkListNode?
        weak var previous:LinkListNode?
        
        
        init(_ vaule:T) {
            self.vaule = vaule
        }
    }
    
    public typealias Node = LinkListNode<T>
    
    var head:Node?
    var tail:Node?
    
    
    public init(){}
    
}

extension LinkList{
    public var isEmpty:Bool{
        return head == nil
    }
    
    public var first:Node?{
        return head
    }
    
    public var last:Node?{
        
        if let node = tail {
            return node
        }
        
        var result:Node? = head
        while ((result?.next) != nil) {
            result = result?.next
        }
        return result
    }
    
    
    public var count:Int{
        if var node = head {
            var i = 1
            while case let next? = node.next {
                i += 1
                node = next
            }
            return i
        }else{
            return 0
        }
    }
    
    
    /// 取出固定位置的节点
    ///
    /// - Parameter index: 位置
    /// - Returns: 节点
    public func node(atIndex index:Int) -> Node? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 {
                    return node
                }
                i -= 1
                node = node?.next
            }
        }
            return nil
    }
    
    
    /// 下标方法,直接或去节点值
    ///
    /// - Parameter index: 节点位置
    public subscript(index:Int)->T{
        let node = self.node(atIndex: index)
        assert(node != nil)
        return node!.vaule
    }
    
    
    /// 根据值添加新节点
    ///
    /// - Parameter vaule: 值
    public func append(_ vaule:T) {
        let node = Node(vaule)
        if let lastNode = last {
            node.previous = lastNode
            lastNode.next = node
            self.tail = node
        }else{
            self.head = node
        }
    }
    
    public func append(_ node:Node) {
        self.append(node.vaule)
    }
    
    public func append(_ list:LinkList){
        if list.isEmpty {
            return
        }
        
        var listNode = list.head
        
        while let node = listNode {
            self.append(node)
            listNode = node.next
        }
    }
    
    
    /// 指定位置的前后node,注意这时候获取到的结果相当于已经索求位置上已经插入元素
    ///
    /// - Parameter index: 位置
    /// - Returns: 前一个和后一个
    public func nodeBeforeAndAfter(atIndex index:Int)->(Node?,Node?){
        let node = self.node(atIndex: index)
        return (node?.previous,node)
        
    }
    
    
    /// 在指定位置插入新节点,节点是一个新节点,深复制的
    ///
    /// - Parameters:
    ///   - index: 位置
    ///   - vaule: 值
    public func insert(atInex index:Int,vaule:T) {
//        assert(index > 0)
        if index > count {
            return
        }
        let (previous,next) = nodeBeforeAndAfter(atIndex: index)
        let newNode = Node(vaule)
        
        previous?.next = newNode
        next?.previous = newNode
        
        newNode.next = next
        newNode.previous = previous
        
        if previous == nil {
            self.head = newNode
        }
    }
    
    public func insert(atInex index:Int,node:Node){
        insert(atInex: index, vaule: node.vaule)
    }
    
    public func insert(atIndex index:Int,list:LinkList) {
        if list.isEmpty {
            return
        }
        var (previous,next) = nodeBeforeAndAfter(atIndex: index)
        var headNode = list.head
        var newNode:Node?
        
        while let currentNode = headNode {
            newNode = Node(currentNode.vaule)
            newNode?.previous = previous
            if let prev = previous {
                prev.next = newNode
            }else{
                head = newNode
            }
            
            headNode = headNode?.next
            previous = newNode
        }
        
        previous?.next = next
        next?.previous = previous
    }
    
    
    /// 插入节点,插入的节点是传入参数的浅copy
    ///
    /// - Parameters:
    ///   - atIndex: 位置
    ///   - node: 浅拷贝的节点
    public func insertNode(atIndex index:Int,node:Node) {
        if index > count {
            return
        }
        
        node.previous = nil
        node.next = nil
        
        if count == 0 {
            head = node
            tail = node
        }else{
            if index == 0 {
                node.next = head
                head?.previous = node
                head = node
            }else if index == count{
                node.previous = tail?.previous
                tail?.next = node
                tail = node
            }else{
                let (previous,next) = nodeBeforeAndAfter(atIndex: index)
                node.next = next
                node.previous = previous
                previous?.next = node
                next?.previous = node
            }
        }
    }
    
    
    /// 移除节点
    ///
    /// - Parameter node: 被移除的节点
    /// - Returns: 节点的值
    @discardableResult public func remove(node:Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let previous = prev {
            previous.next = next
        }else{
            self.head = next
        }
        
        if node === tail {
            tail = node.previous
            tail?.next = nil
        }
        next?.previous = prev
        node.previous = nil
        node.next = nil
        return node.vaule
    }
    
    public func bringNodeToHead(node:Node) {
        if node === head {
            return
        }
        
        if node === tail {
            tail = node.previous
            head?.previous = node
            tail?.next = nil
        }else{
            node.next?.previous = node.previous
            node.previous?.next = node.next
        }
        
        node.previous = nil
        node.next = head
        head?.previous = node
        head = node
    }
    
    public func removeAll() {
        self.head = nil
        self.tail = nil
    }
    
     @discardableResult public func remove(atIndex index:Int) -> T {
        let node = self.node(atIndex: index)
        assert(node != nil)
        return self.remove(node: node!)
    }
    
    @discardableResult public func removeLast() -> T? {
        if let node = self.tail {
            return self.remove(node:node)
        }
        
        if let node = self.last {
            return self.remove(node:node)
        }
        
        return nil
    }
    
    public func findNode(atIndex index:Int) -> Node? {
        if count == 0 {
            return nil
        }
        
        var node:Node?
        if count/2 > index {
            node = tail
            for _ in 1...count - (index - 1) {
                node = node?.previous
            }
        }else{
            node = head
            for _ in 1...index {
                node = node?.next
            }
        }
        return node
        
    }
    
    public func allValues() -> [T] {
        var result:[T] = [T]()
        var node = head
        
        while let currentNode = node {
            result.append(currentNode.vaule)
            node = node?.next
        }
        return result
    }
}


// MARK: - 链表的构造器
extension LinkList:ExpressibleByArrayLiteral{
    
    /// 便利构造链表
    ///
    /// - Parameter array: 通过数组构造
    public convenience init(array:[T]) {
        self.init()
        for child in array {
            self.append(child)
        }
    }
    
    /// 便利构造
    ///
    /// - Parameter elements: 直接数组赋值
    public convenience init(arrayLiteral elements:T...) {
        self.init()
        for child in elements {
            self.append(child)
        }
    }
}


// MARK: - 链表的拓展方法:如倒序链表
extension LinkList{
    
    /// 倒转链表,影响原来的链表
    public func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.previous, &currentNode.next)
            head = currentNode
        }
    }
    
    
//    /// 倒转
//    ///
//    /// - Returns: 输出新链表,不影响原来的
//    public func reverse() -> LinkList{
//        var node = head
//        let newList = LinkList()
//        
//        while let currentNode = node {
//            node = currentNode.next
//            let newPre = Node((currentNode.next?.vaule)!)
//            let newNext = Node((currentNode.previous?.vaule)!)
//            let newNode = Node(currentNode.vaule)
//            newNode.previous = newPre
//            newNode.next = newNext
//            newList.append(newNode)
//            newList.head = newNode
//        }
//        return newList
//    }
    
    
    /// 映射
    ///
    /// - Parameter transform: 节点值处理函数
    /// - Returns: 新链表
    public func map<U>(transform:(T)->U) -> LinkList<U> {
        var node = head
        let result = LinkList<U>()
        
        while node != nil {
            result.append(transform((node?.vaule)!))
            node = node?.next
        }
        return result
    }
    
    
    /// 过滤
    ///
    /// - Parameter precidate: 节点值判断函数
    /// - Returns: 新链表
    func fiter(precidate:(T)->Bool) -> LinkList<T> {
        var node = head
        let result = LinkList<T>()
        
        while node != nil {
            if precidate(node!.vaule) {
                result.append(node!.vaule)
            }
            node = node?.next
        }
        return result
    }
}

public protocol FastGeneratorType:IteratorProtocol {
    
    /// 偏移
    func shift()
}

public class LinkListGenerator<T>:FastGeneratorType{
    public typealias Element = LinkList<T>.Node
    var node:Element?
    
    public init(node:Element?) {
        self.node = node
    }
    
    public func next() -> Element? {
        if let node = self.node {
            self.node = node.next
            return node
        }else{
            return nil
        }
    }
    
    /// 偏移要打印的节点
    public func shift() {
        self.node = self.node?.next
    }
}

// MARK: - 提供链表迭代能力
extension LinkList:Sequence{
    public typealias Iterator = LinkListGenerator<T>
    public func makeIterator() -> LinkListGenerator<T> {
        return LinkListGenerator(node: self.head)
    }
}
