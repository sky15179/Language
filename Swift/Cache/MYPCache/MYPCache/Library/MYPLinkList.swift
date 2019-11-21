//
//  MYPLinkList.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/11/2.
//  Copyright © 2017年 王智刚. All rights reserved.
//  双向链表

import UIKit

public final class MYPLinkList<T: Equatable> {
    
    /// 链表节点
    public class LinkListNode<T> {
        var value: T
        var next: LinkListNode?
        weak var previous: LinkListNode?
        
        init(_ value: T) {
            self.value = value
        }
    }

    /// 链表基本结构
    public typealias Node = LinkListNode<T>
    var headNode: Node?
    var tailNode: Node?
    
    public init() {}
}

public extension MYPLinkList {
    
    //MARK: Property
    /// 链表是否为空
    public var isEmpty: Bool {
        return self.headNode == nil
    }
    
    /// 头结点
    public var first: Node? {
        return self.headNode
    }
    
    /// 尾节点
    public var last: Node? {
        return self.tailNode
    }
    
    /// 节点数量
    public var count: UInt {
        return self.reduce(0) { (result, ele) -> UInt in
            return result + 1
        }
    }
    //MARK: 添加相关
    /// 添加节点
    ///
    /// - Parameter value: 根据值
    public func append(_ value: T) {
        let newNode = Node(value)
        if let tail = self.tailNode {
            tail.next = newNode
            newNode.previous = tail
            self.tailNode = newNode
        } else {
            self.headNode = newNode
            self.tailNode = newNode
        }
    }
    
    /// 添加节点
    ///
    /// - Parameter value: 根据节点
    public func append(_ node: Node) {
        append(node.value)
    }
    
    /// 聚合链表
    ///
    /// - Parameter linkList: 拼接的第二段链表
    public func append(_ linkList: MYPLinkList) {
        if linkList.isEmpty { return }
        
        var node = linkList.headNode
        while let curNode = node {
            append(curNode)
            node = curNode.next
        }
    }
    
    //MARK: 查询相关
    
    /// 从链表中取出某节点的值
    ///
    /// - Parameter index: 从头结点开始的偏移量
    /// - Returns: 节点存储的值
    public func value(atIndex index: UInt) -> T? {
        return node(atIndex: index)?.value
    }
    
    /// 获取列表中所有节点的值
    ///
    /// - Note: nil也会被放进去
    public func allValues() -> [T?] {
        return reduce([T?]()) {
            $0 + [$1.value]
        }
    }
    
