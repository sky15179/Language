//
//  MemoryCache.swift
//  data-Base-exercises
//
//  Created by 王智刚 on 2017/6/13.
//  Copyright © 2017年 王智刚. All rights reserved.
//

import Foundation
import QuartzCore

internal class MemoryCacheObject:LRUObj{
    var key: String = ""
    var cost: Int = 0
    var time :TimeInterval = CACurrentMediaTime()
    var value:AnyObject
    
    init(key:String,value:AnyObject,cost:Int = 0) {
        self.key = key
        self.value = value
        self.cost = cost
    }
    
}

let prefixName = "com.cahe"
let defaultName = "defaultCahe"


open class MemoryCache {
    
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
    
    fileprivate var _autoRemoveAllobjectWhenMemoryWarning:Bool = true
    
    open var autoRemoveAllobjectWhenMemoryWarning:Bool{
        set{
            _lock()
            _autoRemoveAllobjectWhenMemoryWarning = newValue
            
            _unlock()
        }
        
        get{
            _lock()
            let autoRemoveAllobjectWhenMemoryWarning = _autoRemoveAllobjectWhenMemoryWarning
            _unlock()
            return autoRemoveAllobjectWhenMemoryWarning
        }
    }
    
    fileprivate var _autoRemoveAllobjectWhenEnterBackground:Bool = true
    
    open var autoRemoveAllobjectWhenEnterBackground:Bool{
        set{
            _lock()
            _autoRemoveAllobjectWhenEnterBackground = newValue
            _unlock()
        }
        
        get{
            _lock()
            let autoRemoveAllobjectWhenEnterBackground = _autoRemoveAllobjectWhenEnterBackground
            _unlock()
            return autoRemoveAllobjectWhenEnterBackground
        }
    }
    
    
    
    open static let shareInstance = MemoryCache()
    fileprivate let _cache:LRU = LRU<MemoryCacheObject>()
    fileprivate let _queue:DispatchQueue = DispatchQueue(label: prefixName + String(describing:MemoryCache.self), attributes: DispatchQueue.Attributes.concurrent)
    fileprivate var _pthreadLock:pthread_mutex_t = pthread_mutex_t()
    
    public init(){
        pthread_mutex_init(&_pthreadLock,nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_didReceiveMemoryWarningNotification), name: Notification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(_didEnterBackgroundNotification), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
}

public typealias MemoryCacheAsyncCompletion = (_ cache:MemoryCache?,_ key:String?,_ object:AnyObject?)->Void

// MARK: - 缓存的对外暴露方法
public extension MemoryCache{
    public func set(object:AnyObject,forKey key:String,cost:Int = 0) {
        _lock()
        _unsafeSet(object: object, key: key, cost: cost)
        _unlock()
    }
    
    public func set(obejct:AnyObject,forkey key:String,cost:Int = 0,completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,key,obejct);return}
            strongSelf.set(object: obejct, forKey: key, cost: cost)
            completion?(strongSelf,key,obejct)
        }
    }
    
    public func object(forKey key:String) -> AnyObject? {
        var object:AnyObject? = nil
        _lock()
        let memoryObject: MemoryCacheObject? = _cache.object(forKey: key)
        memoryObject?.time = CACurrentMediaTime()
        object = memoryObject?.value
        _unlock()
        return object
    }
    
    public func removeObject(forKey key:String) {
        _lock()
        _ = _cache.removeObject(forKey: key)
        _unlock()
    }
    
    public func removeAllObjects() {
        _lock()
        _ = _cache.removeAll()
        _unlock()
        
    }
    
    public func object(forKey key:String,completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,key,nil);return}
            let object = strongSelf.object(forKey: key)
            completion?(strongSelf,key,object)
        }
    }
    
    public func removeObject(forKey key:String,completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,key,nil);return}
            strongSelf.removeObject(forKey: key)
            completion?(strongSelf,key,nil)
        }
    }
    
    public func removeAllObjects(_ completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,nil,nil);return}
            strongSelf.removeAllObjects()
            completion?(strongSelf,nil,nil)
        }
    }
    
    public func trim(toCount countLimit:Int) {
        _lock()
        _unsafeTrim(toCount: countLimit)
        _unlock()
    }
    
    public func trim(toCost costLimit:Int) {
        _lock()
        _unsafeTrim(toCost: costLimit)
        _unlock()
    }
    
    public func trim(toAge ageLimit:TimeInterval) {
        _lock()
        _unsafeTrim(toAge: ageLimit)
        _unlock()
    }
    
    func trim(toCount countLimit:Int,completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,nil,nil);return}
            strongSelf.trim(toCount: countLimit)
            completion?(strongSelf,nil,nil)
        }
    }
    
    func trim(toCost costLimit:Int,completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,nil,nil);return}
            strongSelf.trim(toCost: costLimit)
            completion?(strongSelf,nil,nil)
        }
    }
    
    
    func trim(toAge ageLimit:TimeInterval,completion:MemoryCacheAsyncCompletion?) {
        _queue.async {
            [weak self] in
            guard let strongSelf = self else{completion?(nil,nil,nil);return}
            strongSelf.trim(toAge: ageLimit)
            completion?(strongSelf,nil,nil)
        }
    }
    
    public subscript(key:String) -> AnyObject?{
        get{
            return self.object(forKey:key)
        }
        
        set{
            if let newValue = newValue{
                set(object: newValue, forKey: key)
            }else{
                removeObject(forKey: key)
            }
        }
    }
}

