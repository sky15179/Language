//
//  DiskCache.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/17.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation
import QuartzCore

class DiskCacheObject: LRUObj {
    var key: String = ""
    var cost: Int = 0
    var date = Date()
    
    init(key:String,cost:Int = 0,date:Date) {
        self.key = key
        self.cost = cost
        self.date = date
    }
    
    convenience init(key:String,cost:Int = 0){
         self.init(key: key, cost: cost, date: Date())
    }
}

open class DiskCache{
    open var name:String
    open var cacheURL:URL
    open var totalCount:Int{
        get{
            _lock()
            let count = _cache.totalCount
            _unlock()
            return count
        }
    }
    
    open var totalCost:Int{
        get{
            _lock()
            let cost = _cache.totalCost
            _unlock()
            return cost
        }
    }
    
    fileprivate var _countLimit:Int = Int.max
    fileprivate var _costLimit:Int = Int.max
    fileprivate var _ageLimit:TimeInterval = Double.greatestFiniteMagnitude
    
    open var countLimit:Int{
        set{
            _lock()
            _countLimit = newValue
            _unsafeTrim(toCount: newValue)
            _unlock()
        }
        
        get{
            _lock()
            let countLimit = _countLimit
            _unlock()
            return countLimit
        }
    }
    
    open var costLimit:Int{
        set{
            _lock()
            _costLimit = newValue
            _unsafeTrim(toCost: newValue)
            _unlock()
        }
        
        get{
            _lock()
            let costLimit = _costLimit
            _unlock()
            return costLimit
        }
    }
    
    open var ageLimit:TimeInterval{
        set{
            _lock()
            _ageLimit = newValue
            _unsafeTrim(toAge: newValue)
            _unlock()
        }
        
        get{
            _lock()
            let ageLimit = _ageLimit
            _unlock()
            return ageLimit
        }
    }

    fileprivate let _cache: LRU = LRU<DiskCacheObject>()
    
    fileprivate let _queue: DispatchQueue = DispatchQueue(label: prefixName + (String(describing: DiskCache.self)), attributes: DispatchQueue.Attributes.concurrent)
    fileprivate let _semaphoreLock:DispatchSemaphore = DispatchSemaphore(value: 1)
    
    open static let shareInstance = DiskCache(name: defaultName)
    
    init?(name:String,path:String) {
        if name.length == 0 || path.length == 0 {
            return nil
        }
        self.name = name
        self.cacheURL = URL(fileURLWithPath: path).appendingPathComponent(prefixName + name,isDirectory:false)
    }
    
    convenience init?(name:String) {
        self.init(name: name, path: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
    }
    
}

public typealias DiskCacheAsyncCompletion = (_ key:String?,_ cache:DiskCache?,_ obejct:AnyObject?) -> Void

// MARK: - public
extension DiskCache{
    public func set(object:AnyObject,forKey key:String) {
        guard let fileURL = _generateFileURL(key, path: cacheURL) else {
            return
        }
        let filePath = fileURL.path
        _lock()
        if NSKeyedArchiver.archiveRootObject(object, toFile: filePath) == true {
            do {
                let date = Date()
                try FileManager.default.setAttributes([FileAttributeKey.modificationDate:date], ofItemAtPath: filePath)
                let infosDic: [URLResourceKey : AnyObject] = try (fileURL as NSURL).resourceValues(forKeys: [URLResourceKey.totalFileAllocatedSizeKey]) as [URLResourceKey : AnyObject]
                var fileSize:Int = 0
                if let fileSizeNumber = infosDic[URLResourceKey.totalFileSizeKey] as? NSNumber {
                    fileSize = fileSizeNumber.intValue
                }
                _cache.set(object: DiskCacheObject(key: key, cost: fileSize, date: date), forKey: key)
            } catch{
            }
        }
        if _cache.totalCost > _costLimit {
            _unsafeTrim(toCost: _costLimit)
        }

        if _cache.totalCount > _countLimit {
            _unsafeTrim(toCount: _countLimit)
        }
        _unlock()
    }
    
    func trimRecursively() {
        
    }
    
    func trimInBackground() {
        
    }
}


// MARK: - private
extension DiskCache{
    
    func _unsafeTrim(toCount countLimit:Int) {
        if _cache.totalCount < countLimit {
            return
        }
        
        if let last:DiskCacheObject = _cache.lastObject() {
            while _cache.totalCount > countLimit {
                if let fileULR = _generateFileURL(last.key, path: cacheURL),FileManager.default.fileExists(atPath: fileULR.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileULR.path)
                        _cache.removeLastObject()
                        guard let _ = _cache.lastObject() else { break }
                    } catch {}
                }
            }
        }
    }
    
    func _unsafeTrim(toCost costLimit:Int) {
//        if _cache.totalCost < costLimit {
//            return
//        }
//        
//        if costLimit == 0 {
//            removeAllObjects(nil)
//        }
//        
//        if let _ = _cache.lastObject() {
//            while costLimit<_cache.totalCost{
//                _cache.removeLastObject()
//                guard let _: MemoryCacheObject = _cache.lastObject() else { break }
//            }
//        }
    }
    
    func _unsafeTrim(toAge ageLimit:TimeInterval) {
//        if ageLimit <= 0 {
//            removeAllObjects(nil)
//        }
//        
//        if let last:MemoryCacheObject = _cache.lastObject() {
//            while (CACurrentMediaTime() - last.time) > ageLimit{
//                _cache.removeLastObject()
//                guard let _: MemoryCacheObject = _cache.lastObject() else { break }
//            }
//        }
    }

    func _generateFileURL(_ key: String, path: URL) -> URL? {
        return path.appendingPathComponent(key)
    }
    

    
    fileprivate func _lock() {
        _ = _semaphoreLock.wait(timeout: DispatchTime.distantFuture)
    }
    
    fileprivate func _unlock() {
        _semaphoreLock.signal()
    }


}