    /// 从链表中取出某节点的值
    ///
    /// - Parameter index: 从头结点开始的偏移量
    /// - Returns: 节点
    public func node(atIndex index: UInt) -> Node? {
        if index >= 0 {
            var node = headNode
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node?.next
            }
        }
        return nil
    }
    
    /// 指定位置的前后node,注意这时候获取到的结果相当于已经所求位置上已经插入元素
    ///
    /// - Parameter index: 位置
    /// - Returns: 前一个和后一个
    public func nodeBeforeAndAfter(atIndex index: UInt) -> (Node?, Node?) {
        let node = self.node(atIndex: index)
        return (node?.previous, node)
    }
    
    /// 下标方法
    ///
    /// - Parameter index: 位置
    public subscript(index: UInt) -> T? {
        return node(atIndex: index)?.value
    }
    
    //MARK: 删除相关
    /// 移除节点
    ///
    /// - Parameter index: 位置
    /// - Returns: 被移除的节点
    @discardableResult func remove(atIndex index: UInt) -> Node? {
        if index >= 0, index < count {
            var i = index
            var node = headNode
            while node != nil {
                if i == 0 {
                    if let node = node {
                        remove(node: node)
                        return node
                    }
                }
                node = node?.next
                i -= 1
            }
        }
        return nil
    }
    
    /// 根据值移除节点
    func remove(value: T) {
        self.forEach { node in
            if node.value == value {
                remove(node: node)
            }
        }
    }
    
    /// 移除节点
    ///
    /// - Parameter node: 节点
    /// - Returns: 移除的节点的值
    @discardableResult func remove(node: Node) -> T? {
        if let pre = node.previous {
            pre.next = node.next
        } else {
            self.headNode = node.next
        }
        
        if self.tailNode === node {
            self.tailNode = node.previous
            self.tailNode?.next = nil
        }
        
        node.next?.previous = node.previous
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    /// 移除节点
    ///
    /// - Parameter index: 位置
    /// - Returns: 被移除的节点存储的值
    @discardableResult public func remove(atIndex index: UInt) -> T? {
        return remove(atIndex: index)?.value
    }
    
    /// 清空链表
    public func removeAll() {
        self.headNode = nil
        self.tailNode = nil
    }
    
    /// 移除首节点
    @discardableResult public func removeFirst() -> Node? {
        return remove(atIndex: 0)
    }
    
    /// 移除尾节点
    @discardableResult public func removeLast() -> Node? {
        return remove(atIndex: count - 1)
    }
    
    //MARK: 插入相关
    
    /// 插入节点
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - index: 位置
    /// - Note: 注意这中插入的方式对被插入的节点来说是深复制处理的
    public func insert(node: Node, index: UInt) {
        insert(value: node.value, index: index)
    }
    
    /// 插入节点
    ///
    /// - Parameters:
    ///   - value: 节点值
    ///   - index: 位置
    public func insert(value: T, index: UInt) {
        if index >= count { return }
        let newNode = Node(value)
        let (pre, next) = nodeBeforeAndAfter(atIndex: index)
        pre?.next = newNode
        next?.previous = newNode
        newNode.next = next
        newNode.previous = pre
        if pre == nil {
            headNode = newNode
        }
        
        if next == nil {
            tailNode = newNode
        }
    }
    
    /// 插入节点,插入的节点是传入参数的浅copy
    ///
    /// - Parameters:
    ///   - atIndex: 位置
    ///   - node: 浅拷贝的节点
    public func insertNode(atIndex index:UInt, node:Node) {
        if index > count { return }
        
        node.previous = nil
        node.next = nil
        
        if count == 0 {
            headNode = node
            tailNode = node
        }else{
            if index == 0 {
                node.next = headNode
                headNode?.previous = node
                headNode = node
            }else if index == count - 1{
                node.previous = tailNode?.previous
                tailNode?.next = node
                tailNode = node
            }else{
                let (previous, next) = nodeBeforeAndAfter(atIndex: index)
                node.next = next
                node.previous = previous
                previous?.next = node
                next?.previous = node
            }
        }
    }
    
    /// 在链表中插入另一个链表
    ///
    /// - Parameters:
    ///   - index: 插入位置
    ///   - list: 链表
    public func insert(atIndex index:UInt, list: MYPLinkList) {
        if list.isEmpty { return }
        if index > count { return }
        
        var (pre, next) = nodeBeforeAndAfter(atIndex: index)
        let head2 = list.headNode
        var newNode:Node?
        
        while let currentNode = head2 {
            newNode = Node(currentNode.value)
            newNode?.previous = pre
            if let prev = pre {
                prev.next = newNode
            }else{
                headNode = newNode
            }
            
            headNode = headNode?.next
            pre = newNode
        }
        pre?.next = next
        next?.previous = pre
    }
    
    //MARK: 移动相关
    
    /// 将某个节点移动到头
    ///
    /// - Parameter node: 节点
    public func bringNodeToHead(node: Node) {
        if headNode === node {
            return
        }
        
        if tailNode === node {
            tailNode = node.previous
            tailNode?.next = nil
        } else {
            node.previous?.next = node.next
            node.next?.previous = node.previous
        }
        
        node.next = headNode
        node.previous = nil
        headNode?.previous = node
        headNode = node
    }
}

// MARK: - 提供链表迭代的能力
extension MYPLinkList: Sequence {
    public typealias Iterator = MYPLinkListGenerator<T>
    public func makeIterator() -> MYPLinkListGenerator<T> {
        return MYPLinkListGenerator(node: self.headNode)
    }
}

public protocol MYPFastGeneratorType: IteratorProtocol {
    
    /// 元素偏移
    func shift()
}

public class MYPLinkListGenerator<T: Equatable>: MYPFastGeneratorType {
    public typealias Element = MYPLinkList<T>.Node
    private var node: Element?
    init(node: Element?) {
        self.node = node
    }
    
    public func next() -> Element? {
        if let node = self.node {
            defer {
                self.node = node.next
            }
            return self.node
        } else {
            return nil
        }
    }
    
    public func shift() {
        self.node = self.node?.next
    }
}

extension MYPLinkList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = headNode
        while node != nil {
            s += "\(String(describing: node?.value))"
            node = node?.next
            if node != nil { s += ","}
        }
        return s + "]"
    }
}

// MARK: - 链表便利构造方法
extension MYPLinkList: ExpressibleByArrayLiteral {
    public convenience init(array: [T]) {
        self.init()
        array.forEach { child in
            self.append(child)
        }
    }
    
    public convenience init(arrayLiteral elements: T...) {
        self.init(array: elements)
    }
}
