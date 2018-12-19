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
        let ident = (identifier?.rawValue)!.split(separator: ":")
        print(identifier?.rawValue ?? "none")
        let k = Int(ident[1])!
        print(k)
        let apps = SettingApps.apps.getApps()
        print(apps[k])
//        apps[k] = ["path": , "key": ]
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
}
