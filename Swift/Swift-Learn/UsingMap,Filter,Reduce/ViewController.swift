//
//  ViewController.swift
//  UsingMap,Filter,Reduce
//
//  Created by 王智刚 on 16/6/30.
//  Copyright © 2016年 w.z.g. All rights reserved.
//

import UIKit

struct City {
    let name :String
    let population : Int
}

extension City{
    func cityByScalingPopution() -> City {
        return City(name: name,population: 1000 * population)
    }
}


class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pairs = City(name: "pairs",population: 2241)
        let beijing = City(name: "北京",population: 3165)
        let tianjin = City(name: "天津",population: 827)
        let shanghai = City(name: "上海",population: 3562)
        let cities = [pairs,beijing,tianjin,shanghai]
        let result = cities.filter { $0.population > 1000 }
            .map { $0.cityByScalingPopution() }
            .reduce("City: Population") { result, c in
                return result + "\n" + "\(c.name): \(c.population)"
        }
        
        print("\(result)")
        
        let cities2 = ["beijing":2231,"shanghai":3621,"tianjin":312]
        
        let shanghai2 = cities2["shanghai"] ?? "没有"
        
        
        if let beijingPopulation:Int = cities2["beijing"] {
            print("populaiton:\(beijingPopulation * 1000)")
        }else{
            print("unknow")
        }
    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
//        cities.filter{$0.population > 1000}.map{$0.cityByScalingPopution()}.reduce("City:Population"){
//            result,x in
//            return result + "\n" + "\(x.name)\(x.population)"
//        }
        
    }