open class MemoryCacheGenerator: IteratorProtocol {
    public typealias Element = (String,AnyObject)
    
    fileprivate var _lruGenerator:LRUGenerator<MemoryCacheObject>
    fileprivate var _completion:(()->Void)?
    
    fileprivate init(generate:LRUGenerator<MemoryCacheObject>,cache:MemoryCache,completion:(()->Void)?){
        _lruGenerator = generate
        _completion = completion
    }
    
    open func next() -> (String, AnyObject)? {
        if let object = _lruGenerator.next() {
            return(object.key,object.value)
        }else{
            return nil
        }
    }
    
    deinit {
        _completion?()
    }
}

// MARK: - 支持序列
extension MemoryCache:Sequence{
    public typealias Iterator = MemoryCacheGenerator
    
    public func makeIterator() -> MemoryCacheGenerator {
        var generator:MemoryCacheGenerator
        _lock()
        generator = MemoryCacheGenerator(generate: _cache.makeIterator(), cache: self) {
            self._unlock()
        }
        return generator
    }
}


// MARK: - 辅助方法
extension MemoryCache{
    
    /// 删除直到达到数量最大值
    ///
    /// - Parameter countLimit: <#countLimit description#>
    func _unsafeTrim(toCount countLimit:Int) {
        if _cache.totalCount < countLimit {
            return
        }
        
        if countLimit == 0 {
            removeAllObjects(nil)
        }
        
        if let _ = _cache.lastObject() {
            while countLimit<_cache.totalCount{
                _cache.removeLastObject()
                guard let _: MemoryCacheObject = _cache.lastObject() else { break }
            }
        }
    }
    
    func _unsafeTrim(toCost costLimit:Int) {
        if _cache.totalCost < costLimit {
            return
        }
        
        if costLimit == 0 {
            removeAllObjects(nil)
        }
        
        if let _ = _cache.lastObject() {
            while costLimit<_cache.totalCost{
                _cache.removeLastObject()
                guard let _: MemoryCacheObject = _cache.lastObject() else { break }
            }
        }
    }
    
    func _unsafeTrim(toAge ageLimit:TimeInterval) {
        if ageLimit <= 0 {
            removeAllObjects(nil)
        }
        
        if let last:MemoryCacheObject = _cache.lastObject() {
            while (CACurrentMediaTime() - last.time) > ageLimit{
                _cache.removeLastObject()
                guard let _: MemoryCacheObject = _cache.lastObject() else { break }
            }
        }
    }
    
    @objc fileprivate func _didReceiveMemoryWarningNotification() {
        if _autoRemoveAllobjectWhenMemoryWarning {
            removeAllObjects(nil)
        }
    }
    
    @objc fileprivate func _didEnterBackgroundNotification(){
        if _autoRemoveAllobjectWhenEnterBackground {
            removeAllObjects(nil)
        }
    }
    
    func _unsafeSet(object:AnyObject,key:String,cost:Int = 0) {
        _cache.set(object: MemoryCacheObject(key: key, value: object, cost: cost), forKey: key)
        if _cache.totalCost > _costLimit {
            _unsafeTrim(toCost: _costLimit)
        }
        
        if _cache.totalCount > _countLimit {
            _unsafeTrim(toCount: _countLimit)
        }
    }
    
    func _lock(){
        pthread_mutex_lock(&_pthreadLock)
    }
    
    func _unlock(){
        pthread_mutex_unlock(&_pthreadLock)
    }
    
    func _tryLock() {
        if pthread_mutex_trylock(&_pthreadLock) == 0 {
            
        }else{
            usleep(10 * 1000); //10 ms
        }
    }
}



