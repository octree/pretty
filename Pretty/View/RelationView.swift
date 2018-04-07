//
//  RelationView.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa


class RelationView: NSView {
    
    //    MARK: Accessor
    
    /// "parent|daughter": Layer
    private var lineMap = [String: CAShapeLayer]()
    private var itemMap = [String: RelationItemView]()
    private var nodeMap = [String: DependencyNode]()
    private var currentDraggingItem: RelationItemView? = nil

    private var lastDragPosition = NSPoint(x: 0, y: 0)
    
    var prettyRelation = PrettyRelation(nodes: []) {
        
        didSet {
            setUp()
        }
    }
    
    //    MARK: Life Cycle
    
    init() {
        super.init(frame: NSRect())
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    //    MARK: Public Method
    
    override func mouseDown(with event: NSEvent) {
     
        let position = convert(event.locationInWindow, from: nil)

        if let item = findItemLocate(in: position) {
            
            currentDraggingItem = item
            lastDragPosition = position
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        if let item = currentDraggingItem {
            
            let position = convert(event.locationInWindow, from: nil)
            item.frame = item.frame.offset(position.minus(lastDragPosition))
            
            lastDragPosition = position
            updateLine(relate: item.text)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        
        guard let item = currentDraggingItem else {
            return
        }
        
        if let node = nodeMap[item.text] {
         
            node.frame = NodeFrame(x: Int(item.frame.origin.x),
                                   y: Int(item.frame.origin.y),
                                   width: Int(item.frame.size.width),
                                   height: Int(item.frame.size.height))
        }
        
        currentDraggingItem = nil
        updateLine(relate: item.text)
    }

    
    //    MARK: Private Method
    
    private func setUp() {
        
        clear()
        let superSize = superview?.frame.size ?? CGSize()
        
        let size = prettyRelation.preferredSize
        
        frame = NSRect(x: 0, y: 0, width: max(size.width, superSize.width),
                       height: max(superSize.height, size.height))
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        
        setupItems()
        setupLines()
        
        lineMap.forEach {
            layer?.addSublayer($0.1)
        }
        
        itemMap.forEach {
            addSubview($0.1)
        }
    }
    
    
    /// 创建 RelationItemViews
    private func setupItems() {
    
        prettyRelation.nodes.forEach { node in
            
            let item = RelationItemView(frame: node.frame.rect, text: node.name)
            let color = NSColor(node.color)
            item.backgroundColor = color
            
            if (color?.colorDifference(.white) ?? 0) < 0.1 {

                item.label.textColor = NSColor(white: 0.2, alpha: 1.0)
            }
            
            itemMap[node.name] = item
            nodeMap[node.name] = node
        }
    }
    
    
    /// 创建 Node 之间的连接线
    private func setupLines() {
        
        prettyRelation.nodes.forEach { parent in
            
            let color = NSColor(parent.color)
            parent.sons.forEach { son in
                
                let key = parent.name + "|" + son
                let shapeLayer = CAShapeLayer()
                shapeLayer.fillColor = NSColor.clear.cgColor
                shapeLayer.strokeColor = color?.cgColor
                shapeLayer.lineWidth = 2
                shapeLayer.path = linePath(parent: parent.name, son: son)
                lineMap[key] = shapeLayer
            }
        }
    }
    
    private func clear() {
        
        lineMap.removeAll()
        itemMap.removeAll()
        nodeMap.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        layer?.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    
    /// 根据 Position 找到对应位置的 RelationItemView
    ///
    /// - Parameter position: NSPoint
    /// - Returns: RelationItemView or nil
    private func findItemLocate(in position: NSPoint) -> RelationItemView? {
        
        for (_, item) in itemMap {
            
            if item.frame.contains(position) {
                return item
            }
        }
        
        return nil
    }
    
    
    /// 根据父节点和子节点的名称创建连接线的 Path
    ///
    /// - Parameters:
    ///   - parent: 父节点名称
    ///   - son: 子节点名称
    /// - Returns: CGPath
    private func linePath(parent: String, son: String) -> CGPath {
        
        let parentItem = itemMap[parent]!
        let sonItem = itemMap[son]!
        
        let path = CGMutablePath()
        path.move(to: parentItem.center)
        path.addLine(to: sonItem.center)
        return path
    }
    
    
    /// 更新和某个节点相关的线
    ///
    /// - Parameter name: 节点名称
    private func updateLine(relate name: String) {
        
        for (key, value) in lineMap {
            
            let components = key.components(separatedBy: "|")
            if components.contains(name) {
                
                value.path = linePath(parent: components.first!, son: components.last!)

                if components.first == currentDraggingItem?.text {
                    
                    value.strokeColor = NSColor.red.cgColor
                } else if (components.last == currentDraggingItem?.text) {
                    
                    value.strokeColor = NSColor.blue.cgColor
                } else {
                    value.strokeColor = itemMap[components.first!]?.backgroundColor?.cgColor
                }
            }
        }
        
    }
    
}
