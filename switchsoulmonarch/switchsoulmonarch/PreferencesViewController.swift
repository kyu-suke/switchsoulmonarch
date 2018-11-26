//
//  PreferencesWindowController.swift
//  switchsoulmonarch
//
//  Created by 金岡 勇佑 on 2018/11/19.
//  Copyright © 2018 kyusuke. All rights reserved.
//

import Cocoa
import Magnet
import KeyHolder

class PreferencesWindowController: NSWindowController {

    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var kanaHotKeyCheck: NSButtonCell!
    @IBOutlet weak var eisuHotKeyCheck: NSButton!
    
    let userDefaults = UserDefaults()
    override func windowDidLoad() {
        super.windowDidLoad()

        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))

        recordView.tintColor = NSColor(red: 0.164, green: 0.517, blue: 0.823, alpha: 1)

    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(self)

        print(userDefaults.object(forKey: "mainMenuHotKeyKeyCombo"))
        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: keyComboTmp as! Data) as? KeyCombo

            recordView.keyCombo = keyCombo
        }
        recordView.delegate = self
        
        //        if let keyCombo = KeyCombo(keyCode: 104, cocoaModifiers: .control) {
        //            let hotKey = HotKey(identifier: "CommandM", keyCombo: keyCombo, target: self, action: #selector(AppDelegate.tappedHotKey))
        //            hotKey.register()
        //        }
        
//        let hotKey = HotKey(identifier: "KeyHolderExample", keyCombo: keyCombo!, target: self, action: #selector(AppDelegate.hotkeyCalled))
//        hotKey.register()
        

    }

    @objc func hotkeyCalled() {
        print("HotKey called!!!!")
    }
}

extension PreferencesWindowController: RecordViewDelegate {
    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        return true
    }

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        // You can customize validation
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
        print("clear shortcut")
        HotKeyCenter.shared.unregisterHotKey(with: "KeyHolderExample")
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        print("end recording")
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        HotKeyCenter.shared.unregisterHotKey(with: "mainMenuHotKey")
        let hotKey = HotKey(identifier: "mainMenuHotKey", keyCombo: keyCombo, target: self, action: #selector(self.hotkeyCalled))
        hotKey.register()
        print(keyCombo)
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
    }
}
