//
//  Parser+Runes.swift
//  Pretty
//
//  Created by Octree on 2018/4/7.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/// Functor Operator
/// a -> b -> m a -> m b
///
/// - Parameters:
///   - lhs: a -> b
///   - rhs: m a
/// - Returns: m b
func <^><A, B>(lhs: @escaping (A) -> B, rhs: Parser<A>) -> Parser<B> {
    return rhs.map(lhs)
}


/// Monad
/// a -> m b -> m a -> m b
///
/// - Parameters:
///   - lhs: a -> m b
///   - rhs: m a
/// - Returns: m b
func >>-<A, B>(lhs: Parser<A>, rhs: @escaping (A) -> Parser<B>) -> Parser<B> {
    
    return lhs.then(lhs: rhs)
}


/// applicative
/// m (a -> b) -> m a -> m b
///
/// - Parameters:
///   - lhs: m (a -> b)
///   - rhs: m a
/// - Returns: m b
func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) -> Parser<B> {
    
    return lhs.followed(by: rhs).map { $0($1) }
}



/// Ignoring Left
/// ma -> mb -> mb
///
/// - Parameters:
///   - lhs: m a
///   - rhs: m b
/// - Returns: m b
func *><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<B> {
    
    return curry({ _,
        y in y }) <^> lhs <*> rhs
}


/// Ignoring Right
/// ma -> mb -> ma
///
/// - Parameters:
///   - lhs: m a
///   - rhs: m b
/// - Returns: m a
func <*<A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<A > {
    
    return curry({ x, _ in x }) <^> lhs <*> rhs
}


/// or
/// m a -> m a -> m a
///
/// - Parameters:
///   - lhs: m a
///   - rhs: m a
/// - Returns: m a
func <|><A>(lhs: Parser<A>, rhs: Parser<A>) -> Parser<A> {
    
    return lhs.or(rhs)
}

