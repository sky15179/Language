//
//  WebImage.swift
//  WebImage
//
//  Created by 王智刚 on 2020/7/7.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit

//MARK: weak代理

final class WeakProxy: NSObject {
    private(set) weak var target: AnyObject?
    
    init(target: AnyObject?) {
        self.target = target
    }
    
    override class func isProxy() -> Bool {
        return true
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target?.forwardingTarget(for: aSelector)
    }
}

//MARK: 异步Operation重写

//MARK: 下载核心
/*
 */

final class Cache {
    
}

final class DownloadImage {
    func download(url: String) {
        let task = URLSessionDownloadTask()
    }
}

final class ImagePrefetch {
    
}

final class AImage {
    //加载优化
    func asyncLoadImage(block: @escaping ((UIImage?, Bool) -> Void)) {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "testImge", ofType: "png") {
                let image = UIImage(contentsOfFile: path)
                DispatchQueue.main.sync {
                    block(image, true)
                }
            } else {
                block(nil, false)
            }
        }
    }
    
    //解压优化：异步强制解压为位图，图片处理时注意有效性（宽，高）
    func unpack(image: CGImage, context: CGContext) {
//        CGBitmapContextCreate
        CGContext(data: <#T##UnsafeMutableRawPointer?#>, width: <#T##Int#>, height: <#T##Int#>, bitsPerComponent: <#T##Int#>, bytesPerRow: <#T##Int#>, space: <#T##CGColorSpace#>, bitmapInfo: <#T##UInt32#>)
    }
}



//MARK: 业务支持

extension UIImageView {
    func set_image(url: String) {
    }
}
