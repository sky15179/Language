//
//  ViewController.swift
//  Coder
//
//  Created by 王智刚 on 2018/3/30.
//  Copyright © 2018年 王智刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//class DictionaryCoder: Encoder {
//    var codingPath: [CodingKey] = []
//
//    var userInfo: [CodingUserInfoKey : Any] = [:]
//
//    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
//        KeyedEncodingContainer(KeyedEncodingContainerProtocol)
//    }
//
//    func unkeyedContainer() -> UnkeyedEncodingContainer {
//        return UnkeyedEncodingContainer()
//    }
//
//    func singleValueContainer() -> SingleValueEncodingContainer {
//        return SingleValueEncodingContainer()
//    }
//}
//
//extension DictionaryCoder {
//    fileprivate func box(_ value: Bool)   -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: Int)    -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: Int8)   -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: Int16)  -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: Int32)  -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: Int64)  -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: UInt)   -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: UInt8)  -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: UInt16) -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: UInt32) -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: UInt64) -> NSObject { return NSNumber(value: value) }
//    fileprivate func box(_ value: String) -> NSObject { return NSString(string: value) }
//    fileprivate func box(_ float: Float) throws -> NSObject {
//        guard !float.isNaN, !float.isInfinite else {
//            throw EncodingError.invalidValue(float, EncodingError.Context(codingPath: codingPath, debugDescription: "floatError"))
//        }
//        return NSNumber(value: float)
//    }
//    fileprivate func box(_ double: Double) throws -> NSObject {
//        guard !double.isNaN, !double.isInfinite else {
//            throw EncodingError.invalidValue(double, EncodingError.Context(codingPath: codingPath, debugDescription: "doubleError"))
//        }
//        return NSNumber(value: double)
//    }
//    fileprivate func box(_ date: Date) -> NSObject {
//        return NSNumber(value: date.timeIntervalSince1970)
//    }
//    fileprivate func box(_ data: Data) throws -> NSObject {
//        return NSString(string: data.base64EncodedString())
//    }
//    fileprivate func box<T: Encodable>(_ value: T) throws -> NSObject {
//
//    }
//    fileprivate func box_<T: Encodable>(_ value: T) throws -> NSObject? {
//        if T.self == Date.self || T.self == NSDate.self {
//            return try self.box(value)
//        } else if T.self == Data.self || T.self == NSData.self {
//            return try box(value)
//        } else if T.self == URL.self || T.self == NSURL.self {
//            return self.box((value as! URL).absoluteString)
//        }
//    }
//}
//
//fileprivate struct _DictionaryCoderContainer<K : CodingKey>: KeyedEncodingContainerProtocol {
//    typealias Key = K
//    private(set) var codingPath: [CodingKey]
//    private let container: NSMutableDictionary
//    private let encoder: DictionaryCoder
//
//    fileprivate init(coder:DictionaryCoder, codingPath: [CodingKey], wrapping container: NSMutableDictionary) {
//        self.codingPath = codingPath
//        self.container = container
//        self.encoder = coder
//    }
//
//    mutating func encodeNil(forKey key: K) throws {
//        self.container[key.stringValue] = NSNull()
//    }
//
//    mutating func encode(_ value: Bool, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Int, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Int8, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Int16, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Int32, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Int64, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: UInt, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: UInt8, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: UInt16, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: UInt32, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: UInt64, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Float, forKey key: K) throws {
//        try self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: Double, forKey key: K) throws {
//        try self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode(_ value: String, forKey key: K) throws {
//        self.container[key.stringValue] = self.encoder.box(value)
//    }
//
//    mutating func encode<T>(_ value: T, forKey key: K) throws where T : Encodable {
//        if T is Date.self {
//
//        }
//    }
//
//    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
//        <#code#>
//    }
//
//    mutating func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
//        <#code#>
//    }
//
//    mutating func superEncoder() -> Encoder {
//        <#code#>
//    }
//
//    mutating func superEncoder(forKey key: K) -> Encoder {
//        <#code#>
//    }
//}

