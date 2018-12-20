//
//  MenuItemUtil.swift
//  switchsoulmonarch
//
//  Created by kyusuke on 2018/11/18.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa

class MenuItemUtil: NSObject {
        
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
}
