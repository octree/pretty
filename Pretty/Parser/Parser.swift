//
//  Parser.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    func contains(_ c: Character) -> Bool {
        
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else {
            return false
        }
        return contains(scalars.first!)
    }
}

struct Parser<Result> {
    
    typealias Stream = Substring
    
    let parse: (Stream) -> (Result, Stream)?
}

extension Parser {
    
    private var _many: Parser<[Result]> {
        
        return Parser<[Result]> {
            input in
            var result: [Result] = []
            var remainder = input
            
            while let (element, newRemainder) = self.parse(remainder) {
                
                result.append(element)
                remainder = newRemainder
            }
            return (result, remainder)
        }
    }
}

extension Parser {
    
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> {
        
        return Parser<T> {
            input in
            guard let (result, remainder) = self.parse(input) else {
                return nil
            }
            return (transform(result), remainder)
        }
    }
}

extension Parser {
    
    func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
        return Parser<(Result, A)>  {
            input in
            
            guard let (first, reminder) = self.parse(input),
                let (second, newReminder) = other.parse(reminder) else {
                    return nil
            }
            return ((first, second), newReminder)
        }
    }
}


extension Parser {
    
    func or(_ other: Parser<Result>) -> Parser<Result> {
        
        return Parser {
            input in
            return self.parse(input) ?? other.parse(input)
        }
    }
}

func character(matching condition: @escaping (Character) -> Bool) -> Parser<Character> {
    
    return Parser(parse: { input in
        guard let char = input.first, condition(char) else {
            return nil
        }
        return (char, input.dropFirst())
    })
}

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

extension Parser {
    
    var many: Parser<[Result]> {
        
        return curry { [$0] + $1 } <^> self <*> self._many
    }
}

extension Parser {
    
    var optional: Parser<Result?> {
        
        return Parser<Result?> {
            input in
            guard let (result, remainder) = self.parse(input) else {
                return (nil, input)
            }
            return (result, remainder)
        }
    }
}
