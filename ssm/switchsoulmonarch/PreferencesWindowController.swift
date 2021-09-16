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

class App: NSObject, NSCoding{
    @objc dynamic var appName: String
    @objc dynamic var path: String
    @objc dynamic var hotKey: String
    @objc dynamic var icon: NSImage
    
    var isAddButton: Bool

    init(url: URL, hotKey: String, isAddButton: Bool){

        if isAddButton {
            self.icon = NSImage(named: "plus")!
            self.path = ""
            self.appName = ""
            self.hotKey = ""
            self.isAddButton = isAddButton

        } else {
            let hoge = NSWorkspace.shared.icon(forFile: url.path)
            self.icon = hoge
            
            // app url
            self.path = url.path
            self.appName = url.lastPathComponent.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true).first?.description ?? ""
            
            self.hotKey = hotKey
            self.isAddButton = isAddButton
        }
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let path        = aDecoder.decodeObject(forKey: "path") as! String
        let hotKey      = aDecoder.decodeObject(forKey: "hotKey") as! String
        self.init(url: URL(fileURLWithPath: path), hotKey: hotKey, isAddButton: false)
    }
    

    func encode(with aCoder: NSCoder) {
        aCoder.encode(path, forKey: "path")
        aCoder.encode(hotKey, forKey: "hotKey")
    }

}

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet var appsArrayController: NSArrayController!
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var appStackView: NSStackView!
    @IBOutlet weak var appCollectionView: NSCollectionView!
        
    @IBAction func deleteButton(_ sender: Any) {
        guard let n = appCollectionView.selectionIndexPaths.first?.item else { return }
        let item = appCollectionView.item(at: n) as! SampleItem
        item.isSelected = false
        item.updateBG()
        settedApps.remove(at: n)
        appCollectionView.reloadData()
    }
        
    let userDefaults = UserDefaults()

    @objc dynamic var settedApps = [App]()

    func windowWillClose(_ notification: Notification) {
        let a = arrayController.arrangedObjects as! [App]
        SettingApps().setApps(apps: a.filter({ (app) -> Bool in
            return !app.isAddButton
        }))
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

        var settedApps: [App] = SettingApps().getApps()

        // add plus button
        let plusButton = App(url: URL(fileURLWithPath: ""), hotKey: "", isAddButton: true)
        settedApps.append(plusButton)

        self.settedApps = settedApps
        
        self.appCollectionView.delegate = self as NSCollectionViewDelegate
        self.appCollectionView.dataSource = self as? NSCollectionViewDataSource
        self.appCollectionView.register(NSNib.init(nibNamed: "SampleItem", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("SampleItem") )
        self.appCollectionView.content = self.settedApps
        self.appCollectionView.isSelectable = true
        self.appCollectionView.reloadData()
    }
 
    @objc func addApp(_ sender: NSButton) {
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

                let app = App(url: url, hotKey: "", isAddButton: false)
                let plusButton = self.settedApps.popLast()!
                self.settedApps.append(app)
                self.settedApps.append(plusButton)
                self.appCollectionView.reloadData()

                SettingApps().setApps(apps: self.settedApps)
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
            let item = collectionView.item(at: n) as! SampleItem
            if item.isSelected && self.settedApps[n].isAddButton {
                self.addApp(NSButton())
            }
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

