//
//  ViewController.swift
//  Swift-Learn
//
//  Created by user on 16/4/29.
//  Copyright © 2016年 w.z.g. All rights reserved.
//

import UIKit
/**
 交战游戏:1.需要确定自身位置2.开火半径3.不安全半径4.友方安全半径
 */
/**
 *  简化按钮点击事件
 */
//private struct Action {
//    static let clickBtn = #selector(ViewController.clickBtn(_:))
//}

private extension Selector{
    static let clickBtn = #selector(ViewController.clickBtn(_:))
}

typealias Distance = Double



struct Position {
    /// 坐标的x
    var x:Double
    /// 坐标的y
    var y:Double
    
    typealias Region = (Position)->Bool//相当于重命名一个函数闭包
}

extension Position{
    /// 当前坐标的半径
    var length:Double {return sqrt(x*x + y*y)}
    
    func minus(_ p:Position) -> Position {
        return Position(x: x - p.x,y: y - p.y)
    }
}

struct Ship {
    var position:Position
    var firingRange:Distance
    var unSafeRange:Distance
    
}

extension Position{
    /**
     判断距离目标点是否在范围内
     
     - parameter range: 距圆心的距离
     
     - returns: 在或不在
     */
    func inRange(_ range:Distance) -> Bool {
        return length <= range
    }
    
//    // MARK: - 需要一个函数来判断一个点是否在范围内,通简写typealias的形式来闭包实现
//    func pointInRange(position:Position) -> Bool {
//        
//    }
    
    // MARK: - 需要创建,控制和合并区域
    /**
     创建一个以原点为中心的原
     
     - parameter radius: 半径
     */
    func circle(_ radius:Distance) -> Region {
        return { point in point.length <= radius}
    }
    
    /**
     任意中心的圆
     - parameter centre: 偏移量
     */
    func circle2(_ radius:Distance,centre:Position) -> Region {
        return {point in point.minus(centre).length <= radius}
    }
    
    /**
     区域转化函数,可以改变以后区域的位置(不只是圆,还有矩形等)
     
     - parameter regin:  区域
     - parameter offset: 偏移量
     */
    func shift(_ regin:@escaping Region,offset:Position) -> Region {
        return {point in regin(point.minus(offset))}
    }
    
    /**
     反转区域
     
     - parameter region: 区域
     
     - returns: 当前区域求反
     */
    func invert(_ region:@escaping Region) -> Region {
        return { point in !region(point) }
    }
    
    /**
     区域交集
     */
    func intersection(_ region1:@escaping Region,_ region2:@escaping Region) -> Region {
        return {point in region1(point) && region2(point)}
    }
    /**
     *  区域并集
     */
    func union(_ region1:@escaping Region,_ region2:@escaping Region) -> Region {
        return {point in region1(point) || region2(point)}
    }
    /**
     区域与目标区域的反域
     
     - parameter region: <#region description#>
     - parameter minus:  <#minus description#>
     
     - returns: <#return value description#>
     */
    func difference(_ region:@escaping Region,minus:@escaping Region) -> Region {
        return  intersection(region, invert(minus))
    }
}

extension Ship{
    /**
     判断是否有船在范围内
     
     - parameter target: 目标船
     
     */
    func canEngageShip(_ target:Ship) -> Bool {
        let targetPosition = target.position.minus(position)
        let targetDistance = targetPosition.length
        return targetDistance <= firingRange
    }
    
    /**
     避免和过近的敌方交战
     */
    func canSafelyEngageShip(_ target:Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx*dx + dy*dy)
        return targetDistance <= firingRange && targetDistance > unSafeRange
        
    }
    
    /**
     避免以及友方和过近的敌方交战
     */
    func canSafelyEngageShip1(_ target:Ship,friendly:Ship) -> Bool {
        
//        let rangeRegion = 

        let targetDistance = target.position.minus(position).length
        
        let friendlyDistance = target.position.minus(friendly.position).length
        
        return targetDistance <= firingRange && targetDistance > unSafeRange && friendlyDistance > unSafeRange
    }
}

extension Array{
    func fiter(_ includeElement:(Element)->Bool) -> [Element] {
        var result:[Element] = []
        for item in self where includeElement(item) {
            result.append(item)
        }
        return result
    }
    
    func reduce<T>(_ inital:T,combine:(T,Element)->T) -> T {
        var resullt = inital
        for item in self {
            resullt = combine(resullt,item)
        }
        return resullt
    }
    
    func mapUsingReduce<T>(_ transform:(Element)->T) -> [T] {
        return reduce([]){ result,x in
            return result + [transform(x)]
        }
    }
    
