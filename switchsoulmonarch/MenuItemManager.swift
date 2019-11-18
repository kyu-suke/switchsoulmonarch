//
//  MenuItemManager.swift
//  switchsoulmonarch
//
//  Created by 金岡 勇佑 on 2018/12/21.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa
import Magnet
import KeyHolder

class MenuItemManager: NSObject {

    @objc func getMenus() -> NSMenu {
        SettingApps.apps.setAppList()
        let apps = SettingApps.apps.getApps()
        
        let m = NSMenu()
        for app in apps {
            let a = app
            let url = URL(fileURLWithPath: a["path"]!)
            let app = App(url: url, hotKey: a["hotKey"]!, isAddButton: false)
            let path = app.path
            let key = app.hotKey
            m.addItem(makeAppItem(appName: path, shortcutKey: key))
        }
        m.addItem(makePreferencesItem())
        m.addItem(makeQuitItem())

        return m
    }

    @objc func setMainMenu(keyCombo: KeyCombo) {
        HotKeyCenter.shared.unregisterHotKey(with: "mainMenuHotKey")
        let hotKey = HotKey(identifier: "mainMenuHotKey", keyCombo: keyCombo, target: self, action: #selector(showMainMenu))
        hotKey.register()
    }

    func makeAppItem(appName: String, shortcutKey: String) -> NSMenuItem {
        let item = NSMenuItem(title: appName, action: #selector(AppDelegate.preferences(_:)), keyEquivalent: shortcutKey)
        item.keyEquivalentModifierMask = []
        item.action = #selector(AppDelegate.preferences(_:))
        return item
    }
    
    public func setLaunchApp (appName: String) {
        NSWorkspace.shared.launchApplication(appName)
    }
    
    public func makeQuitItem () -> NSMenuItem {
        let quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.action = #selector(AppDelegate.quit(_:))
        return quitItem
    }

    public func makePreferencesItem () -> NSMenuItem {
        let item = NSMenuItem()
        item.title = "Preferences"
        item.action = #selector(AppDelegate.show(_:))
        return item
    }

    public func setMenus() {
        print("MEEEENUUUUUUUUU")
    }

    @objc func showMainMenu() {
        let menu = MenuItemManager().getMenus()
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }

}
