//
//  RelationItemView.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa

class RelationItemView: NSView {
    
    var text = "" {
        didSet {
            label.stringValue = text
        }
    }
    private(set) var label: NSTextField = {
        let textfield = NSTextField()
        textfield.isEditable = false
        textfield.textColor = .white
        textfield.alignment = .center
        textfield.isBordered = false
        return textfield
    }()
    
    var backgroundColor: NSColor? {
        didSet {
            layer?.backgroundColor = backgroundColor?.cgColor
            label.backgroundColor = backgroundColor
        }
    }
    
    init(frame frameRect: NSRect, text: String) {
        super.init(frame: frameRect)
        self.text = text
        addSubview(label)
        label.stringValue = text
        wantsLayer = true
        layer?.cornerRadius = 10
        layer?.masksToBounds = true
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func layout() {
        super.layout()
        label.frame = bounds.insetBy(dx: 5, dy: 5)
    }
    
    var center: NSPoint {
        
        return NSPoint(x: frame.origin.x + frame.size.width / 2,
                       y: frame.origin.y + frame.size.height / 2)
    }
}
