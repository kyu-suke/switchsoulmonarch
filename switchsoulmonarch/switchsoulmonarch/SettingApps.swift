//
//  SettingApps.swift
//  switchsoulmonarch
//
//  Created by 金岡 勇佑 on 2018/12/19.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa

class SettingApps: NSObject {
    static let apps = SettingApps()
    var app_list: [[String : String]] = []
    let userDefaults = UserDefaults()

    func setAppList() {
        self.app_list = []
        if let apps = userDefaults.array(forKey: "apps") {
            for app in apps {
                let a: [String:String] = app as! [String : String]
                let path = a["path"]!
                let key = a["key"]!
                self.app_list.append(a)
            }
        }
        
// will run when window is closed
//        setApps(apps: self.app_list)
    }

    func getApps() -> [[String : String]] {
        return self.app_list
    }
    func setApps(apps: [[String : String]]) {
        userDefaults.set(apps, forKey: "apps")
    }
}
