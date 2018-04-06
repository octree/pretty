//
//  Curry.swift
//  RxDemo
//
//  Created by Octree on 2016/10/28.
//  Copyright © 2016年 Octree. All rights reserved.
//  

import Foundation

// 2
public func curry<T, U, V>(_ f: @escaping (T, U) -> V) -> (T) -> (U) -> V {
    
    return { x in { y in f(x, y) } }
}

// 3
public func curry<T, U, V, W>(_ f:@escaping (T, U, V) -> W) -> (T) -> (U) -> (V) -> W {
    
    return {x in {y in {z in f(x, y, z) }}}
}

// 4
public func curry<T, U, V, W, X>(_ f:@escaping (T, U, V, W) -> X) -> (T) -> (U) -> (V) -> (W) -> X {
    
    return {x in {y in {z in {u in f(x, y, z, u) }}}}
}

// 5
public func curry<T, U, V, W, X, Y>(_ f:@escaping (T, U, V, W, X) -> Y) -> (T) -> (U) -> (V) -> (W) -> (X) -> Y {
    
    return {x in {y in {z in {u in {v in f(x, y, z, u, v) }}}}}
}




