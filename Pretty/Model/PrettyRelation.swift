//
//  RepettyRelation.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

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
