//
//  sort.swift
//  testSwift
//
//  Created by user on 16/3/2.
//  Copyright © 2016年 testSwift. All rights reserved.
//

import Foundation

var index = 0


extension Array where Element : Comparable {
    func swap<T>(_ a:inout T,b:inout T){
        (a,b) = (b,a)
    }
    
    mutating func easySort(){
        var min = self[0]
    }
    
    mutating func directSort(){
        
    }
    
    mutating func bubblingSort(){
        var len = self.count
        for(i in 0 ..< self.count - 1){
            for(j in ((0 + 1)...self.count - i - 1).reversed()){
                print("第\(i)次排序,当前数组是\(self)")
                if self[i] > self[j]{
                    swap(&self[i], b: &self[j])
                }
            }
        }
    }
    
    mutating func quick(){
        self.quickSort(0, right: self.count - 1)
        
    }
    
    mutating func threadQuick(){
        self .threadQuick(0, right: self.count - 1)
    }
    
    mutating func threadQuick(_ left:Int,right:Int){
        var left = left, right = right
        
        if left > right
        {
            return
        }
        
        while left < right{
            let pivot = self.pivot(left, end: right)
            
            let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
            
            if pivot - left < right - pivot{
                queue.async(execute: { () -> Void in
                    self.quickSort(left, right: pivot - 1)
                    left = pivot + 1 //尾调优化,减少变量栈深度
                })
            }else{
                queue.async(execute: { () -> Void in
                    self.quickSort(pivot+1, right: right)
                    right = pivot - 1
                })
            }
            
        }

    }
    
    
    mutating func basicQuick(){
    
    }
    
    mutating func quickSort(_ left:Int,right:Int){
        var left = left, right = right
        
        if left > right
        {
            return
        }
        
//        while left < right{
            let pivot = self.pivot(left, end: right)
            
//            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//            if pivot - left < right - pivot{
//                dispatch_async(queue, { () -> Void in
            self.quickSort(left, right: pivot - 1)
            self.quickSort(pivot+1, right: right)

//                    left = pivot + 1 //尾调优化,减少变量栈深度
//                })
//            }else{
//                dispatch_async(queue, { () -> Void in
//                    self.quickSort(pivot+1, right: right)
//                    right = pivot - 1
//                })
//            }
//            
//        }
    }
    
    /**
     优化快排:
     1.首个元素作为曲轴不稳定,可能出现最坏的排序情况,首位中随机数排序
     2.尾掉优化,使用迭代代替递归
     3.优化交换,使用哨兵元素,每个交换操作变成替换操作
     4.多线程
     */
    
    mutating func pivot(_ first:Int,end:Int)->Int{
        var first = first, end = end
        /// 单向排序
                        var index = first - 1
                        for(i in first ..< end) {
                            if self[i] < self[end] {
                                index += 1
                                self.swap(&self[i], b: &self[index])
                            }
                        }
                        index += 1
                        self.swap(&self[end], b: &self[index])
                        return index
        /// 双向排序
//        let pivot = self[first]
//        
//        while first < end {
//            
//            while self[end] >= pivot && first < end {
//                end--
//            }
//            
//            self[first] = self[end]
//            //                                self .swap(&self[first], b: &self[end])
//            
//            
//            while  self[first] < pivot && first < end {
//                first++
//            }
//            //                                self .swap(&self[first], b: &self[end])
//            self[end] = self[first]
//        }
//        self[first] = pivot
//        return first
    }
}


//MARK:定制筛选数组
// 先定义一个实现了 GeneratorType protocol 的类型
// GeneratorType 需要指定一个 typealias Element
// 以及提供一个返回 Element? 的方法 next()
class ReverseGenerator<T>: IteratorProtocol {
    typealias Element = T
    
    var array: [Element]
    var currentIndex = 0
    
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    
    func next() -> Element? {
        if currentIndex < 0{
            return nil
        }
        else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}

// 然后我们来定义 SequenceType
// 和 GeneratorType 很类似，不过换成指定一个 typealias Generator
// 以及提供一个返回 Generator? 的方法 generate()
struct ReverseSequence<T>: Sequence {
    var array: [T]
    
    init (array: [T]) {
        self.array = array
    }
    
    typealias Iterator = ReverseGenerator<T>
    func makeIterator() -> Iterator {
        return ReverseGenerator(array: self.array)
    }
}
