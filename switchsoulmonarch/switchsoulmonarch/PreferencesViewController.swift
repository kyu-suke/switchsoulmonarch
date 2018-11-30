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
import Carbon

class PreferencesWindowController: NSWindowController {

    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var ctrlEisuRadio: NSButton!
    @IBOutlet weak var ctrlKanaRadio: NSButton!
    


    @IBAction func buttonClick(_ sender: NSButton) {
        hotKeyRadios.forEach { $0.state = NSControl.StateValue(rawValue: 0) }
        sender.state = NSControl.StateValue(rawValue: 1)
        print(UInt16(kVK_JIS_Kana))
        print(UInt16(kVK_JIS_Eisu))
        switch sender.identifier!.rawValue {
        case "ctrlEisu":
            if let keyCombo = KeyCombo(keyCode: kVK_JIS_Eisu, cocoaModifiers: .control) {
            AppDelegate().setMainMenu(keyCombo: keyCombo)
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
            }
        case "ctrlKana":
            if let keyCombo = KeyCombo(keyCode: kVK_JIS_Kana, cocoaModifiers: .control) {
            AppDelegate().setMainMenu(keyCombo: keyCombo)
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
            }
        default:
            print("else")
        }
    }
    
    let userDefaults = UserDefaults()
    var hotKeyRadios: [NSButton]!

    override func windowDidLoad() {
        super.windowDidLoad()
        hotKeyRadios = [ctrlEisuRadio, ctrlKanaRadio]

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

    }

    @objc func hotkeyCalled() {
        print("HotKey called!!!!")
    }


    @IBAction func openFile(_ sender: Any) {
        print("afdasdfadadsf")
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        openPanel.canChooseDirectories = false // ディレクトリを選択できるか
        openPanel.canCreateDirectories = false // ディレクトリを作成できるか
        openPanel.canChooseFiles = true // ファイルを選択できるか
        // openPanel.allowedFileTypes = NSImage.imageTypes // 選択できるファイル種別
        openPanel.allowedFileTypes = ["app"]
        
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSFileHandlingPanelOKButton {  // ファイルを選択したか(OKを押したか)
                guard let url = openPanel.url else { return }
                print(url.path)
                NSWorkspace.shared.launchApplication(url.path)
                // ここでファイルを読み込む
            }
        }
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

        AppDelegate().setMainMenu(keyCombo: keyCombo)
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
    }
}
