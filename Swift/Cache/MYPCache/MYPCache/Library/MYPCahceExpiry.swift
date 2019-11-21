//
//  MYPCahceExpiry.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/31.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation

/// 过期相关
public enum MYPCahceExpiry {
    case never
    case seconds(TimeInterval)
    case date(Date)
    
    public var date: Date {
        switch self {
        case .never:
            return Date(timeIntervalSince1970: 60 * 60 * 24 * 365 * 68)
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .date(let date):
            return date
        }
    }
    
    public var time: TimeInterval {
        switch self {
        case .never:
            return Double.greatestFiniteMagnitude
        case .seconds(let seconds):
            return seconds
        case .date(let date):
            return date.timeIntervalSinceNow
        }
    }
    
    public var isExpired: Bool {
        return date.inThePast
    }
}
