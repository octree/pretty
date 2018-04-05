//
//  Helper.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

let kRelationHorizentalSpacing  =   30
let kRelationVerticalSpacing    =   100
let kRelationItemHeight         =   28
let kRelationItemPerRow         =   6
let kRelationViewPadding        =   40
private func widthForItem(_ text: String) -> Int {
    
    return 10 + 9 * text.count
}

private func preferredSize(_ dependency: [String: [String]]) -> NSSize {
    
    let rows = ((dependency.count + kRelationItemPerRow - 1) / kRelationItemPerRow)
    let height = (kRelationItemHeight + kRelationVerticalSpacing) * rows + kRelationViewPadding * 2
    let width = Array(dependency.keys).group(kRelationItemPerRow).map {
        $0.reduce(kRelationViewPadding * 2, { rt, str in
            return rt + widthForItem(str) + kRelationHorizentalSpacing
        })
        }.reduce(0, max)
    
    
    return NSSize(width: width, height: height)
}

private func nodesForDependency(_ dependency: [String: [String]]) -> [DependencyNode] {
    
    var nodes = [DependencyNode]()
    let groups = Array(dependency.keys).group(kRelationItemPerRow)
    let colors = randomColors(count: dependency.count)
    
    for (row, g) in groups.enumerated() {
        
        var x = kRelationViewPadding
        let y = kRelationViewPadding + row * (kRelationItemHeight + kRelationVerticalSpacing)
        for (col, elt) in g.enumerated() {
            
            let width = widthForItem(elt)
            
            let color = colors[row * kRelationItemPerRow + col]
            let node = DependencyNode(name: elt,
                                      color: color.hex,
                                      frame: NodeFrame(x: x, y: y, width: width, height: kRelationItemHeight),
                                      sons: dependency[elt]!)
            nodes.append(node)
            x += width + kRelationHorizentalSpacing
        }
    }
    
    return nodes
}

extension PrettyRelation {
    
    convenience init(dependency: [String: [String]]) {
        
        let size = preferredSize(dependency)
        self.init(width: Int(size.width),
                  height: Int(size.height),
                  nodes: nodesForDependency(dependency))
    }
}
