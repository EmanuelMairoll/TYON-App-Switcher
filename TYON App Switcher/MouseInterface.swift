//
//  MouseInterface.swift
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 24/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class MouseInterface: NSObject {

    static func send(bytes:[UInt8]){
        
    }
    
    static let setProfile1 = [0x05, 0x03, 0x01]
    static let setProfile2 = [0x05, 0x03, 0x02]
    static let setProfile3 = [0x05, 0x03, 0x03]
    static let setProfile4 = [0x05, 0x03, 0x04]
    static let setProfile5 = [0x05, 0x03, 0x05]
    
    static func onReceive(){
        
    }
    
    static let isProfile1 = [0x03, 0x00, 0x20, 0x01, 0x00]
    static let isProfile2 = [0x03, 0x00, 0x20, 0x01, 0x00]
    static let isProfile3 = [0x03, 0x00, 0x20, 0x01, 0x00]
    static let isProfile4 = [0x03, 0x00, 0x20, 0x01, 0x00]
    static let isProfile5 = [0x03, 0x00, 0x20, 0x01, 0x00]
    
}
