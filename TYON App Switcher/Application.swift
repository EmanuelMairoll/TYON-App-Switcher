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
    private static var drawn = 0
    static var modes = [mode1, mode2, mode3, mode4, mode5]
    
    static func drawnList() -> [Application]{
        return modes[drawn]
    }
    
    static func drawnIndex() -> Int{
        return Applications.drawn
    }
    
    static func setDrawnIndex(index:Int){
        drawn = index
    }
    
    static func selectedIndex() -> Int{
        return Applications.selected
    }
    
    static func setSelectedIndex(index:Int){
        selected = index
    }
    static func fromNSRunningAppliaction(runningApplication:NSRunningApplication) -> Application{
        let name = runningApplication.localizedName
        let id = runningApplication.bundleIdentifier
        let icon = runningApplication.icon
        
        return Application(displayName: name, bundleId: id, icon: icon)
    }
    
    static func frontmost() -> Application{
        let app = NSWorkspace.shared().menuBarOwningApplication!
        return fromNSRunningAppliaction(runningApplication: app)
    }
    
    static func appendToDrawnAndReturnIndex(application appIn: Application) -> Int?{
        if let _ = modes[drawn].index(of: appIn){
            return nil
        }
        
        for (index, _) in modes.enumerated() {
            if index == drawn{
                continue
            }
            
            while let subindex = modes[index].index(of: appIn){
                modes[index].remove(at: subindex)
            }
        }
        
        modes[drawn].append(appIn)
        modes[drawn].sort(by: {$0.0.displayName < $0.1.displayName})
        return modes[drawn].index(of: appIn)
    }
    
    static func getMode(application appIn: Application) -> Int?{
        for (listIndex, mode) in modes.enumerated() {
            if let _ = mode.index(of: appIn){
                return listIndex
            }
        }
        return nil
    }
    
    static func save(){
        let defaults = UserDefaults.standard
        
        var modesToSave = [[[String: Any]]]()
        for mode in modes{
            var modeToSave = [[String: Any]]()
            for app in mode{
                let appToSave = ["displayName": app.displayName, "bundleID": app.bundleId, "iconData": app.icon.toNSData()] as [String : Any]
                modeToSave.append(appToSave)
            }
            modesToSave.append(modeToSave)
        }
        defaults.set(modesToSave, forKey: "contents")
        
        defaults.synchronize()
    }
    
    static func load(){
        let defaults = UserDefaults.standard
        if let loadedModes = defaults.array(forKey: "contents") as? [[[String: Any]]]{
            for (modeIndex, loadedMode) in loadedModes.enumerated(){
                for loadedApp in loadedMode{
                    let name = loadedApp["displayName"] as! String
                    let id = loadedApp["bundleID"] as! String
                    let imageData = loadedApp["iconData"] as! Data
                    let icon = NSImage(data: imageData)
                    
                    let app = Application(displayName: name, bundleId: id, icon: icon)
                    modes[modeIndex].append(app)
                }
            }
        }
        defaults.synchronize()
    }
}

struct Application: Equatable {
    
    let displayName: String
    let bundleId: String
    let icon: NSImage
    
    init(displayName displayNameIn:String?, bundleId bundleIdIn:String?, icon iconIn:NSImage?){
        self.displayName = displayNameIn ?? "No Name"
        self.bundleId = bundleIdIn ?? "No Bundle ID"
        
        let unresized = iconIn ?? NSImage(named: NSImageNameApplicationIcon)!
        let rect = NSRect(x: 0, y: 0, width: 32, height: 32)
        let rep = unresized.bestRepresentation(for: rect, context: nil, hints: nil)!
        self.icon = NSImage()
        self.icon.addRepresentation(rep)
    }
    
    static func ==(lhs: Application, rhs: Application) -> Bool {
        return lhs.displayName == rhs.displayName && lhs.bundleId == rhs.bundleId
    }
}

extension NSImage{
    func toNSData()->Data{
        let data = self.tiffRepresentation!
        let bitmap = NSBitmapImageRep(data: data)
        return bitmap!.representation(using: .PNG, properties: [:])! as Data
    }
}
