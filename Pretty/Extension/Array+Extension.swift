//
//  Array+Extension.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

extension Array {
    
    func group(_ size: Int) -> [[Element]] {
        
        let rows = (count + size - 1) / size
        var groups = Array<[Element]>(repeating: [Element](), count: rows)
        
        for (index, elt) in enumerated() {
            
            let newIndex = index / size
            groups[newIndex].append(elt)
        }
        
        return groups
    }
}


extension Array where Element: Equatable {
    
    func contains(_ other: [Element]) -> Bool {
        
        for elt in other {
            if !contains(elt) {
                
                return false
            }
        }
        
        return true
    }
}

