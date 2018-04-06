//
//  NSPoint+Extension.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


extension NSPoint {
    
    func minus(_ other: NSPoint) -> NSPoint {
        
        return NSPoint(x: x - other.x, y: y - other.y)
    }
    
    func offset(_ p: NSPoint) -> NSPoint {
        
        return NSPoint(x: x + p.x, y: y + p.y)
    }
}

