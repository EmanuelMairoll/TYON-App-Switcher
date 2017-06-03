//
//  MouseInterface.m
//  TYON App Switcher
//
//  Created by Emanuel Mairoll on 31/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

#import "MouseInterface.h"
#import "IOKit/hid/IOHIDManager.h"
#import "IOKit/hid/IOHIDKeys.h"
#import <IOKit/usb/IOUSBLib.h>

@implementation MouseInterface

int vendorId = 0x1e7d27;
int productId = 0x2e4a27;
int primaryUsuageId = 0x227;
bool connected = false;

SEL updateMethod;
NSObject *target;

IOHIDDeviceRef mouse;

+ (void)startListener: (SEL)updateSelector withTarget:(NSObject*)updateTarget
{
    updateMethod = updateSelector;
    target = updateTarget;
    
    IOHIDManagerRef HIDManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    
    CFMutableDictionaryRef matchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(matchDict, CFSTR(kIOHIDVendorIDKey), vendorId);
    CFDictionarySetValue(matchDict, CFSTR(kIOHIDProductIDKey), productId);
    CFDictionarySetValue(matchDict, CFSTR(kIOHIDPrimaryUsageKey), primaryUsuageId);
    IOHIDManagerSetDeviceMatching(HIDManager, matchDict);
    
    IOHIDManagerRegisterDeviceMatchingCallback(HIDManager, &Handle_DeviceMatchingCallback, NULL);
    IOHIDManagerRegisterDeviceRemovalCallback(HIDManager, &Handle_DeviceRemovalCallback, NULL);
    //IOHIDManagerRegisterInputValueCallback(HIDManager, &Handle_DeviceInputCallback, NULL);
    
    IOHIDManagerScheduleWithRunLoop(HIDManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    
    IOReturn IOReturn = IOHIDManagerOpen(HIDManager, kIOHIDOptionsTypeNone);
    if(IOReturn){
        NSLog(@"IOHIDManagerOpen failed.");
    }
}

+ (BOOL)isConnected
{
    return connected;
}

+ (void)send: (char)mode
{
    if (connected){
        char outCommand[] = {0x05, 0x03, mode};
        IOReturn tIOReturn = IOHIDDeviceSetReport((void *)mouse, kIOHIDReportTypeFeature, outCommand[0], (uint8_t*)outCommand, sizeof(outCommand));
        //printf("%x\n", tIOReturn);
    }
}

static void Handle_DeviceMatchingCallback(void *inContext, IOReturn inResult, void *inSender, IOHIDDeviceRef deviceRef){
    //NSLog(@"\nROCCAT device added: %p\nROCCAT device count: %ld", (void *)deviceRef, USBDeviceCount(inSender));
    connected = true;
    
    mouse = deviceRef;
    [target performSelector:updateMethod];
}

static void Handle_DeviceRemovalCallback(void *inContext, IOReturn inResult, void *inSender, IOHIDDeviceRef inIOHIDDeviceRef){
    //NSLog(@"\nROCCAT device removed: %p\nROCCAT device count: %ld", (void *)inIOHIDDeviceRef, USBDeviceCount(inSender));
    connected = false;
    
    [target performSelector:updateMethod];
}

static void Handle_DeviceInputCallback(void *inContext, IOReturn inResult, void *inSender, IOHIDValueRef inIOHIDValueRef){
    //printf("%x\n", IOHIDValueGetIntegerValue(inIOHIDValueRef));
}

static long USBDeviceCount(IOHIDManagerRef HIDManager){
    CFSetRef devSet = IOHIDManagerCopyDevices(HIDManager);
    if(devSet) {
        return CFSetGetCount(devSet);
    }else{
        return 0;
    }
}

@end
