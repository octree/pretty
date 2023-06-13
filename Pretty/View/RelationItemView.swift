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
    var depend = "" {
        didSet {
            dependLabel.stringValue = depend
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
    
    private(set) var dependLabel: NSTextField = {
        let textfield = NSTextField()
        textfield.isEditable = false
        textfield.textColor = .white
        textfield.alignment = .center
        textfield.font = NSFont.systemFont(ofSize: 12)
        textfield.isBordered = false
        return textfield
    }()
    
    var backgroundColor: NSColor? {
        didSet {
            layer?.backgroundColor = backgroundColor?.cgColor
            label.backgroundColor = backgroundColor
            dependLabel.backgroundColor = backgroundColor
        }
    }
    
    init(frame frameRect: NSRect, text: String) {
        super.init(frame: frameRect)
        self.text = text
        addSubview(label)
        addSubview(dependLabel)
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
        label.frame = CGRect(x: 0, y: 20, width: frame.width, height: 20)
        dependLabel.frame = CGRect(x: 0, y: 6, width: frame.width, height: 14)
    }
    
    var center: NSPoint {
        
        return NSPoint(x: frame.origin.x + frame.size.width / 2,
                       y: frame.origin.y + frame.size.height / 2)
    }
}
