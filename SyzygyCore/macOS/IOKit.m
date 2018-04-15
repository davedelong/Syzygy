//
//  IOKit.m
//  SyzygyCore
//
//  Created by Dave DeLong on 4/15/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "IOKit.h"
#import <IOKit/IOKitLib.h>

typedef union __attribute__((packed)) {
    uint32_t rgb;
    struct {
        uint8_t red;
        uint8_t green;
        uint8_t blue;
        uint8_t reserved;
    } component_v1;
    struct {
        uint8_t blue;
        uint8_t green;
        uint8_t red;
        uint8_t reserved;
    } component_v2;
} _Syzygy_IOPlatformDeviceColorRGB;

// from syscfg_DClr
typedef struct __attribute__((packed)) {
    uint8_t minor_version;
    uint8_t major_version;
    uint8_t reserved_2;
    uint8_t reserved_3;
    _Syzygy_IOPlatformDeviceColorRGB device_enclosure;
    _Syzygy_IOPlatformDeviceColorRGB cover_glass;
    uint8_t reserved_C;
    uint8_t reserved_D;
    uint8_t reserved_E;
    uint8_t reserved_F;
} _Syzygy_IOPlatformDeviceColors;

BOOL GetDeviceColor(uint8_t *red, uint8_t *green, uint8_t *blue) {
    io_registry_entry_t platform = IORegistryEntryFromPath(kIOMasterPortDefault, kIODeviceTreePlane ":/efi/platform");
    
    if (platform == IO_OBJECT_NULL) { return NO; }
    
    CFTypeRef property = IORegistryEntryCreateCFProperty(platform, CFSTR("device-colors"), kCFAllocatorDefault, 0);
    IOObjectRelease(platform); platform = IO_OBJECT_NULL;
    
    if (property == NULL) { return NO; }
    
    BOOL succeeded = NO;
    if (CFGetTypeID(property) == CFDataGetTypeID()) {
        CFDataRef data = property;
        const _Syzygy_IOPlatformDeviceColors *colors = (_Syzygy_IOPlatformDeviceColors *)CFDataGetBytePtr(data);
        
        if (CFDataGetLength(data) == sizeof(_Syzygy_IOPlatformDeviceColors) && colors != NULL && colors->major_version == 2) {
            if (red != NULL) { *red = colors->device_enclosure.component_v2.red; }
            if (green != NULL) { *green = colors->device_enclosure.component_v2.green; }
            if (blue != NULL) { *blue = colors->device_enclosure.component_v2.blue; }
            succeeded = YES;
        }
    }
    CFRelease(property);
    
    return succeeded;
}
