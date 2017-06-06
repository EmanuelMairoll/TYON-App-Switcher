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
int primaryUsuageIdMouse = 0x227;
int primaryUsuageIdGeneric = 0x27;

SEL updateMethod;
SEL receiveMethod;
NSObject *target;

IOHIDDeviceRef mouseItf;
IOHIDDeviceRef genericItf;

bool mouseItfConnected = false;

+ (void)startListenerWithConnectionSel: (SEL)con withReceiveSel:(SEL)rec withTarget:(NSObject*)updateTarget
{
    updateMethod = con;
    receiveMethod = rec;
    target = updateTarget;
    
    IOHIDManagerRef HIDManagerMouse = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    CFMutableDictionaryRef matchDictMouse = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(matchDictMouse, CFSTR(kIOHIDVendorIDKey), vendorId);
    CFDictionarySetValue(matchDictMouse, CFSTR(kIOHIDProductIDKey), productId);
    CFDictionarySetValue(matchDictMouse, CFSTR(kIOHIDPrimaryUsageKey), primaryUsuageIdMouse);
    IOHIDManagerSetDeviceMatching(HIDManagerMouse, matchDictMouse);
    
    IOHIDManagerRegisterDeviceMatchingCallback(HIDManagerMouse, &onMouseItfConnected, NULL);
    IOHIDManagerRegisterDeviceRemovalCallback(HIDManagerMouse, &onMouseItfRemoved, NULL);
    IOHIDManagerScheduleWithRunLoop(HIDManagerMouse, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    IOHIDManagerOpen(HIDManagerMouse, kIOHIDOptionsTypeNone);

    IOHIDManagerRef HIDManagerGeneric = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    CFMutableDictionaryRef matchDictGeneric = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(matchDictGeneric, CFSTR(kIOHIDVendorIDKey), vendorId);
    CFDictionarySetValue(matchDictGeneric, CFSTR(kIOHIDProductIDKey), productId);
    CFDictionarySetValue(matchDictMouse, CFSTR(kIOHIDPrimaryUsageKey), primaryUsuageIdGeneric);
    IOHIDManagerSetDeviceMatching(HIDManagerGeneric, matchDictMouse);
    
    IOHIDManagerRegisterInputValueCallback(HIDManagerGeneric, &onGenericItfReceived, NULL);
    IOHIDManagerScheduleWithRunLoop(HIDManagerGeneric, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    IOHIDManagerOpen(HIDManagerGeneric, kIOHIDOptionsTypeNone);
}

+ (BOOL)isConnected
{
    return mouseItfConnected;
}

+ (void)sendMode: (char)mode
{
    if (mouseItfConnected){
        char message[] = {0x05, 0x03, mode};
        IOHIDDeviceSetReport((void *)mouseItf, kIOHIDReportTypeFeature, message[0], (uint8_t*)message, sizeof(message));
    }
}

static void onMouseItfConnected(void *inContext, IOReturn inResult, void *inSender, IOHIDDeviceRef deviceRef){
    mouseItfConnected = true;
    mouseItf = deviceRef;
    [target performSelector:updateMethod];
}

static void onMouseItfRemoved(void *inContext, IOReturn inResult, void *inSender, IOHIDDeviceRef deviceRef){
    mouseItfConnected = false;
    mouseItf = nil;
    [target performSelector:updateMethod];
}

static void onGenericItfReceived(void *inContext, IOReturn inResult, void *inSender, IOHIDValueRef valueRef){
    [target performSelector:receiveMethod];
}

@end
