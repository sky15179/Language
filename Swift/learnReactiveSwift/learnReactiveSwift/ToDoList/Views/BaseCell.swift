//
//  BaseCell.swift
//  learnReactiveSwift
//
//  Created by 王智刚 on 2017/9/28.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import UIKit

public protocol BaseCell: class {
    associatedtype Value
    static var defaultReusableId: String { get }
    func configureWith(value:Value)
}
