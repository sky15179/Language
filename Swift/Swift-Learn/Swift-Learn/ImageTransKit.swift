//
//  ImageKit.swift
//  Swift-Learn
//
//  Created by 王智刚 on 16/5/1.
//  Copyright © 2016年 w.z.g. All rights reserved.
//

import Foundation
import UIKit

typealias Fiter = (CIImage) ->CIImage
/**
 高斯模糊滤镜 
 
 - parameter radius: 模糊半径
 */
func blur(_ radius:Double) -> Fiter {
    return {image in
        let parameters = [
            kCIInputRadiusKey:radius,
            kCIInputImageKey:image
        ] as [String : Any]
        
        guard let fiter = CIFilter(name:"CIGaussianBlur",withInputParameters: parameters) else{fatalError() }
    
        guard let outImage = fiter.outputImage else{fatalError()}
        
        return outImage
    }
}

/**
 颜色生成滤镜
 */
func colorGenerator(_ color:UIColor) -> Fiter {
    return{ _ in
        guard let c:CIColor = CIColor(cgColor:color.cgColor) else{fatalError()}
        let parameters = [kCIInputColorKey:c]
        guard let fiter = CIFilter(name:"CIConstantColorGenerator",withInputParameters: parameters) else{fatalError()}
        guard let outImage = fiter.outputImage else {fatalError()}
        return outImage
    }
}

/**
 合成滤镜
 
 - parameter overlay: 覆盖的图片
 */
func compositeSourceOver(_ overlay:CIImage) -> Fiter {
    return {image in
        let parameters = [
            kCIInputImageKey:overlay,
            kCIInputBackgroundImageKey:image
        ]
        guard let fiter = CIFilter(name: "CISourceOverCompositing",withInputParameters: parameters) else{fatalError()}
        guard let outImage = fiter.outputImage else{fatalError()}
        return outImage
    }
}

/**
 颜色叠层滤镜
 */
func colorOverlay(_ color:UIColor) -> Fiter {
    return {image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay)(image)
    }
}

/**
 组合滤镜
  */
func composeFilters(_ filter1:@escaping Fiter,_ filter2:@escaping Fiter) -> Fiter {
    return {image in filter2(filter1(image))}
}

/**
 *  重写运算符来实现组合滤镜,注意重写运算符需符合一些特定条件才好
 */
infix operator >>>{associativity left}
func >>>(filter1:@escaping Fiter,filter2:@escaping Fiter) -> Fiter{
    return{image in filter2(filter1(image))}
}

