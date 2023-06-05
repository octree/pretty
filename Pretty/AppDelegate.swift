//
//  AppDelegate.swift
//  MacApp
//
//  Created by Octree on 2018/4/5.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Cocoa

let OCTOpenFileNotification = "OCTOpenFileNotification"
let OCTFindModuleNotification = "OCTFindModuleNotification"
public var FileName = ""

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: OCTOpenFileNotification) , object: filename)
        FileName = filename
        return true
    }
//    
//    func application(_ sender: NSApplication, openFiles filenames: [String]) {
//        
//        
//    }
    
    @IBAction func openDocument(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        if openPanel.runModal() == .OK {
            if let url = openPanel.url {
                print("Selected file: \(url.path)")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: OCTOpenFileNotification) , object: url.path)
                FileName = url.path
            }
        }
    }

}


