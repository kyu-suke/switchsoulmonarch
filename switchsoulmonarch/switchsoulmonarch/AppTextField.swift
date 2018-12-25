//
//  AppTextField.swift
//  switchsoulmonarch
//
//  Created by 金岡 勇佑 on 2018/12/17.
//  Copyright © 2018 kyusuke. All rights reserved.
//


import Cocoa

class AppHotKeyTextField: NSTextField {
    override func textDidChange(_ notification: Notification) {
//        let ident = (identifier?.rawValue)!.split(separator: ":")
//
//        let k = Int(ident[1])!
//        let t = ident[0]
//
//        var apps = SettingApps.apps.getApps()
//        var app: [String : String] = apps[k]
//        if t == "path" {
//            app = [
//                "path": self.stringValue,
//                "key": app["key"]!
//            ]
//
//        } else if t == "key" {
//            app = [
//                "path": app["path"]!,
//                "key": self.stringValue
//            ]
//
//        }
//        apps[k] = app
//        SettingApps.apps.setApps(apps: apps)
    }

}
