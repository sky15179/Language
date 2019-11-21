//: Playground - noun: a place where people can play
//链表,双向链表LRU算法,单链表,循环链表
/*
 基本结构
 */

import UIKit

var str = "Hello, playground"

public final class LinkList<T>{
    public class LinkListNode<T>{
        var vaule:T
        var next:LinkListNode?
        weak var previous:LinkListNode?//双向链表的前置节点
        
        public init(vaule:T) {
            self.vaule = vaule
        }
    }
    
    public typealias Node = LinkListNode<T>
    
    fileprivate var head:Node?
    
    public init(){}
}

extension LinkList{
    /// 判空
    public var isEmpty:Bool{
        return head == nil
    }
    
    /// 头一个
    public var first:Node?{
        return head
    }
    
    /// 最后一个
    public var last:Node?{
        if var node = head {
            while  case let next? = node.next {
                node = next
            }
            return node
        }else{
            return nil
        }
    }
    
    
    /// 链表个数
    public var count:Int{
        if var node = head {
            var c = 1
            while case let next? = node.next {
                node = next
                c += 1
            }
            return c
        }else{
            return 0
        }
    }
    
    
    /// 某个位置上的node
    ///
    /// - Parameter index: <#index description#>
    /// - Returns: <#return value description#>
    public func node(atIndex index:Int)->Node?{
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
    
    
    /// index直接取链表值
    ///
    /// - Parameter index: <#index description#>
    public subscript(index:Int)->T{
        let node = self.node(atIndex: index)
        assert(node != nil)
        return node!.vaule
    }
    
    func append(_ vaule:T) {
        let node = Node(vaule: vaule)
        self.append(node)
        
    }
    
    
    /// 添加node
    ///
    /// - Parameter node: <#node description#>
    public func append(_ node:Node){
        let newNode = LinkListNode(vaule: node.vaule)
        if let lastNode = last {
            lastNode.next = newNode
            newNode.previous = lastNode
        }else{
            head = newNode
        }
    }
    
    /// 添加链表
    ///
    /// - Parameter list: <#list description#>
    public func append(_ list:LinkList){
        var nodeCopy = list.head
        while let node = nodeCopy {
            self.append(node)
            nodeCopy = node.next
        }
    }
    
    private func nodesBeforeAndAfter(index:Int)->(Node?,Node?){
        assert(index >= 0)
        var i = index
        var next = head
        var prev:Node?
        
        while next != nil && i > 0 {
            i -= 1
            prev = next
            next = next!.next
        }
        assert(i == 0)
        return (prev,next)
    }
    
    public func insert(_ node:Node,atInded index:Int) {
        let (before,after) = self .nodesBeforeAndAfter(index: index)
        let newNode = Node(vaule: node.vaule)
        
        before?.next = newNode
        after?.previous = newNode
        
        if before == nil {
            head = newNode
        }
    }
    
    public func insert(_ vaule:T,atIndex index:Int) {
        let (before,after) = self .nodesBeforeAndAfter(index: index)
        let newNode = Node(vaule: vaule)
        
        newNode.previous = before
        newNode.next = after
        
        before?.next = newNode
        after?.previous = newNode
        
        if before == nil {
            head = newNode
        }

    }
    
    public func insert(_ list:LinkList,atIndex index:Int) {
        if list.isEmpty {
            return
        }
        
        var (prev,next) = self.nodesBeforeAndAfter(index: index)
        var nodeToCopy = list.head
        var newNode:Node?
        
        while let node = nodeToCopy {
            newNode = Node(vaule: node.vaule)
            newNode?.previous = prev
            if let previous = prev {
                previous.next = newNode
            }else{
                self.head = newNode
            }
            
            nodeToCopy = nodeToCopy?.next
            prev = newNode
        }
        
        prev?.next = next
        next?.previous = prev
//        if list.isEmpty {
//            return
//        }
//        let (previous,next) = self.nodesBeforeAndAfter(index: index)
//        previous?.next = list.head
//        next?.previous = list.last
//        
//        list.head?.previous = previous
//        list.last?.next = next

    }
    
    public func removeAll() {
        head = nil
    }
    
    @discardableResult public func remove(node:Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let previous = prev {
            previous.next = next
        }else{
            self.head = next
        }
        
        next?.previous = prev
        node.previous = nil
        node.next = nil
        return node.vaule
    }
    
    @discardableResult public func removeLast() -> T {
        assert(!isEmpty)
        return remove(node: self.last!)
    }
    
    @discardableResult public func remove(atIndex index:Int) -> T {
        let node = self.node(atIndex: index)
        assert(node != nil)
        return remove(node: node!)
    }
}

extension LinkList:CustomStringConvertible{
    public var description: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.vaule)"
            node = node!.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }

}


// MARK: - 链表结构变化方法
extension LinkList{
    public func reverse() {
        var node = head
        while let currentNodo = node {
            node = currentNodo.next
            swap(&currentNodo.previous, &currentNodo.next)
            head = currentNodo
        }
    }
}


// MARK: - 拓展的链表方法
extension LinkList{
    public func map<U>(transform:(T)->U) -> LinkList<U> {
        let result = LinkList<U>()
        var node = head
        while node != nil {
            result.append(transform(node!.vaule))
            node = node!.next
        }
        
        return result
    }
    
    public func fiter(predicate:(T)->Bool) -> LinkList<T> {
        let result = LinkList<T>()
        var node = head
        
        while node != nil {
            if predicate(node!.vaule) {
                result.append(node!)
            }
            node = node!.next
        }
        return result
    }
}

// MARK: - 初始化方法
extension LinkList{
    convenience init(array:Array<T>) {
        self.init()
        for element in array{
            self.append(element)
        }
    }
}

// MARK: - ExpressibleByArrayLiteral
extension LinkList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        
        for element in elements {
            self.append(element)
        }
    }
}

var arr = [1,4,5,3,2,6,9]

var linkList = LinkList(array: arr)
var insertList:LinkList<Int> = [20,30]

linkList.insert(10, atIndex: 0)
linkList.head?.vaule
linkList.insert(insertList, atIndex: 0)
linkList.head?.vaule
for index in 0...5 {
    print(index)
}

class student{

}