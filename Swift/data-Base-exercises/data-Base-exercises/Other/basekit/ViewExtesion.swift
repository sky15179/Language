//
//  ViewExtesion.swift
//  OnceAgain
//
//  Created by user on 15/9/29.
//  Copyright © 2015年 w.z.g. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var x : CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var y : CGFloat {
        set{
            self.frame.origin.y = newValue
        }
        
        get {
            return (self.frame.origin.y)
        }
    }
    
    public var width : CGFloat {
        set {
            self.frame.size.width = newValue
        }
        
        get {
            return (self.frame.size.width)
        }
    }
    
    public var height : CGFloat {
        set {
            self.frame.size.height = newValue
        }
        
        get {
            return (self.frame.size.height)
        }
    }
    
    public var size : CGSize {
        set {
            self.frame.size = newValue;
        }
        
        get {
            return self.frame.size
        }
    }
    
    public var origin : CGPoint {
        set {
            self.frame.origin = newValue
        }
        
        get {
            return self.frame.origin
        }
    }
    
    public var centerX : CGFloat {
        set {
            self.center.x = newValue
        }
        
        get {
            return (self.center.x)
        }
    }
    
    public var centerY : CGFloat {
        set {
            self.center.y = newValue
        }
        
        get {
            return (self.center.y)
        }
    }
}


