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
        return Applications.drawnList().count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result:NSApplicationView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSApplicationView
        result.textField!.stringValue = Applications.drawnList()[row].displayName
        result.detailTextField!.stringValue = Applications.drawnList()[row].bundleId
        result.imageView!.image = Applications.drawnList()[row].icon
        return result
    }
}

class NSApplicationView: NSTableCellView {
    @IBOutlet weak var detailTextField: NSTextField!
}
