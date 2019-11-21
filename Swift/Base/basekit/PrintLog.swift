//
//  PrintLog.swift
//  testSwift
//
//  Created by user on 16/3/11.
//  Copyright © 2016年 testSwift. All rights reserved.
//

import Foundation

public func printLog<T>(messgae:T,
    file: String = __FILE__,
    method: String = __FUNCTION__,
    line: Int = __LINE__){
//        #if DEBUG
            print("log输出的文件:\((file as NSString).lastPathComponent),行号:\(line),方法:\(method)")
//        #endif
}


