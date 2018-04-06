//
//  DependencySort.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


/// 哈哈哈，帮助这些 lib 找爸爸
///
/// - Parameter dependency: 依赖 [name: Sons]
/// - Returns: [name: dads]
private func whoIsYourDad(_ dependency: [String: [String]]) -> [String: [String]] {
    
    var dadsMap = [String: [String]]()
    for (key, sons) in dependency {
        
        for name in sons {
            
            var parents = dadsMap[name] ?? []
            parents.append(key)
            dadsMap[name] = parents
        }
    }
    
    return dadsMap
}


/// 根据 lib 的 depth 进行分组
///
/// - Parameter dependency: pod dependency
/// - Returns: grouped dependency
func groupPodDependency(_ dependency: [String: [String]]) -> [[String: [String]]] {
    
    let reversed = whoIsYourDad(dependency)
    var names = Set(dependency.keys)
    
    var lastDepthNames = [String]()
    var groups = [[String: [String]]]()
    while names.count > 0 {
        
        var group = [String: [String]]()
        let copyedNames = names
        for name in copyedNames {
            if lastDepthNames.contains(reversed[name] ?? []) {
                
                names.remove(name)
                group[name] = dependency[name]
            }
        }
        lastDepthNames.append(contentsOf: group.keys)
        groups.append(group)
    }
    
    return groups
}
