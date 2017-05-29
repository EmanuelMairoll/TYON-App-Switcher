//
//  Controller.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 27/modeSelection.selectedSegment5/2modeSelection.selectedSegment17.
//  Copyright © 2modeSelection.selectedSegment17 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class Controller: NSObject{
    
    @IBOutlet weak var modeSelection: NSSegmentedControl!
    @IBOutlet weak var applicationTable: NSTableView!
    
    var frontMostApp: NSRunningApplication = NSWorkspace.shared().frontmostApplication!;
    
    override init(){
        super.init()
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(self.frontmostAppChangedListener), name: NSNotification.Name.NSWorkspaceDidActivateApplication, object: nil)
    }
    
    func frontmostAppChangedListener(){
        if (frontMostApp != NSWorkspace.shared().menuBarOwningApplication!){
            frontMostApp = NSWorkspace.shared().menuBarOwningApplication!
            print("changed to " + frontMostApp.localizedName!)
        }
    }
    
    @IBAction func indexChanged(_ sender: NSSegmentedControl){
        Applications.setSelectedList(index: modeSelection.selectedSegment)
        applicationTable.reloadData()
    }
    
    @IBAction func currentButtonClicked(_ sender: NSButton) {
        let app = Applications.frontmost()
        let index =  Applications.appendToSelectedAndReturnIndex(application: app)
        applicationTable.insertRows(at: IndexSet(integer: index), withAnimation: NSTableViewAnimationOptions.slideDown)
    }
    
    @IBAction func customButtonClicked(_ sender: NSButton) {
        
    }
    
    @IBAction func removeButtonClicked(_ sender: NSButton) {
        let index = applicationTable.selectedRow
        if (index != -1){
            Applications.modes[modeSelection.selectedSegment].remove(at: index)
            applicationTable.removeRows(at: IndexSet(integer: index), withAnimation: NSTableViewAnimationOptions.slideUp)
        }
    }
    
}
