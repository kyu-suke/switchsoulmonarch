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

struct App {
    var appName: String
    var path: String
    var hotKey: String
    var icon: NSImage
    
    init(url: URL){
        let hoge = NSWorkspace.shared.icon(forFile: url.path)
        //            let fuga = NSImageView(image: hoge)
        self.icon = hoge
        
        // app url
        self.path = url.path
        self.appName = url.lastPathComponent.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true).first?.description ?? ""
        
        // app hot key
        //            let hotKey = NSTextField(frame: NSMakeRect(200, rectY, 50, qa.height))
        //            hotKey.identifier = NSUserInterfaceItemIdentifier(rawValue: "key:\(self.identCount)")
        self.hotKey = ""
    }
    
}

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var appStackView: NSStackView!
    @IBOutlet weak var appCollectionView: NSCollectionView!
    
    @IBAction func addApp(_ sender: Any) {
        addApp2(sender as! NSButton)
    }

    @IBAction func addButton(_ sender: Any) {
//        settedApps.append("W") //例えば
        appCollectionView.reloadData()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        guard let n = appCollectionView.selectionIndexPaths.first?.item else { return }
        let item = appCollectionView.item(at: n) as! SampleItem
        item.isSelected = false
        item.updateBG()
        settedApps.remove(at: n)
        appCollectionView.reloadData()
    }
    
    var appCount = 0
    var identCount = 0
    
    let userDefaults = UserDefaults()

    var settedApps: [App] = []

    func windowWillClose(_ notification: Notification) {
//        SettingApps.apps.setApps(apps: [])
//        SettingApps.apps.setAppList()
//        var apps: [Int : [String:String]] = [:]
//        appStackView!.subviews.forEach {
//            guard let identifier = $0.identifier else {
//                return
//            }
//            let ident = identifier.rawValue.split(separator: ":")
//
//            if ident[0] == "del" {
//                return
//            }
//
//            print("sssssssssssssssssssssssssssssssssss")
//            print(ident)
//            let appHotKeyTextField = $0 as! NSTextField
//            let k = Int(ident[1])!
//            let t = ident[0]
//
//            if let value = apps[k] {
//                print(value)
//            } else {
//                apps[k] = ["path":"", "key":""]
//            }
//            var app: [String : String] = apps[k]!
//            if t == "path" {
//                app = [
//                    "path": appHotKeyTextField.stringValue,
//                    "key": app["key"]!
//                ]
//
//            } else if t == "key" {
//                app = [
//                    "path": app["path"]!,
//                    "key": appHotKeyTextField.stringValue
//                ]
//
//            }
//            apps[k] = app
//
//        }
//        var apppppp: [[String:String]] = []
//        apps.forEach {
//            apppppp.append($0.value)
//        }
//        SettingApps.apps.setApps(apps: apppppp)
//        MenuItemManager().setMenus()
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))

        recordView.tintColor = NSColor(red: 0.164, green: 0.517, blue: 0.823, alpha: 1)

//        let appButton = NSButton(frame: NSMakeRect(20,50,70,20))
//        appButton.title = "Add App"
//        appButton.action = #selector(addApp(_:))
//
//        window?.contentView?.addSubview(appButton)
        self.window!.delegate = self

    }


    override func showWindow(_ sender: Any?) {
        super.showWindow(self)

        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: keyComboTmp as! Data) as? KeyCombo

            recordView.keyCombo = keyCombo
        }
        recordView.delegate = self

        var settedApps: [App] = []
        if let apps = userDefaults.array(forKey: "apps") {
            for ap in apps {
                let rectY = getRectY()
                let a: String = ap as! String
                let url = URL(fileURLWithPath: a)
                let app = App(url: url)
                settedApps.append(app)
            }
        }
        self.settedApps = settedApps

        appCollectionView.delegate = self as? NSCollectionViewDelegate
        appCollectionView.dataSource = self as? NSCollectionViewDataSource
        let nib = NSNib(nibNamed: "SampleItem", bundle: nil)
        appCollectionView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "sample"))
        appCollectionView.isSelectable = true
        appCollectionView.reloadData()



//        let hoge: Set = ["a", "b", "c"]

        // set HotKey
