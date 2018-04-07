//
//  Parser+Runes.swift
//  Pretty
//
//  Created by Octree on 2018/4/7.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation



func >>-<A, B>(lhs: @escaping (A) -> Parser<B>, rhs: Parser<A>) -> Parser<B> {
    
    return Parser<B> {
        input in
        guard let rt = rhs.parse(input) else {
            return nil
        }
        
        return lhs(rt.0).parse(rt.1)
    }
}

func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) -> Parser<B> {
    
    return lhs.followed(by: rhs).map { $0($1) }
}

func <^><A, B>(lhs: @escaping (A) -> B, rhs: Parser<A>) -> Parser<B> {
    return rhs.map(lhs)
}

func *><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<B> {
    
    return curry({ _,
        y in y }) <^> lhs <*> rhs
}

func <*<A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<A > {
    
    return curry({ x, _ in x }) <^> lhs <*> rhs
}

func <|><A>(lhs: Parser<A>, rhs: Parser<A>) -> Parser<A> {
    
    return lhs.or(rhs)
}

