//
//  ViewSwizzling.h
//  SyzygyKit
//
//  Created by Dave DeLong on 4/16/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewSwizzling : NSObject

+ (void)swizzleInHierarchyHooks;

@end

NS_ASSUME_NONNULL_END
