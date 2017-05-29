//
//  Application.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 28/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class Applications{
    private init(){
    }
    
    private static var mode1:[Application] = []
    private static var mode2:[Application] = []
    private static var mode3:[Application] = []
    private static var mode4:[Application] = []
    private static var mode5:[Application] = []
    private static var selected = 0
    static var modes = [mode1, mode2, mode3, mode4, mode5]
    
    static func selectedList() -> [Application]{
        return modes[selected]
    }
    
    static func setSelectedList(index:Int){
        selected = index
    }
    
    static func fromNSRunningAppliaction(runningApplication:NSRunningApplication) -> Application{
        let name = runningApplication.localizedName ?? "No Name"
        let id = runningApplication.bundleIdentifier ?? "No Bundle Id"
        let icon = runningApplication.icon ?? NSImage(named: NSImageNameApplicationIcon)
        
        return Application(displayName: name, bundleId: id, icon: icon)
    }
    
    static func frontmost() -> Application{
        let app = NSWorkspace.shared().menuBarOwningApplication!
        return fromNSRunningAppliaction(runningApplication: app)
    }
    
    static func appendToSelectedAndReturnIndex(application: Application) -> Int{
        if !(modes[selected].contains(where: {$0 == application})){
            modes[selected].append(application)
        }
        
        return 0
    }
}

struct Application {
    
    let displayName: String
    let bundleId: String
    let icon: NSImage?
    
    init(displayName:String, bundleId:String, icon:NSImage?){
        self.displayName = displayName
        self.bundleId = bundleId
        self.icon = icon
    }
    
    static func ==(lhs: Application, rhs: Application) -> Bool {
        print(lhs.displayName + " " + rhs.displayName)
        return lhs.displayName == rhs.displayName && lhs.bundleId == rhs.bundleId
    }
}
