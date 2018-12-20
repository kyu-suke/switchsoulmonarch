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

    let appSets: [AppSet] = []
    
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
    let menuItemUtil = MenuItemUtil()

    func windowWillClose(_ notification: Notification) {
        print("CLOOOOOOOOOOOOO")
        menuItemUtil.setMenus()
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

        print(userDefaults.object(forKey: "mainMenuHotKeyKeyCombo"))
        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: keyComboTmp as! Data) as? KeyCombo

            recordView.keyCombo = keyCombo
        }
        recordView.delegate = self

        // set HotKey
        if let apps = userDefaults.array(forKey: "apps") {
            var i = 0
            for ap in apps {
                let a: [String:String] = ap as! [String : String]

                // app url
                let app = AppHotKeyTextField(frame: NSMakeRect(100, CGFloat(50 + (i * 25)), 180, 20))
                app.identifier = NSUserInterfaceItemIdentifier(rawValue: "path:\(i)")
                app.stringValue = a["path"]!
                self.window?.contentView?.addSubview(app)
                
                // app hot key
                let hotKey = AppHotKeyTextField(frame: NSMakeRect(300, CGFloat(50 + (i * 25)), 50, 20))
                hotKey.identifier = NSUserInterfaceItemIdentifier(rawValue: "key:\(i)")
                hotKey.stringValue = a["key"]!
                self.window?.contentView?.addSubview(hotKey)
                
                // app del button
                let delBtn = NSButton(frame: NSMakeRect(370, CGFloat(50 + (i * 25)), 50, 20))
                delBtn.title = "delete"
                self.window?.contentView?.addSubview(delBtn)
                i += 1
            }
        }

    }

    @objc func hotkeyCalled() {
        print("HotKey called!!!!")
    }


    @IBAction func openFile(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        openPanel.canChooseDirectories = false // ディレクトリを選択できるか
        openPanel.canCreateDirectories = false // ディレクトリを作成できるか
        openPanel.canChooseFiles = true // ファイルを選択できるか
        // openPanel.allowedFileTypes = NSImage.imageTypes // 選択できるファイル種別
        openPanel.allowedFileTypes = ["app"]

        openPanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))

        openPanel.begin { (result) -> Void in
            if result.rawValue == NSFileHandlingPanelOKButton {
                // ファイルを選択したか(OKを押したか)
                guard let url = openPanel.url else { return }
                print(url.path)
                
                // NSWorkspace.shared.launchApplication(url.path) // app起動
                // ここでファイルを読み込む
            }
        }
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
    
                guard let url = openPanel.url else { return }
                let qa = sender.frame

                // app url
                let app = NSTextField(frame: NSMakeRect(qa.minX + 100, qa.minY, 180, qa.height))
                app.stringValue = url.path
                self.window?.contentView?.addSubview(app)

                // app hot key
                let hotKey = AppHotKeyTextField(frame: NSMakeRect(qa.minX + 300, qa.minY, 50, qa.height))
                self.window?.contentView?.addSubview(hotKey)
                
                // app del button
                let delBtn = NSButton(frame: NSMakeRect(qa.minX + 370, qa.minY, 50, qa.height))
                delBtn.title = "delete"
                self.window?.contentView?.addSubview(delBtn)

                print(url.path)

                // NSWorkspace.shared.launchApplication(url.path) // app起動
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