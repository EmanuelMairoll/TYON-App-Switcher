//
//  MouseInterface.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 24/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class MouseInterface: NSObject {

    var frontMostApp: NSRunningApplication?;
    
    override func awakeFromNib() {
       NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(self.frontmostAppChangedHook), name: NSNotification.Name.NSWorkspaceDidActivateApplication, object: nil)
    }
    
    func frontmostAppChangedHook(){
        frontMostApp = NSWorkspace.shared().frontmostApplication
        print("changed to " + frontMostApp!.localizedName!)
    }
}
