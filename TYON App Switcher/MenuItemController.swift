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
        
        statusItem.button!.action = #selector(self.menuItemClicked)
        statusItem.button!.target = self
        
        popover.contentViewController = PopupViewController(nibName: "Popup", bundle: nil)
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
    
    func onConnectMouse(){
        statusItem.length = 24
    }
    
    func onDisconnectMouse(){
        statusItem.length = 0
        popover.performClose(nil)
    }
    
    func setTitle(index:Int){
        let attrStr = NSMutableAttributedString(string: String(index))
        let font = NSFont(name: "Perfect Dark (BRK)", size: CGFloat(16))!
        let range = NSRange(location: 0, length: 1)
        attrStr.addAttribute(NSFontAttributeName, value: font, range: range)
        statusItem.button!.attributedTitle = attrStr
    }
    
}
