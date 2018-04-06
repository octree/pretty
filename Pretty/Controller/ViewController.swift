//
//  ViewController.swift
//  Pretty
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

//  新的分层算法
//  没有被依赖的 depth 为 0
//  只被 depth 为 0 的依赖，则 depth 为 1
//  依次类推


import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var scrollView: NSScrollView!
    
    private let relationView = RelationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.documentView = relationView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleOpenFile(notification:)), name: NSNotification.Name(rawValue: OCTOpenFileNotification), object: nil)
        
        if FileName.count > 0 {
            
            updateRelationView(filename: FileName)
        }
    }
    
    
    @objc func handleOpenFile(notification: Notification) {
        
        guard let filename = notification.object as? String else {
            return
        }
        
        updateRelationView(filename: filename)
    }
    
    func updateRelationView(filename: String) {
        
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
                
                relationView.prettyRelation = PrettyRelation(dependency: dependency)
                alert(title: "Info", msg: "loaded \(filename)")
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
            alert(title: "Info", msg: "loaded \(filename)")
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

}

