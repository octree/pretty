//
//  ViewController.swift
//  Pretty
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var maginficationLabel: NSTextField!
    @IBOutlet weak var abilityView: NSView!
    
    private let relationView = RelationView()
    private var treeMode = 0
    private var treeReversed = true
    private var dependency: [String: [String]]?
    private var searchModuleName = ""
    private var magnification = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.documentView = relationView
        scrollView.maxMagnification = 3
        scrollView.minMagnification = 0.2
        scrollView.magnification = magnification
        
        abilityView.layer?.backgroundColor = NSColor.selectedContentBackgroundColor.cgColor
        abilityView.layer?.cornerRadius = 10
        abilityView.alphaValue = 0.6
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpenFile(notification:)), name: NSNotification.Name(rawValue: OCTOpenFileNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(findModule(notification:)), name: NSNotification.Name(rawValue: OCTFindModuleNotification), object: nil)
        
        if FileName.count > 0 {
            
            updateRelationView(filename: FileName)
        }
        
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        guard !relationView.frame.equalTo(CGRect()) else {
            return
        }
        
        let size = relationView.prettyRelation.preferredSize
        let parentSize = scrollView.frame.size
        relationView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: max(size.width, parentSize.width),
                                    height: max(size.height, parentSize.height))
    }
    
    
    @objc func handleOpenFile(notification: Notification) {
        
        guard let filename = notification.object as? String else {
            return
        }
        
        updateRelationView(filename: filename)
    }
    
    @objc func findModule(notification: Notification) {
        let alert = NSAlert()
        alert.addButton(withTitle: "Ok")
        alert.messageText = "快速找到你的模块"
        alert.informativeText = "忽略大小写"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "")
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    
    
    func updateRelationView(filename: String) {
        
        view.window?.title = filename
        if filename.hasSuffix(".lock") {
            updateWithLockFile(filename: filename)
        } else {
            updateWithPrettyFile(filename: filename)
        }
    }
    
    func updateWithLockFile(filename: String) {
        
        do {
            
            let string = try String(contentsOfFile: filename, encoding: .utf8)
            
            if let (dependency, _) = PodLockFileParser.parse(Substring(string)) {
                self.dependency = dependency
                relationView.prettyRelation = PrettyRelation(dependency: dependency, treeMode: treeMode, treeReversed: treeReversed)
            } else {
                
                alert(title: "Error", msg: "Parse Error: Wrong Format")
            }
        } catch {
            
            alert(title: "Error", msg: error.localizedDescription)
        }
    }
    
    
    func updateWithPrettyFile(filename: String) {
        
        do {
            
            let url = URL(fileURLWithPath: filename)
            let data = try Data(contentsOf: url)
            let relation = try JSONDecoder().decode(PrettyRelation.self, from: data)
            relationView.prettyRelation = relation
        } catch {
            
            alert(title: "Error", msg: error.localizedDescription)
        }
    }
    
    
    func alert(title: String, msg: String) {
        let alert = NSAlert()
        alert.addButton(withTitle: "Ok")
        alert.messageText = title
        alert.informativeText = msg
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    
    @IBAction func treeMode(_ sender: NSComboBox) {
        if sender.stringValue == "被依赖树图" {
            treeMode = 0
        }
        else if sender.stringValue == "依赖树图" {
            treeMode = 1
        }
        
        if let dependency = dependency {
            relationView.prettyRelation = PrettyRelation(dependency: dependency, treeMode: treeMode, treeReversed: treeReversed)
        }
    }
    
    @IBAction func treeReversed(_ sender: NSComboBox) {
        if sender.stringValue == "正向树" {
            treeReversed = true
        }
        else if sender.stringValue == "逆向树" {
            treeReversed = false
        }
        
        if let dependency = dependency {
            relationView.prettyRelation = PrettyRelation(dependency: dependency, treeMode: treeMode, treeReversed: treeReversed)
        }
    }
    
    
    @IBAction func searchModule(_ sender: NSSearchField) {
        debugPrint("\(sender.stringValue)")
    }
    

    @IBAction func viewScale(_ sender: NSStepper) {
        maginficationLabel.stringValue = "缩放比例：\(sender.floatValue)"
        scrollView.magnification = CGFloat(sender.floatValue)
    }
    
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        debugPrint(control.stringValue)
        if control.stringValue.count > 0 {
            searchModuleName = control.stringValue
            relationView.findModule(name: searchModuleName)
        }
        return true
    }
}
