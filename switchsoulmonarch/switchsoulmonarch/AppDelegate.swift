//
//  AppDelegate.swift
//  switchsoulmonarch
//
//  Created by kyusuke on 2018/11/18.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa
import Magnet
import KeyHolder

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
    let userDefaults = UserDefaults()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem.button?.image = NSImage(named: "icon")

        // set HotKey
        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: keyComboTmp as! Data) as? KeyCombo
            MenuItemManager().setMainMenu(keyCombo: keyCombo!)
        }

        self.statusItem.menu = MenuItemManager().getMenus()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func quit(_ sender: Any){
        NSApplication.shared.terminate(self)
    }
    
    @objc func preferences(_ sender: NSMenuItem){
        MenuItemUtil().setLaunchApp(appName: sender.title)
    }

    @objc func show(_ sender: NSMenuItem){
        preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
        preferencesWindow.showWindow(self)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    @objc func showMainMenu() {
        let menu = MenuItemManager().getMenus()
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }

}

