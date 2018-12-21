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
    // set MenuItems

    let menuItemUtil = MenuItemUtil()

    @objc func getMenus() -> NSMenu {
        SettingApps.apps.setAppList()
        let apps = SettingApps.apps.getApps()
        var m = NSMenu()
        for app in apps {
            print(app)
            let a: [String:String] = app as! [String : String]
            let path = a["path"]!
            let key = a["key"]!
            print(path)
            m.addItem(self.menuItemUtil.makeAppItem(appName: path, shortcutKey: key))
        }
        m.addItem(self.menuItemUtil.makePreferencesItem())
        m.addItem(self.menuItemUtil.makeQuitItem())

        return m
    }

    @objc func setMainMenu(keyCombo: KeyCombo) {
        print("VVVVVVVVVV")
        HotKeyCenter.shared.unregisterHotKey(with: "mainMenuHotKey")
        let hotKey = HotKey(identifier: "mainMenuHotKey", keyCombo: keyCombo, target: AppDelegate(), action: #selector(AppDelegate.showMainMenu))
        hotKey.register()
    }

}
