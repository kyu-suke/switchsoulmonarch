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

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var ctrlEisuRadio: NSButton!
    @IBOutlet weak var ctrlKanaRadio: NSButton!
    @IBOutlet weak var appStackView: NSStackView!
    
    var appCount = 0

    @IBAction func buttonClick(_ sender: NSButton) {
        hotKeyRadios.forEach { $0.state = NSControl.StateValue(rawValue: 0) }
        sender.state = NSControl.StateValue(rawValue: 1)
        switch sender.identifier!.rawValue {
        case "ctrlEisu":
            if let keyCombo = KeyCombo(keyCode: kVK_JIS_Eisu, cocoaModifiers: .control) {
            MenuItemManager().setMainMenu(keyCombo: keyCombo)
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
            }
        case "ctrlKana":
            if let keyCombo = KeyCombo(keyCode: kVK_JIS_Kana, cocoaModifiers: .control) {
            MenuItemManager().setMainMenu(keyCombo: keyCombo)
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
            }
        default:
            print("else")
        }
    }
    
    let userDefaults = UserDefaults()
    var hotKeyRadios: [NSButton]!

    func windowWillClose(_ notification: Notification) {
        print("CLOOOOOOOOOOOOO")
        MenuItemManager().setMenus()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        hotKeyRadios = [ctrlEisuRadio, ctrlKanaRadio]

        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))

        recordView.tintColor = NSColor(red: 0.164, green: 0.517, blue: 0.823, alpha: 1)

        let appButton = NSButton(frame: NSMakeRect(20,50,70,20))
        appButton.title = "Add App"
        appButton.action = #selector(addApp(_:))

        window?.contentView?.addSubview(appButton)
        self.window!.delegate = self

    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(self)

        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: keyComboTmp as! Data) as? KeyCombo

            recordView.keyCombo = keyCombo
        }
        recordView.delegate = self

        // set HotKey
        if let apps = userDefaults.array(forKey: "apps") {
            var i = 0
            for ap in apps {
                let rectY = getRectY()
                let a: [String:String] = ap as! [String : String]

                // app url
                let app = AppHotKeyTextField(frame: NSMakeRect(0, rectY, 180, 20))
                app.identifier = NSUserInterfaceItemIdentifier(rawValue: "path:\(i)")
                app.stringValue = a["path"]!
                appStackView.addSubview(app)
//                let leadingConstraint = app.topAnchor.constraint(equalTo:self.recordView.bottomAnchor, constant: 30.0)
//                leadingConstraint.isActive = true

                // app hot key
                let hotKey = AppHotKeyTextField(frame: NSMakeRect(200, rectY, 50, 20))
                hotKey.identifier = NSUserInterfaceItemIdentifier(rawValue: "key:\(i)")
                hotKey.stringValue = a["key"]!
                appStackView.addSubview(hotKey)

                // app del button
                let delBtn = NSButton(frame: NSMakeRect(270, rectY, 50, 20))
                delBtn.title = "delete"
                appStackView.addSubview(delBtn)
                i += 1
            }
        }

    }
    
    func getRectY() -> CGFloat {
        appCount += 1
        return CGFloat(20 - (self.appCount * 25))
    }

    @objc func hotkeyCalled() {
        print("HotKey called!!!!")
    }
 
    @objc func addApp(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        openPanel.canChooseDirectories = false // ディレクトリを選択できるか
        openPanel.canCreateDirectories = false // ディレクトリを作成できるか
        openPanel.canChooseFiles = true // ファイルを選択できるか
        // openPanel.allowedFileTypes = NSImage.imageTypes // 選択できるファイル種別
        openPanel.allowedFileTypes = ["app"]
        
        openPanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
        
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
    
                let rectY = self.getRectY()

                guard let url = openPanel.url else { return }
                let qa = sender.frame

                // app url
                let app = NSTextField(frame: NSMakeRect(0, rectY, 180, qa.height))
                app.stringValue = url.path
                self.appStackView.addSubview(app)

                // app hot key
                let hotKey = AppHotKeyTextField(frame: NSMakeRect(200, rectY, 50, qa.height))
                self.appStackView.addSubview(hotKey)
                
                // app del button
                let delBtn = NSButton(frame: NSMakeRect(270, rectY, 50, qa.height))
                delBtn.title = "delete"
                self.appStackView.addSubview(delBtn)

                let frame = (self.window?.frame)!
                let a = CGRect(x: frame.minX, y: frame.minY - 25, width: frame.width, height: frame.height + 25)
                self.window?.setFrame(a, display: false, animate: false)
                
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
        MenuItemManager().setMainMenu(keyCombo: keyCombo)
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
    }
}
