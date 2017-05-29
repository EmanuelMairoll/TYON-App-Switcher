//
//  TableController.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 28/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class TableData: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Applications.selectedList().count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result:NSApplicationView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSApplicationView
        result.textField!.stringValue = Applications.selectedList()[row].displayName
        result.detailTextField!.stringValue = Applications.selectedList()[row].bundleId
        result.imageView!.image = Applications.selectedList()[row].icon
        return result
    }
    
}

class NSApplicationView: NSTableCellView {
    @IBOutlet weak var detailTextField: NSTextField!
}
