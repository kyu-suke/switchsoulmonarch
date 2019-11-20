//
//  SettingApps.swift
//  switchsoulmonarch
//
//  Created by 金岡 勇佑 on 2018/12/19.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa

class SettingApps: NSObject {
    let userDefaults = UserDefaults()

    func getApps() -> [App] {
        if let storedData = UserDefaults.standard.object(forKey: "apps") as? Data {
            if let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? [App] {
                return unarchivedObject
            }
        }
        return []
    }

    func setApps(apps: [App]) {
        var paths: [[String:String]] = []
        apps.forEach { (app) in
            paths.append(["path" : app.path, "hotKey": app.hotKey])
        }

        let appData = try! NSKeyedArchiver.archivedData(withRootObject: apps, requiringSecureCoding: false)
        UserDefaults.standard.set(appData, forKey: "apps")
    }

}