    func filterUsingReduce(_ includeElement:(Element)->Bool) -> [Element] {
        return reduce([]){ result,x in
            return includeElement(x) ? result + [x] : result
        }
    }
}

class ViewController: UIViewController {
    func itrateWhile<A>(_ condition:(A)->Bool,inital:A,next:(A)->A?) -> A {
        if let x = next(inital), condition(x) {
            return itrateWhile(condition, inital: x, next: next)
        }
        return inital
    }
    
    func qsort(_ array:[Int]) -> [Int] {
        var array = array
        if array.isEmpty {
            return[]
        }
        let pivot = array.remove(at: 0)
        let lesser = array.filter{$0 < pivot}
        let greater = array.filter{$0 > pivot}
        return qsort(lesser) + [pivot] + qsort(greater)
    }
    
    /**
     普通函数
     */
    func add1(_ x:Int,_ y:Int) -> Int {
        return x+y
    }
    /**
     柯里化方式
     */
    func add2(_ x:Int) -> ((Int)->Int) {
        return{y in return x+y }
    }
    
    /**
     简化柯里函数
     */
    func add3(_ x:Int) -> (Int)->Int {
        return{y in x+y}
    }

    func computeIntArray(_ xs:[Int],transform:(Int)->Int) -> [Int] {
        var result:[Int] = []
        for x in xs {
            result.append(transform(x))
        }
        return result
    }
    
    func doubleArray(_ xs:[Int]) -> [Int] {
        return computeIntArray(xs){x in x * 2}
    }
    
    /**
    错误函数,类型安全不过
     */
//    func isEvenArray(xs :[Int]) -> [Bool] {
//        return computeIntArray(xs){x in x % 2 == 0}
//    }
    
    
    func genericComputeArray<T>(_ xs:[Int],transform:(Int)->T) -> [T] {
        return xs.map(transform)
    }
    
    func map<Element,T>(_ xs:[Element],transform:(Element)->T) -> [T] {
        var result:[T] = []
        
        for x in xs {
            result.append(transform(x))
        }
        return result
    }
    
    func sumUsingReduces(_ xs:[Int]) -> Int {
        return xs.reduce(0){result,x in result + x}
    }
    
    func product(_ xs:[Int]) -> Int {
        return xs.reduce(1, combine:*)
    }
    
    func flatten<T>(_ xss:[[T]]) -> [T] {
        var result:[T] = []
        for item in xss {
            result += item
        }
        return result
    }
    
    func flattenUsingReduce<T>(_ xss:[[T]]) -> [T] {
        return xss.reduce([]){ result,xs in result + xs}
    }
    
    func imageSome() {
        let btn = UIButton(type:.system)
        btn.frame  = CGRect(x: 0, y: 0, width: 200, height: 200)
        btn.frame.size.width += 10
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: .clickBtn, for: .touchUpInside)
        btn.tag = 10
        self.view.addSubview(btn)
        super.viewDidLoad()
        let url = URL(string: "http://www.objc.io/images/covers/16.jpg")
        let image = CIImage(contentsOf: url!)!
        let blurRadius = 5.0
        let blurImage = blur(blurRadius)(image)
        
        let overlayColor = UIColor.red.withAlphaComponent(0.2)
        let overlayImage = colorOverlay(overlayColor)(blurImage)
        
        let myFilter = composeFilters(blur(blurRadius), colorOverlay(overlayColor))
        let result1 = myFilter(image)
        let myFilter2 = blur(blurRadius)>>>colorOverlay(overlayColor)
        let result2 = myFilter2(image)
        
        
        let imageView:UIImageView = UIImageView(image: UIImage(ciImage: overlayImage))
        imageView.frame = CGRect(x: 100,y: 100,width: 100,height: 100)
        self.view.addSubview(imageView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    let exampleFiles = ["Readme.md","helloworld.swift","flappybird.swift"]

    func getSwiftFiels(_ files:[String]) -> [String] {
        var result:[String] = []
        
        for item in files {
            if item.hasPrefix(".swift") {
                result.append(item)
            }
        }
        return result
        
    }
    func getSwiftFiels2(_ files2:[String]) -> [String] {
        return files2.fiter{file in file.hasSuffix(".swift")}
    }
    
    
    override func viewDidLoad() {
       print("字符数组:\(self.getSwiftFiels2(exampleFiles))")
        print("数组和:\(self.sumUsingReduces([2,5,7]))")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickBtn(_ btn:UIButton) {
        print("按钮的tag是:\(btn.tag)")
    }
    
    
}
