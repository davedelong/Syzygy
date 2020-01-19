//
//  Authorization.h
//  SyzygyKit
//
//  Created by Dave DeLong on 9/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Authorization : NSObject

- (instancetype)init;

- (BOOL)execute:(NSString *)executable arguments:(NSArray<NSString *> *)arguments;

@end

NS_ASSUME_NONNULL_END

#endif
