//
//  ViewController.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/4.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct ReverseIndexIterator: IteratorProtocol {
        var index: Int
        init<T>(array: [T]) {
            index = array.endIndex-1
        }
        mutating func next() -> Int? {
            guard index >= 0 else { return nil }
            defer { index -= 1 }
            return index
        }
    }
    
    struct ReverseArrayIndices<T>:Sequence {
        let arr:[T]
        init(arr:[T]) {
            self.arr = arr
        }
        
        func makeIterator() -> ReverseIndexIterator {
            return ReverseIndexIterator(array: arr)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 冒泡,局部排序,两两比较
        ///
        /// - Parameter arr: <#arr description#>
        /// - Returns: <#return value description#>
        
//        let arrt = [3,44,38,5,47,15,36,26,27,2,46,4,19,50,48]
//        var waitArr = arrt
//        bubbleSort(arr: &waitArr)
//        print(waitArr)
//        
//        var wait2 = arrt
//        selectionSort(arr: &wait2)
//        print(wait2)
//        
//        var wait3 = arrt
//        shellSort(arr: &wait3)
//        print(wait3)
//        
//        print(mergeSort(arr: arrt))
//        
//        print(quickSort(arr: arrt))
//        
//        var wait4 = arrt
//        quickSort1(arr: &wait4, low: 0, high: wait4.count - 1)
//        print(wait4)
//        
//        var wait5 = arrt
//        quickSort3(arr: &wait5, low: 0, high: wait5.count - 1)
//        print(wait5)
//        
//        var wait6 = arrt
//        heapSort(arr: &wait6)
//        print(wait6)

    
    }

    func swiftMianShi() {
        DispatchQueue.main.async {
            //主要还是优先看执行的队列是并行队列还是串行队列,main是串行队列,global是并行
            DispatchQueue.global().async(execute: {
                sleep(2)
                print(1)
            })
            print(2)
            DispatchQueue.global().async(execute: {
                print(3)
            })
        }
        sleep(1)
        print("先暂停")
        let queue:OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        let operation:BlockOperation = BlockOperation {
            let operation2:BlockOperation = BlockOperation{
                sleep(1)
                print(3)
            }
            queue.addOperation(operation2)
            
            sleep(2)
            print(1)
            let operation1:BlockOperation = BlockOperation{
                print(2)
            }
            queue.addOperation(operation1)
        }
        queue.addOperation(operation)

    }



    /// 两两比较先把合适,优化,后续开始排序,使用临时量在有序的情况下不再进行遍历操作
    ///
    /// - Parameter arr: <#arr description#>
    func bubbleSort(arr:inout [Int]){
        var status:Bool = true
        
        if status == true {
            for i in 0...arr.count - 1{
                status = false
                for j in (i...arr.count - 1).reversed(){
                    if j >= 1 {
                        if arr[j - 1] > arr[j] {
                            swap(&arr[j], &arr[j - 1])
                            status = true
                        }
                    }
                }
            }
        }
    }
    
    
    func selectionSort( arr:inout [Int]){
        for i in 0 ..< arr.count - 1 {
            var min = i
            for j  in i+1 ..< arr.count {
                if arr[min] > arr[j] {
                    min = j
                }
            }
            let temp = arr[min]
            arr[min] = arr[i]
            arr[i] = temp
            
        }
    }
    
    
    /// 维护一个已排序的数组,遍历去除每个元素直接插入到排序数组中
    ///
    /// - Parameter arr: <#arr description#>
    func inserSort(arr:inout [Int]) {
        for i in 1..<arr.count {
            let key = arr[i]
            var j = i - 1
            while j > 0 && arr[j] > key {
                arr[j+1] = arr[j]
                j -= 1
            }
            arr[j + 1] = key
        }
    }
    
    
    /// 希尔排序,非稳定,直接插入的升级,插入的跳跃量是1,而希尔是多个跳量插入
    ///
    /// - Parameter arr: <#arr description#>
    func shellSort(arr:inout [Int]) {
        var j:Int
        var gap = arr.count/2
        
        while gap > 0 {
            for i in 0..<gap {
                j = i + gap
                while j < arr.count {
                    if arr[j] < arr[j - gap] {
                        var k = j - gap
                        let temp = arr[j]
                        
                        while k >= 0 && arr[k] > temp  {
                            arr[k+gap] = arr[k]
                            k -= gap
                        }
                        arr[k + gap] = temp
                    }
                    j += gap
                }
            }
            gap /= 2
        }
    }
    
    func shell2(arr:inout [Int]) {
        var j:Int
        
        var gap = arr.count/2
        
        while gap > 0 {
            for i in 0..<gap {
                j = gap + i
                while j < arr.count {
                    var k = j - gap
                    let tmp = arr[j]
                    while k>0 && tmp < arr[k] {
                        arr[k+gap] = arr[k]
                        k -= gap
                    }
                    arr[k+gap] = tmp
                }
                j += gap
            }
            gap /= 2
        }
        
    }
    
    
    /// 归并,分治,递归
    ///
    /// - Parameter arr: <#arr description#>
    /// - Returns: <#return value description#>
    func mergeSort(arr:[Int]) -> [Int] {
        guard arr.count > 1 else { return arr}
        let middleIndex = arr.count/2
        let leftArray = mergeSort(arr:Array(arr[0..<middleIndex]))
        let rightArray = mergeSort(arr: Array(arr[middleIndex..<arr.count]))
        return merge(leftPiple: leftArray, rightPiple: rightArray)
    }
    
    func merge(leftPiple:[Int],rightPiple:[Int])->[Int] {
        var orderPiple:[Int] = []
        var leftIndex = 0
        var rightIndex = 0
        
        
        if orderPiple.capacity < leftPiple.capacity + rightPiple.capacity {
            //避免数组扩容的时候重复申请内存
            orderPiple.reserveCapacity(leftPiple.capacity + rightPiple.capacity)
        }
        
        while leftIndex < leftPiple.count && rightIndex < rightPiple.count {
            if leftPiple[leftIndex] < rightPiple[rightIndex] {
                orderPiple.append(leftPiple[leftIndex])
                leftIndex += 1
            }else if leftPiple[leftIndex] > rightPiple[rightIndex]{
                orderPiple.append(rightPiple[rightIndex])
                rightIndex += 1
            }else{
                orderPiple.append(leftPiple[leftIndex])
                leftIndex += 1
                orderPiple.append(rightPiple[rightIndex])
                rightIndex += 1
            }
        }
        
        while leftIndex < leftPiple.count {
            orderPiple.append(leftPiple[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < rightPiple.count {
            orderPiple.append(rightPiple[rightIndex])
            rightIndex += 1

        }
        
        return orderPiple
    }
    
    //单个函数体循环版本归并
    func mergeSortBottomUp(_ a:[Int],_ isOrderedBefore:(Int,Int)->Bool) -> [Int] {
        //不用递归的就得使用特殊数据结构来处理
        let count = a.count
        
        var result = [a,a]
        var d = 0
        var width = 1
        
        while width < count {
            var i = 0
            while i < count {
                var j = i
                var l = i
                var r = i + width
                
                let lmax = min(l + width, count)
                let rmax = min(r + width, count)
            
                while l<lmax && r<rmax {
                    if isOrderedBefore(result[d][l],result[d][r]) {
                        result[1-d][j] = result[d][l]
                        l += 1
                    }else{
                        result[1-d][j] = result[d][r]
                        r += 1
                    }
                    j += 1
                }
                
                while l < lmax {
                    result[1-d][j] = result[d][l]
                    l += 1
                    j += 1
                }
                
                while r < rmax {
                    result[1-d][j] = result[d][r]
                    r += 1
                    j += 1
                }
                
                i += width * 2
            }
            width *= 2
            d = 1 - d
        }
        
        return result[d]
    }
    
    func quickSort(arr:[Int]) -> [Int] {
        guard arr.count > 1 else {
            return arr
        }
        
        let pivot = arr[arr.count/2]
        let less = arr.filter{$0<pivot}
        let equal = arr.filter{$0==pivot}
        let great = arr.filter{$0>pivot}
        return quickSort(arr:less) + equal + quickSort(arr:great)
    }
    
    func partitionWithLomuto(_ array:inout [Int],_ low:Int,high:Int) -> Int{
        let pivot = array[high]
        
        var i = low
        for j in low..<high {
            if array[j] <= pivot  {
                (array[i],array[j]) = (array[j],array[i])
                i += 1
            }
        }
        
        (array[i],array[high]) = (array[high],array[i])
        return i
    }
    
    func quickSort1(arr:inout [Int],low:Int,high:Int) {
        if low < high {
            let pivot = partitionWithLomuto(&arr, low, high: high)
            quickSort1(arr: &arr, low: low, high: pivot - 1)
            quickSort1(arr: &arr, low: pivot + 1 , high: high)
        }
    }
    
    
    /// 霍尔区分函数,更高效
    ///
    /// - Parameters:
    ///   - a: <#a description#>
    ///   - low: <#low description#>
    ///   - high: <#high description#>
    /// - Returns: <#return value description#>
    func partitionWithHoare(_ a: inout [Int], low: Int, high: Int) -> Int {
        let povit = a[low]
        var i = low - 1
        var j = high + 1
        //直接找出,中间区分点左右两端,不用做那么多次交换
        while true {
            repeat {i += 1} while a[i] < povit
            repeat {j -= 1} while a[i] > povit
            
            if i < j {
                swap(&a[i], &a[j])
            }else{
                return j
            }
        }
    }
    
    func quickSort3(arr:inout [Int],low:Int,high:Int) {
        if low < high {
            let pivot = partitionWithHoare(&arr, low: low, high: high)
            quickSort3(arr: &arr, low: low, high: pivot - 1)
            quickSort3(arr: &arr, low: pivot + 1 , high: high)
        }
    }

    
    func random(min:Int,max:Int) -> Int {
        assert(min < max)
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
    /// 通过随机避免最差情况
    ///
    /// - Parameters:
    ///   - arr: <#arr description#>
    ///   - low: <#low description#>
    ///   - high: <#high description#>
    func quickSort4(arr:inout [Int],low:Int,high:Int) {
        if low < high {
            let pivotIndex = random(min: low, max: high)
            (arr[pivotIndex], arr[high]) = (arr[high], arr[pivotIndex])

            let pivot = partitionWithLomuto(&arr, low, high: high)
            quickSort1(arr: &arr, low: low, high: pivot - 1)
            quickSort1(arr: &arr, low: pivot + 1 , high: high)
        }
    }
    
    //在优化,排序三数取中
    func takeMiddle(arr:inout [Int]) {
        let m = arr[arr.count/2]
        if  arr[0] > arr[arr.count - 1]{
            swap(&arr[0], &arr[arr.count - 1])
        }
        
        if  arr[m] < arr[0]{
            swap(&arr[0], &arr[m])
        }
        
        if  arr[m] > arr[arr.count - 1]{
            swap(&arr[m], &arr[arr.count - 1])
        }

    }
    
    func heapSort(arr:inout [Int]) {
        func buildHeap(arr:inout [Int]){
            let length = arr.count
            let heapSize = length
            var nonleaf = length/2 - 1
            while nonleaf > 0 {
                heapify(arr: &arr, i: nonleaf, heapSize: heapSize)
                nonleaf -= 1
            }
            
        }
        
        //数组构建最小堆
        func heapify(arr:inout [Int],i:Int,heapSize:Int){
            var smallest = i
            let left = 2*i + 1
            let right = 2*i + 2
            
            if left < heapSize {
                if arr[i] > arr[left] {
                    smallest = left
                }else{
                    smallest = i
                }
            }
            
            if right < heapSize {
                if arr[smallest] > arr[right] {
                    smallest = right
                }
            }
            
            if smallest != i {
                var temp: Int
                temp = arr[i]
                arr[i] = arr[smallest]
                arr[smallest] = temp
                heapify(arr: &arr,i: smallest,heapSize: heapSize)
            }
        }
        
        func internalSort(arr:inout [Int]){
            var heapsize = arr.count
            buildHeap(arr: &arr)
            for _ in 0 ..< arr.count - 1 {
                var temp: Int
                temp = arr[0]
                arr[0] = arr[heapsize - 1]
                arr[heapsize - 1] = temp
                heapsize = heapsize - 1
                heapify(arr: &arr, i: 0, heapSize: heapsize)
            }
        }
        internalSort(arr: &arr)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class Student {
    var name:String?
    
}

func test() {
    //
    //        var arr:[Student?] = []
    //        var s1:Student?
    //
    //        for index in 0...4 {
    //            let s = Student()
    //            if index == 0 {
    //                s1 = s
    //            }
    //            print("学生的内存地址:\(Unmanaged.passRetained(s as AnyObject).toOpaque())")
    //            arr.append(s)
    //        }
    //        //class是值类型的,直接赋值是引用拷贝,修改原始数据会影响到数组内的数据,但是设置原始为nil的时候,又没有影响到数组内的数据
    //        var stuFromArr0 = arr[0]
    //        s1?.name = "s1"
    //
    //        print("第一个学生的地址:\(Unmanaged.passRetained(s1!).toOpaque())")
    //        s1 = nil
    //        print("取出来的地址:\(Unmanaged<AnyObject>.passRetained(stuFromArr0!).toOpaque())")
    //        stuFromArr0 = nil
    //        print(s1?.name)
    //        print(stuFromArr0?.name)
    
    
    let array = [1,2,3,4,5,6]
    //        //ReverseArrayIndices 直接使用就会调用它的递归函数
    //        let reverseElements = ReverseArrayIndices(arr: array).map {
    //            array[$0]
    //        }
    //        for x in reverseElements {
    //            print("Element is \(x)")
    //        }
    print(Array(array.smaller()))
    
}


extension UIView{
    
    /// 计算view的子类树中满足条件的个数
    ///
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#return value description#>
    public func count(predicate:(UIView)->Bool) -> Int {
        var sum = 0
        var views = Array<UIView>()
        var currentView = self
        views.append(currentView)
        
        while views.count > 0 {
            currentView = views.removeFirst()
            for childView in currentView.subviews {
                if predicate(childView){
                    views.append(childView)
                    sum += 1
                }
            }
        }
        return sum
    }
}

