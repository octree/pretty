//
//  DependencyNode.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa


struct NodeFrame: Codable {
    
    var x: Int
    var y: Int
    var width: Int
    var height: Int
}

extension NodeFrame {
    
    var rect: NSRect {
        return NSRect(x: x, y: y, width: width, height: height)
    }
}

class DependencyNode: Codable {
    
    var name: String
    var color: String
    var frame: NodeFrame
    var sons: [String]
    
    init(name: String, color: String, frame: NodeFrame, sons: [String]) {
        
        self.name = name
        self.color = color
        self.frame = frame
        self.sons = sons
    }
}


