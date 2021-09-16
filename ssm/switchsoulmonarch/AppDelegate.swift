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
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
    let userDefaults = UserDefaults()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        userDefaults.set([], forKey: "apps")

        self.statusItem.button?.image = NSImage(named: "icon")

        // set HotKey
        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyComboTmp as! Data) as! KeyCombo
            MenuItemManager().setMainMenu(keyCombo: keyCombo!)
        }

        self.statusItem.menu = MenuItemManager().getMenus()

        // check update
        //  let updater = SUUpdater.shared()
        //  updater?.feedURL = URL(string: "https://kyu-suke.github.io/appcast.xml")
        //  updater?.automaticallyChecksForUpdates = true
        //  updater?.updateCheckInterval = 86400

    }
    
    @objc func quit(_ sender: Any){
        NSApplication.shared.terminate(self)
    }
    
    @objc func preferences(_ sender: NSMenuItem){
        MenuItemManager().setLaunchApp(appName: sender.title)
    }

    @objc func show(_ sender: NSMenuItem){
        self.preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
        self.preferencesWindow.showWindow(self)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

