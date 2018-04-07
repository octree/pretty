//
//  PrettyRelation+Extension.swift
//  Pretty
//
//  Created by Octree on 2018/4/6.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

private let kRelationHorizentalSpacing  =   30
private let kRelationVerticalSpacing    =   100
private let kRelationItemHeight         =   28
private let kRelationItemPerRow         =   6
private let kRelationViewPadding        =   40

private func widthForItem(_ text: String) -> Int {
    
    return 10 + 9 * text.count
}


private func preferredSize(_ groups: [[String: [String]]]) -> NSSize {
    
    let rows = groups.count
    let height = (kRelationItemHeight + kRelationVerticalSpacing) * rows + kRelationViewPadding * 2
    let width = groups.map { elt in
        return elt.keys.reduce(2 * kRelationViewPadding) {
            $0 + 10 + $1.count * 9 + kRelationHorizentalSpacing
        }
        }.reduce(0, max)
    
    return NSSize(width: width, height: height)
}

private func nodesForGroups(_ groups: [[String: [String]]]) -> [DependencyNode] {
    
    var nodes = [DependencyNode]()
    
    for (row, g) in groups.enumerated() {
        
        var x = kRelationViewPadding
        let y = kRelationViewPadding + row * (kRelationItemHeight + kRelationVerticalSpacing)
        for elt in g {
            
            let width = widthForItem(elt.key)
            let color = randomColor()
            let node = DependencyNode(name: elt.key,
                                      color: color.hex,
                                      frame: NodeFrame(x: x, y: y, width: width, height: kRelationItemHeight),
                                      sons: elt.value)
            nodes.append(node)
            x += width + kRelationHorizentalSpacing
        }
    }
    
    return nodes
}

extension PrettyRelation {
    
    convenience init(dependency: [String: [String]]) {
        
        let groups = Array(groupPodDependency(dependency).reversed())
//        let size = preferredSize(groups)
        self.init(nodes: nodesForGroups(groups))
    }
}


extension PrettyRelation {
    
    var preferredSize: CGSize {
        
        let (width, height) = nodes.reduce((0, 0)) { (result, node) in
            
            return (max(result.0, node.frame.x + node.frame.width),
                    max(result.1, node.frame.y + node.frame.height))
        }
        return CGSize(width: width + kRelationViewPadding, height: height + kRelationViewPadding)
    }
}
