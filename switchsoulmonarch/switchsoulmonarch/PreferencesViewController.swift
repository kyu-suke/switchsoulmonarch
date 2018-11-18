//
//  PreferencesViewController.swift
//  switchsoulmonarch
//
//  Created by kyusuke on 2018/11/19.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    var preferencesWindow:NSWindow?
    var toggle:Bool = false
    var preferencesWindowContoroller: NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @objc func showPreferences(){

        if self.toggle {
            self.preferencesWindowContoroller!.showWindow(nil)

        } else {
            self.preferencesWindow = NSWindow(contentRect: NSMakeRect(0, 0, 640,480),
                                    styleMask: .fullSizeContentView,
                                    backing: NSWindow.BackingStoreType.buffered,
                                    defer: false)
            
            self.preferencesWindow!.styleMask.insert(.titled)
            self.preferencesWindow!.styleMask.insert(.resizable)
            self.preferencesWindow!.styleMask.insert(.miniaturizable)
            self.preferencesWindow!.styleMask.insert(.closable)

            self.preferencesWindow!.title = "SSM | Preferences"
            self.preferencesWindow!.center()
            self.preferencesWindow!.backgroundColor = NSColor(calibratedRed: 255, green: 255, blue: 255, alpha: 1)
            self.preferencesWindow?.level = NSWindow.Level(rawValue: 1)

            self.preferencesWindowContoroller = NSWindowController(window:self.preferencesWindow)
            self.toggle = true
        }
    }
    

}
