//
//  SyzygyKit.h
//  SyzygyKit
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

#if BUILDING_FOR_IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <SyzygyCore/SyzygyCore.h>
#import <SyzygyKit/ViewSwizzling.h>
