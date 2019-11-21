//
//  MYPDiskCache.swift
//  MYPCache
//
//  Created by 王智刚 on 2017/10/22.
//  Copyright © 2017年 王智刚. All rights reserved.
//  磁盘缓存

import Foundation

final class MYPDiskCache {
    
    enum Error: Swift.Error {
        case fileEnumeratorFailed
    }
    
    //MARK: Porperty - Public
    
    let path: String
    
    //MARK: Porperty - Private
    
    private let fileMgr: FileManager
    private let config: MYPCacheDiskConfig
    
    //MARK: LiftCycle
    
    required init(with config: MYPCacheDiskConfig) throws {
        self.config = config
        self.fileMgr = FileManager.default
        let url: URL
        if let directory = config.directory {
            url = directory
        } else {
            url = try fileMgr.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        }
        self.path = url.appendingPathComponent(config.name, isDirectory: true).path
        try createDirectory()
    }
}

typealias resourceObject = (url: Foundation.URL, resourceValues: [AnyHashable: Any])

extension MYPDiskCache {
    
    //MARK: Method - Public
    
    func makeFileName(for key: String) -> String {
        return MD5(key)
    }
    
    func makeFilePath(for key: String) -> String {
        return "\(path)/\(makeFileName(for: key))"
    }
    
    func totalSize() throws -> UInt64 {
        let contents = try fileMgr.contentsOfDirectory(atPath: path)
        return try contents.reduce(0) { (size, pathComponent) -> UInt64 in
            let filePath = (path as NSString).appendingPathComponent(pathComponent)
            let attributes = try fileMgr.attributesOfItem(atPath: filePath)
            if let fileSize = attributes[.size] as? UInt64 {
                return size + fileSize
            } else {
                return 0
            }
        }
    }
    
    func createDirectory() throws {
        guard !fileMgr.fileExists(atPath: path) else {
            return
        }
        try fileMgr.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    func removeObjectIfExpired(forKey key: String) throws {
        let filePath = makeFilePath(for: key)
        let attributes = try fileMgr.attributesOfItem(atPath: filePath)
        if let expireDate = attributes[.modificationDate] as? Date, expireDate.inThePast {
            try fileMgr.removeItem(atPath: filePath)
        }
    }
    
    func removeResourceObjects(_ objects: [resourceObject], totalSize: UInt) throws {
        guard config.costLimit > 0, totalSize > config.costLimit else { return }
        let targetSize = config.costLimit
        var totalSize = totalSize
        let sortedFiles = objects.sorted {
            let key = URLResourceKey.contentModificationDateKey
            if let time1 = ($0.resourceValues[key] as? Date)?.timeIntervalSinceReferenceDate, let time2 = ($1.resourceValues[key] as? Date)?.timeIntervalSinceReferenceDate {
                return time1 > time2
            } else {
                return false
            }
        }
        
        for file in sortedFiles {
            if totalSize < targetSize {
                break
            }
            
            if let fileSize = file.resourceValues[URLResourceKey.totalFileSizeKey] as? NSNumber {
                totalSize -= fileSize.uintValue
            }
            try fileMgr.removeItem(at: file.url)
        }
    }
}

extension MYPDiskCache: MYPStorageProtocol {

    func wapper<T: Codable>(ofType type: T.Type, forKey key: String) throws -> MYPCacheWrapper<T> {
        let filePath = makeFilePath(for: key)
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        let attributes = try fileMgr.attributesOfItem(atPath: filePath)
        let objc: T = try MYPDataSerializer.deserialize(data: data)
        
        guard let date = attributes[.modificationDate] as? Date else {
            throw MYPCacheError.malformedFileAttribute
        }
        
        let meta: [String: Any] = [
            "filePath": filePath
        ]
        
        return MYPCacheWrapper(object: objc, expiry: MYPCahceExpiry.date(date), meta: meta)
    }
    
    func removeAll() throws {
        try fileMgr.removeItem(atPath: path)
        try createDirectory()
    }
    
    func removeObejct(forKey key: String) throws {
        try fileMgr.removeItem(atPath: makeFilePath(for: key))
    }
    
    func removeExpiredObjects() throws {
        let storageUrl = URL(fileURLWithPath: path)
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey, .totalFileAllocatedSizeKey]
        var resourceObjects = [resourceObject]()
        var totalSize: UInt = 0
        var filesToDelete: [URL] = []
        let fileEnumerator = fileMgr.enumerator(at: storageUrl, includingPropertiesForKeys: resourceKeys, options: .skipsHiddenFiles, errorHandler: nil)
        guard let urlArray = fileEnumerator?.allObjects as? [URL] else {
            throw Error.fileEnumeratorFailed }
        
        for url in urlArray {
            let resourceValues = try (url as NSURL).resourceValues(forKeys: resourceKeys)
            guard (resourceValues[.isDirectoryKey] as? NSNumber)?.boolValue == false else {
                continue
            }
            if let expiryDate = resourceValues[.contentModificationDateKey] as? Date, expiryDate.inThePast {
                filesToDelete.append(url)
                continue
            }
            if let fileSize = resourceValues[.totalFileAllocatedSizeKey] as? NSNumber {
                totalSize += fileSize.uintValue
                resourceObjects.append((url: url, resourceValues: resourceValues))
            }
        }
        
        for url in filesToDelete {
            try fileMgr.removeItem(at: url)
        }
        
        try removeResourceObjects(resourceObjects, totalSize: totalSize)
    }
    
    func setObject<T: Codable>(object: T, forKey key: String, expiry: MYPCahceExpiry? = nil) throws {
        let expiry = expiry ?? config.expiry
        let data = try MYPDataSerializer.serialize(objct: object)
        let filePath = makeFilePath(for: key)
        fileMgr.createFile(atPath: filePath, contents: data, attributes: nil)
        try fileMgr.setAttributes([.modificationDate: expiry.date], ofItemAtPath: filePath)
    }
}
