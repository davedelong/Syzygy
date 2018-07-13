//
//  type.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSArray<NSString *> * type_getTypes(NSString *typeString);

extern BOOL type_isEqualToType(NSString *lhs, NSString *rhs);

NS_ASSUME_NONNULL_END
