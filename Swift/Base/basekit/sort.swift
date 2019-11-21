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
    func swap<T>(inout a:T,inout b:T){
        (a,b) = (b,a)
    }
    
    mutating func easySort(){
        var min = self[0]
    }
    
    mutating func directSort(){
        
    }
    
    mutating func bubblingSort(){
        var len = self.count
        for(var i = 0;i < self.count - 1;i++){
            for(var j = self.count - i - 1;j > 0;j--){
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
    
    mutating func threadQuick(var left:Int,var right:Int){
        
        if left > right
        {
            return
        }
        
        while left < right{
            let pivot = self.pivot(left, end: right)
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            if pivot - left < right - pivot{
                dispatch_async(queue, { () -> Void in
                    self.quickSort(left, right: pivot - 1)
                    left = pivot + 1 //尾调优化,减少变量栈深度
                })
            }else{
                dispatch_async(queue, { () -> Void in
                    self.quickSort(pivot+1, right: right)
                    right = pivot - 1
                })
            }
            
        }

    }
    
    
    mutating func basicQuick(){
    
    }
    
    mutating func quickSort(var left:Int,var right:Int){
        
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
    
    mutating func pivot(var first:Int,var end:Int)->Int{
        /// 单向排序
                        var index = first - 1
                        for(var i = first; i < end; i++) {
                            if self[i] < self[end] {
                                index++
                                self.swap(&self[i], b: &self[index])
                            }
                        }
                        index++
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
class ReverseGenerator<T>: GeneratorType {
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
struct ReverseSequence<T>: SequenceType {
    var array: [T]
    
    init (array: [T]) {
        self.array = array
    }
    
    typealias Generator = ReverseGenerator<T>
    func generate() -> Generator {
        return ReverseGenerator(array: self.array)
    }
}