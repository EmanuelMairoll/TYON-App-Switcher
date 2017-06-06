//
//  MainController.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 06/06/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

var menuItemController = MenuItemController();

class MainController: NSObject {

    override init() {
        super.init()
        
        MouseInterface.startListener(withConnectionSel: #selector(self.mouseConnectionChangedListener), withReceiveSel: #selector(self.messageReceivedListener), withTarget: self)
        mouseConnectionChangedListener()
        
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(self.frontmostAppChangedListener), name: NSNotification.Name.NSWorkspaceDidActivateApplication, object: nil)
        frontmostAppChangedListener()
        
    }
    
    func frontmostAppChangedListener(){
        if let modeIndex = Applications.getMode(application: Applications.frontmost()){
            Applications.setSelectedIndex(index: modeIndex)
            menuItemController.setTitle(index: modeIndex + 1)
            MouseInterface.sendMode(Int8(modeIndex))
        }
    }
    
    func mouseConnectionChangedListener(){
        if (MouseInterface.isConnected()){
            frontmostAppChangedListener()
            menuItemController.onConnectMouse()
        }else{
            menuItemController.onDisconnectMouse()
        }
    }
    
    func messageReceivedListener(){
        if (MouseInterface.isConnected()){
            if let modeIndex = Applications.getMode(application: Applications.frontmost()){
                MouseInterface.sendMode(Int8(modeIndex))
            }
        }
    }

    
}
