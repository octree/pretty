//
//  Parser.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

struct Parser<Result> {
    
    typealias Stream = Substring
    
    let parse: (Stream) -> (Result, Stream)?
}

func character(matching condition: @escaping (Character) -> Bool) -> Parser<Character> {
    
    return Parser(parse: { input in
        guard let char = input.first, condition(char) else {
            return nil
        }
        return (char, input.dropFirst())
    })
}
