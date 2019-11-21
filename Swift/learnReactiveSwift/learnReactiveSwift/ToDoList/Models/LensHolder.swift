//
//  LensHolder.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/30.
//  Copyright © 2017年 王智刚. All rights reserved.
//

public protocol LensObject {}

public struct LensHolder<Object: LensObject> {}

public extension LensObject {
    public static var lens: LensHolder<Self> {
        return LensHolder()
    }
}
