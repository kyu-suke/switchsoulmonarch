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
    var app_list: [[String:String]] = []
    let userDefaults = UserDefaults()

    func setAppList() {
        self.app_list = []
        if let apps = userDefaults.array(forKey: "apps") {
            for app in apps {
                let a = app as! [String:String]
                self.app_list.append(a)
            }
        }
    }

    func getApps() -> [[String:String]] {
        return self.app_list
    }
    
//    func setApps(apps: [App]) {
//        var paths: [String] = []
//        apps.forEach { (app) in
//            let url = app.path
//            paths.append(url)
//        }
//        userDefaults.set(paths, forKey: "apps")
//
////        print("CCCCCCCCCCCC")
////print(        userDefaults.array(forKey: "apps"))
////        print("AAAAAAAAAAAAAAAAAAAA")
//    }

    func setApps(apps: [App]) {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        var paths: [[String:String]] = []
        apps.forEach { (app) in
            let url = app.path
            paths.append(["path" : app.path, "hotKey": app.hotKey])
        }
        userDefaults.set(paths, forKey: "apps")
    }

}
