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

// Parser作为解析结构体，接受<Int> 类型的输入，返回 (Int, Substring) 元组
func test() {
    // 对parser的实现
    let parser = Parser<Int> { input in
        return (input.count, input)
    }
    
    // 调用parser进行解析
    let input = "123abc"
    if let (result1, result2) = parser.parse(input[...]) {
        print("\(result1)、\(result2)")
    }
}
