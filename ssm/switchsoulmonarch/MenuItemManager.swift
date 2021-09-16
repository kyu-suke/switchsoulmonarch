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
        
        let menu = NSMenu()
        for app in SettingApps().getApps() {
            menu.addItem(makeAppItem(appName: app.path, shortcutKey: app.hotKey))
        }
        menu.addItem(makePreferencesItem())
        menu.addItem(makeQuitItem())

        return menu
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

    @objc func showMainMenu() {
        let menu = self.getMenus()
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }

}