//        if let apps = userDefaults.array(forKey: "apps") {
//            identCount = 0
//            for ap in apps {
//                let rectY = getRectY()
//                let a: String = ap as! String
//                let url = URL(fileURLWithPath: a)
//                let app = App(url: url)
//                let path = app.path
//                let key = app.hotKey
//
//                // app url
//                let app = NSTextField(frame: NSMakeRect(0, rectY, 180, 20))
//                app.identifier = NSUserInterfaceItemIdentifier(rawValue: "path:\(identCount)")
//                app.stringValue = app.path
//                appStackView.addSubview(app)
////                appCollectionView.makeItem(withIdentifier: [], for: [])
//
//
//                // app hot key
//                let hotKey = NSTextField(frame: NSMakeRect(200, rectY, 50, 20))
//                hotKey.identifier = NSUserInterfaceItemIdentifier(rawValue: "key:\(identCount)")
//                hotKey.stringValue = a["key"]!
//                appStackView.addSubview(hotKey)
//
//                // app del button
//                let delBtn = NSButton(frame: NSMakeRect(270, rectY, 50, 20))
//                delBtn.identifier = NSUserInterfaceItemIdentifier(rawValue: "del:\(identCount)")
//                delBtn.title = "delete"
//                delBtn.action = #selector(delApp(_:))
//                appStackView.addSubview(delBtn)
//                identCount += 1
//            }
//        }

    }
    
    func getRectY() -> CGFloat {
        appCount += 1
        return CGFloat(180 + (self.appCount * -25))
    }

    @objc func hotkeyCalled() {
        print("HotKey called!!!!")
    }
 
    @objc func addApp2(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["app"]
        openPanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                

                let rectY = self.getRectY()

                guard let url = openPanel.url else { return }
                let qa = sender.frame

                var app: App = App(url: url)
                self.settedApps.append(app)
                self.appCollectionView.reloadData()

                SettingApps.apps.setApps(apps: self.settedApps)

//
//
//
//                let hoge = NSWorkspace.shared.icon(forFile: url.path)
//                let fuga = NSImageView(frame: NSMakeRect(-100, rectY, 180, qa.height))
//                fuga.image = hoge
////                self.appStackView.addSubview(fuga)
//
//
//                print(hoge)
//
//                // app url
//                let app = NSTextField(frame: NSMakeRect(0, rectY, 180, qa.height))
//                app.identifier = NSUserInterfaceItemIdentifier(rawValue: "path:\(self.identCount)")
//                app.stringValue = url.path
////                self.appStackView.addSubview(app)
//
//                // app hot key
//                let hotKey = NSTextField(frame: NSMakeRect(200, rectY, 50, qa.height))
//                hotKey.identifier = NSUserInterfaceItemIdentifier(rawValue: "key:\(self.identCount)")
////                self.appStackView.addSubview(hotKey)
//
//                // app del button
//                let delBtn = NSButton(frame: NSMakeRect(270, rectY, 50, qa.height))
//                delBtn.identifier = NSUserInterfaceItemIdentifier(rawValue: "del:\(self.identCount)")
//                delBtn.title = "delete"
//                delBtn.action = #selector(self.delApp(_:))
////                self.appStackView.addSubview(delBtn)
//
//                // higher window height
//                let frame = (self.window?.frame)!
//                let a = CGRect(x: frame.minX, y: frame.minY - 25, width: frame.width, height: frame.height + 25)
//                self.window?.setFrame(a, display: false, animate: false)
//
//                self.identCount += 1
            }
        }
    }
    
    @objc func delApp(_ sender: NSButton) {
        let delIdent = sender.identifier?.rawValue.split(separator: ":")[1]
        appStackView!.subviews.forEach {
            guard let identifier = $0.identifier else {
                return
            }
            let ident = identifier.rawValue.split(separator: ":")
            
            if ident[1] == delIdent {
                $0.removeFromSuperview()
            }
        }
    }
}

extension PreferencesWindowController: RecordViewDelegate,NSCollectionViewDelegate, NSCollectionViewDataSource {
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
//        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: keyCombo), forKey: "mainMenuHotKeyKeyCombo")
        do {
            userDefaults.set(try NSKeyedArchiver.archivedData(withRootObject: keyCombo, requiringSecureCoding: true), forKey: "mainMenuHotKeyKeyCombo")
        } catch {
            
        }
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return settedApps.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        // アイテムの用意
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "sample"), for: indexPath) as! SampleItem
        item.textField?.stringValue = settedApps[indexPath.item].appName
        item.imageView?.image = settedApps[indexPath.item].icon
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let count = collectionView.numberOfItems(inSection: 0)
        for n in (0 ..< count) {
            (collectionView.item(at: n) as! SampleItem).updateBG()
        }
    }

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        let count = collectionView.numberOfItems(inSection: 0)
        for n in (0 ..< count) {
            (collectionView.item(at: n) as! SampleItem).updateBG()
        }
    }
}

