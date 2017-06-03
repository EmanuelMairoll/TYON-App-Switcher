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

+ (void)startListener: (SEL)updateSelector withTarget:(NSObject*)updateTarget;
+ (void)send: (char)mode;
+ (BOOL)isConnected;

@end
