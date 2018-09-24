//
//  SyzygyKit.h
//  SyzygyKit
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <SyzygyCore/SyzygyCore.h>

#if BUILDING_FOR_MAC
#import <SyzygyKit/Authorization.h>
#endif
