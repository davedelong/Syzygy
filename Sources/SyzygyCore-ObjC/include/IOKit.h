//
//  IOKit.h
//  SyzygyCore
//
//  Created by Dave DeLong on 4/15/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

#import <Foundation/Foundation.h>

BOOL GetDeviceColor(uint8_t *red, uint8_t *green, uint8_t *blue);

#endif
