//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

indirect enum BinaryTree<T>{
    case leaf
    case node(BinaryTree<T>,T,BinaryTree<T>)
}

//extension BinaryTree:Sequence{
//    func makeIterator() -> AnyIterator<Element> {
//        switch self {
//        case .leaf:
//            return AnyIterator{ return nil}
//        case let .node(l,v,r):
//            return l.makeIterator() + CollectionOfOne(v).makeIterator() + r.makeIterator()
//        }
//    }
//}





