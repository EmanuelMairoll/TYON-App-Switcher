//
//  MenuItemController.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 30/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class MenuItemController: NSObject {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: 24)
    let popover:NSPopover = NSPopover()
    var popoverTransiencyMonitor: Any?
    
    override init(){
        super.init()
        
        Applications.load()

        MouseInterface.startListener(#selector(self.mouseConnectionChangedListener), withTarget: self)
        mouseConnectionChangedListener()
        
        NSWorkspace.shared().notificationCenter.addObserver(self, selector: #selector(self.frontmostAppChangedListener), name: NSNotification.Name.NSWorkspaceDidActivateApplication, object: nil)
        frontmostAppChangedListener()
        
        statusItem.button!.action = #selector(self.menuItemClicked)
        statusItem.button!.target = self
        
        popover.contentViewController = PopupViewController(nibName: "Popup", bundle: nil)
    }
    
    func frontmostAppChangedListener(){
        if let modeIndex = Applications.getMode(application: Applications.frontmost()){
            Applications.setSelectedIndex(index: modeIndex)
            setTitle(index: modeIndex + 1)
            MouseInterface.send(Int8(modeIndex))
        }
    }
    
    func menuItemClicked(sender: AnyObject?){
        if !popover.isShown{
            popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: NSRectEdge.minY)
            
            if popoverTransiencyMonitor == nil {
                popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [NSEventMask.leftMouseDown , NSEventMask.rightMouseDown , NSEventMask.keyUp], handler: {(_ event: NSEvent) -> Void in
                    NSEvent.removeMonitor(self.popoverTransiencyMonitor!)
                    self.popoverTransiencyMonitor = nil
                    self.popover.close()
                })
            }
        }else{
            popover.performClose(sender)
        }
    }
    
    func mouseConnectionChangedListener(){
        if (MouseInterface.isConnected()){
            statusItem.length = 24
        }else{
            statusItem.length = 0
            popover.performClose(nil)
        }
    }
    
    func setTitle(index:Int){
        let attrStr = NSMutableAttributedString(string: String(index))
        let font = NSFont(name: "Perfect Dark (BRK)", size: CGFloat(16))!
        let range = NSRange(location: 0, length: 1)
        attrStr.addAttribute(NSFontAttributeName, value: font, range: range)
        statusItem.button!.attributedTitle = attrStr
    }
    
}
