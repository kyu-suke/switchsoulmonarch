//
//  AppDelegate.swift
//  switchsoulmonarch
//
//  Created by kyusuke on 2018/11/18.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    
    let menuItemUtil: MenuItemUtil = MenuItemUtil()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    let preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem.button?.image = NSImage(named: "icon")

        self.statusItem.menu = menu

        if let keyCombo = KeyCombo(keyCode: 104, cocoaModifiers: .control) {
            let hotKey = HotKey(identifier: "CommandM", keyCombo: keyCombo, target: self, action: #selector(AppDelegate.tappedHotKey))
            hotKey.register()
        }
        
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "iTerm.app", shortcutKey: "i"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Google Chrome.app", shortcutKey: "g"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Franz.app", shortcutKey: "r"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Finder.app", shortcutKey: "f"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Xcode", shortcutKey: "x"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "MacVim", shortcutKey: "v"))

        menu.addItem(self.menuItemUtil.makePreferencesItem())
        menu.addItem(self.menuItemUtil.makeQuitItem())

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func tappedHotKey() {
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }
    
    @objc func quit(_ sender: Any){
        //アプリケーションの終了
        NSApplication.shared.terminate(self)
    }
    
    @objc func preferences(_ sender: NSMenuItem){
        self.menuItemUtil.setLaunchApp(appName: sender.title)
    }

    @objc func show(_ sender: NSMenuItem){
        preferencesWindow.showWindow(self)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}

