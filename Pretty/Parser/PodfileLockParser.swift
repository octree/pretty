//
//  PodfileLockParser.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

func character(_ ch: Character) -> Parser<Character> {
    
    return character {
        $0 == ch
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

private let leftParent = character("(")
private let rightParent = character(")")

private let pods = character("P").followed(by: character("O")).followed(by: character("D")).followed(by: character("S")).followed(by: colon).followed(by: newLine)

private let word = character {
    !CharacterSet.whitespacesAndNewlines.contains($0) }.many.map { String($0) }

private let version = leftParent.followed(by: character { $0 != ")" }.many).followed(by: rightParent)

private let item = (indentation *> hyphon *> space *> word)
    <* (space.followed(by: version)).optional <* colon.optional <* newLine

private let subItem = indentation *> item

private let dependencyItem = curry(dependencyCombine) <^> item <*> subItem.many.optional

private let dependencyItems = dependencyItem.many.map { x -> [String : [String]] in
    
    var map = [String: [String]]()
    
    x.forEach { map[$0.0] = $0.1 }
    return map
}

let PodLockFileParser = pods *> dependencyItems
