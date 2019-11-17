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

class App: NSObject{
    @objc dynamic var appName: String
    @objc dynamic var path: String
    @objc dynamic var hotKey: String
    @objc dynamic var icon: NSImage
    
    init(url: URL, hotKey: String){
        let hoge = NSWorkspace.shared.icon(forFile: url.path)
        self.icon = hoge
        
        // app url
        self.path = url.path
        self.appName = url.lastPathComponent.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true).first?.description ?? ""
        
        self.hotKey = hotKey
    }
    
}

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet var appsArrayController: NSArrayController!
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var appStackView: NSStackView!
    @IBOutlet weak var appCollectionView: NSCollectionView!
    
    @IBAction func addApp(_ sender: Any) {
        addApp2(sender as! NSButton)
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

    @objc dynamic var settedApps = [App]()

    func windowWillClose(_ notification: Notification) {
        
        let a = arrayController.arrangedObjects as! [App]
        SettingApps.apps.setApps(apps: a)
        MenuItemManager().setMenus()
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
        recordView.tintColor = NSColor(red: 0.164, green: 0.517, blue: 0.823, alpha: 1)
        self.window!.delegate = self

    }


    override func showWindow(_ sender: Any?) {
        super.showWindow(self)

        if let keyComboTmp = userDefaults.object(forKey: "mainMenuHotKeyKeyCombo") {
            let keyCombo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keyComboTmp as! Data) as! KeyCombo
            recordView.keyCombo = keyCombo
        }
        recordView.delegate = self

        var settedApps: [App] = []
        if let apps = userDefaults.array(forKey: "apps") {
            for ap in apps {
                let a = ap as! [String:String]
                let url = URL(fileURLWithPath: a["path"]!)
                let app = App(url: url, hotKey: a["hotKey"]!)
                settedApps.append(app)
            }
        }

        self.settedApps = settedApps
        
        self.appCollectionView.delegate = self as? NSCollectionViewDelegate
        self.appCollectionView.dataSource = self as? NSCollectionViewDataSource
        
        self.appCollectionView.register(NSNib.init(nibNamed: "SampleItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("SampleItem") )
        self.appCollectionView.content = self.settedApps
        self.appCollectionView.isSelectable = true

        self.appCollectionView.reloadData()
        
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
                guard let url = openPanel.url else { return }

                let app = App(url: url, hotKey: "")
                self.settedApps.append(app)
                self.appCollectionView.reloadData()

                SettingApps.apps.setApps(apps: self.settedApps)
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

extension PreferencesWindowController: RecordViewDelegate, NSCollectionViewDelegate {
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
        do {
            userDefaults.set(try NSKeyedArchiver.archivedData(withRootObject: keyCombo, requiringSecureCoding: true), forKey: "mainMenuHotKeyKeyCombo")
        } catch {
            
        }
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

