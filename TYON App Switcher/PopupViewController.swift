//
//  PopupViewController.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 30/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class PopupViewController: NSViewController {
    
    @IBOutlet weak var applicationTable: NSTableView!
    @IBOutlet weak var modeSelection: NSSegmentedControl!
    
    override func viewDidAppear() {
        modeSelection.selectedSegment = Applications.selectedIndex()
        Applications.setDrawnIndex(index: Applications.selectedIndex())
        applicationTable.reloadData()
    }
    
    @IBAction func indexChanged(_ sender: NSSegmentedControl){
        Applications.setDrawnIndex(index: modeSelection.selectedSegment)
        applicationTable.reloadData()
    }
    
    @IBAction func quitButtonClicked(_ sender: NSButton) {
         NSApplication.shared().terminate(self)
    }
    
    @IBAction func customButtonClicked(_ sender: NSButton) {
        /*
         let dialog = NSOpenPanel();
         
         dialog.title                   = "Choose a Application Bundle";
         dialog.showsResizeIndicator    = true;
         dialog.showsHiddenFiles        = false;
         dialog.canChooseDirectories    = false;
         dialog.canCreateDirectories    = false;
         dialog.allowsMultipleSelection = false;
         dialog.allowedFileTypes        = ["app"];
         
         if (dialog.runModal() == NSModalResponseOK) {
         if let url = dialog.url {
         let bundle = Bundle(path: url.path)!
         
         let name = bundle.localizedInfoDictionary?["kCFBundleNameKey"]
         let id = bundle.bundleIdentifier
         let icon = bundle.image(forResource: "resources/icon.icns")
         
         print(name)
         print(id)
         print(icon)
         }
         } else {
         return
         }
         */
    }
    
    @IBAction func currentButtonClicked(_ sender: NSButton) {
        let app = Applications.frontmost()
        if let index = Applications.appendToDrawnAndReturnIndex(application: app){
            applicationTable.insertRows(at: IndexSet(integer: index), withAnimation: NSTableViewAnimationOptions.slideDown)
            Applications.save()
        }else{
            NSBeep()
        }
    }
    
    @IBAction func removeButtonClicked(_ sender: NSButton) {
        let index = applicationTable.selectedRow
        if (index != -1){
            Applications.modes[modeSelection.selectedSegment].remove(at: index)
            applicationTable.removeRows(at: IndexSet(integer: index), withAnimation: NSTableViewAnimationOptions.slideUp)
        }else{
            NSBeep()
        }
    }
    
}
