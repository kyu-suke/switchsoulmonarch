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

    let menuItemUtil: MenuItemUtil = MenuItemUtil()

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    let preferencesWindow = PreferencesWindowController(windowNibName: "PreferencesWindowController")
    
    let userDefaults = UserDefaults()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem.button?.image = NSImage(named: "icon")


//        if let keyCombo = KeyCombo(keyCode: 104, cocoaModifiers: .control) {
//            let hotKey = HotKey(identifier: "CommandM", keyCombo: keyCombo, target: self, action: #selector(AppDelegate.tappedHotKey))
//            hotKey.register()
//        }
        
        // set HotKey
        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: keyComboTmp as! Data) as? KeyCombo
            let hotKey = HotKey(identifier: "mainMenuHotKey", keyCombo: keyCombo!, target: self, action: #selector(AppDelegate.showMainMenu))
            hotKey.register()
        }

//        userDefaults.set([
//            [
//                "path": "/Applications/iTerm.app",
//                "key":  "i"
//            ],
//            [
//                "path": "/Applications/Google Chrome.app",
//                "key":  "g"
//            ],
//            [
//                "path": "/Applications/Franz.app",
//                "key":  "r"
//            ],
//            [
//                "path": "/Applications/Finder.app",
//                "key":  "f"
//            ],
//            [
//                "path": "/Applications/Xcode",
//                "key":  "x"
//            ],
//            [
//                "path": "/Applications/MacVim",
//                "key":  "v"
//            ],
//            ], forKey: "apps")

        // set HotKey
        if let apps = userDefaults.array(forKey: "apps") {
            print(apps)
            for app in apps {
                print(app)
                let a: [String:String] = app as! [String : String]
                let path = a["path"]!
                let key = a["key"]!
                menu.addItem(self.menuItemUtil.makeAppItem(appName: path, shortcutKey: key))
            }
        }
        
        // ここを関数にするとクリックしてもメニューがでてこない
//        menu.addItem(self.menuItemUtil.makeAppItem(appName: "/Applications/iTerm.app", shortcutKey: "i"))
//        menu.addItem(self.menuItemUtil.makeAppItem(appName: "/Applications/Google Chrome.app", shortcutKey: "g"))
//        menu.addItem(self.menuItemUtil.makeAppItem(appName: "/Applications/Franz.app", shortcutKey: "r"))
//        menu.addItem(self.menuItemUtil.makeAppItem(appName: "/Applications/Finder.app", shortcutKey: "f"))
//        menu.addItem(self.menuItemUtil.makeAppItem(appName: "/Applications/Xcode", shortcutKey: "x"))
//        menu.addItem(self.menuItemUtil.makeAppItem(appName: "/Applications/MacVim", shortcutKey: "v"))

        menu.addItem(self.menuItemUtil.makePreferencesItem())
        menu.addItem(self.menuItemUtil.makeQuitItem())

        self.statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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

    func setMainmenu() -> NSMenu {

        let menu = NSMenu()
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "iTerm.app", shortcutKey: "i"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Google Chrome.app", shortcutKey: "g"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Franz.app", shortcutKey: "r"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Finder.app", shortcutKey: "f"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "Xcode", shortcutKey: "x"))
        menu.addItem(self.menuItemUtil.makeAppItem(appName: "MacVim", shortcutKey: "v"))
        
        menu.addItem(self.menuItemUtil.makePreferencesItem())
        menu.addItem(self.menuItemUtil.makeQuitItem())
        return menu
    }

    @objc func showMainMenu() {
        let menu = setMainmenu()
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }

    @objc func setMainMenu(keyCombo: KeyCombo) {
        print("VVVVVVVVVV")
        HotKeyCenter.shared.unregisterHotKey(with: "mainMenuHotKey")
        let hotKey = HotKey(identifier: "mainMenuHotKey", keyCombo: keyCombo, target: self, action: #selector(showMainMenu))
        hotKey.register()
    }    
}

