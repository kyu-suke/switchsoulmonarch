//
//  PreferencesWindowController.swift
//  switchsoulmonarch
//
//  Created by 金岡 勇佑 on 2018/11/19.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa
class PreferencesWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        print("AAAAAAAA")
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
    }
}

