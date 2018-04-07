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

