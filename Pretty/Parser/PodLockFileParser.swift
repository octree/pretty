//
//  PodLockFileParser.swift
//  解析 Podfile.lock 的 PODS: 字段，获取 pod 间的依赖关系
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/// Just parse one character
///
/// - Parameter condition: condition
/// - Returns: Parser<Character>
func character(matching condition: @escaping (Character) -> Bool) -> Parser<Character> {
    
    return Parser(parse: { input in
        guard let char = input.first, condition(char) else {
            return nil
        }
        return (char, input.dropFirst())
    })
}


/// parse one specific character
///
/// - Parameter ch: character
/// - Returns: Parser<Character>
func character(_ ch: Character) -> Parser<Character> {
    
    return character {
        $0 == ch
    }
}


/// Parse Specific String
///
/// - Parameter string: expected string
/// - Returns: Parser<String>
func string(_ string: String) -> Parser<String> {
    
    return Parser { input in
        
        guard input.hasPrefix(string) else {
            return nil
        }
        return (string, input.dropFirst(string.count))
    }
}

func dependencyCombine(name: String, sons: [String]?) -> (String, [String]) {
    
    return (name, sons ?? [])
}

/// 冒号
private let colon = character { $0 == ":" }

/// 空格
private let space = character(" ")

/// 换行
private let newLine = character("\n")

/// 缩进
private let indentation = space.followed(by: space)

/// -
private let hyphon = character("-")
private let quote = character("\"")

private let leftParent = character("(")
private let rightParent = character(")")

/// Just Parse `PODS:` 😅
private let pods = string("PODS:\n")

private let word = character {
    !CharacterSet.whitespacesAndNewlines.contains($0) }.many.map { String($0) }

/// Parse Version Part: `(= 1.2.2)` or `(1.2.3)` or `(whatever)`
private let version = leftParent.followed(by: character { $0 != ")" }.many).followed(by: rightParent)


private let item = (indentation *> hyphon *> space *> quote.optional *> word)
    <* (space.followed(by: version)).optional <* quote.optional <* colon.optional <* newLine

private let subItem = indentation *> item

private let dependencyItem = curry(dependencyCombine) <^> item <*> subItem.many.optional

private let dependencyItems = dependencyItem.many.map { x -> [String : [String]] in
    
    var map = [String: [String]]()
    
    x.forEach { map[$0.0] = $0.1 }
    return map
}


/// 解析 Podfile.lock
/// 解析成功会返回 [String: [String]]
/// key: Pod Name
/// value: 该 Pod 依赖的其他 Pods
let PodLockFileParser = pods *> dependencyItems
