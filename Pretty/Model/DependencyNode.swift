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

class PrettyRelation: Codable {
    
    var width: Int
    var height: Int
    var nodes: [DependencyNode]
    
    init(width: Int, height: Int, nodes: [DependencyNode]) {
        
        self.width = width
        self.height = height
        self.nodes = nodes
    }
}


extension PrettyRelation {
    
    var size: NSSize {
        
        return NSSize(width: width, height: height)
    }
    
    func jsonData() throws -> Data  {
        
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            throw error
        }
    }
    
    func jsonString() throws -> String {
        
        do {
            return try String(data: jsonData(), encoding: .utf8)!
        } catch {
            throw error
        }
    }
}

