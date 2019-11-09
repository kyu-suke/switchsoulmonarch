//
//  SampleItem.swift
//  switchsoulmonarch
//
//  Created by kyusuke on 2019/11/09.
//  Copyright © 2019 kyusuke. All rights reserved.
//

import Cocoa

class SampleItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    func updateBG() {
        if isSelected {
            self.view.layer?.backgroundColor = NSColor(deviceWhite: 1.0, alpha: 0.3).cgColor
        } else {
            self.view.layer?.backgroundColor = CGColor.clear
        }
    }

}
