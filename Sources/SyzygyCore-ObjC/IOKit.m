//
//  IOKit.m
//  SyzygyCore
//
//  Created by Dave DeLong on 4/15/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "include/IOKit.h"
#import <IOKit/IOKitLib.h>

// see https://github.com/practicalswift/osx/blob/master/src/iokituser/platform.subproj/IOPlatformSupport.c#L314

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
        
        uint8_t r = 0, g = 0, b = 0;
        if (CFDataGetLength(data) == sizeof(_Syzygy_IOPlatformDeviceColors) && colors != NULL) {
            succeeded = YES;
            if (colors->major_version == 1) {
                r = colors->device_enclosure.component_v1.red;
                g = colors->device_enclosure.component_v1.green;
                b = colors->device_enclosure.component_v1.blue;
            } else if (colors->major_version == 2) {
                r = colors->device_enclosure.component_v2.red;
                g = colors->device_enclosure.component_v2.green;
                b = colors->device_enclosure.component_v2.blue;
            } else {
                succeeded = NO;
            }
        }
        
        if (succeeded == YES) {
            if (red != NULL) { *red = r; }
            if (green != NULL) { *green = g; }
            if (blue != NULL) { *blue = b; }
        }
    }
    CFRelease(property);
    
    return succeeded;
}
