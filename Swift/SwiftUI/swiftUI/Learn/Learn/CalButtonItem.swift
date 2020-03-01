//
//  CalButtonItem.swift
//  Learn
//
//  Created by 王智刚 on 2020/3/1.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

enum CalButtonItem {
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalButtonItem: Hashable {}
extension CalButtonItem {
    var size: CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
    var bgColorName: String {
        switch self {
        case .digit(_), .dot: return "digitBackground"
        case .op(_): return "operatorBackground"
        case .command(_): return "commandBackground"
        }
    }
    var title: String {
        switch self {
        case .digit(let number): return "\(number)"
        case.dot: return "."
        case.op(let rop): return rop.rawValue
        case .command(let c): return c.rawValue
        }
    }
}
