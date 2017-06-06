//
//  MouseInterface.h
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 31/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/hid/IOHIDManager.h>

@interface MouseInterface : NSObject

+ (void)startListenerWithConnectionSel: (SEL)con withReceiveSel:(SEL)rec withTarget:(NSObject*)updateTarget;
+ (void)sendMode: (char)mode;
+ (BOOL)isConnected;

@end
