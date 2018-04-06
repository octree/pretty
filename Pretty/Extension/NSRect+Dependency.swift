//
//  NSRect+Dependency.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation


extension NSRect {
    
    func offset(_ p: NSPoint) -> NSRect {
        
        return NSRect(origin: origin.offset(p), size: size)
    }
}
