//
//  instance.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL instance_respondsToSelector(id obj, SEL selector);

extern void instance_enumerateIvars(id obj, void(^iterator)(Ivar ivar, BOOL *stop));

extern _Nullable id instance_getIvarValue(id obj, Ivar ivar);

extern void instance_setIvarValue(id obj, Ivar ivar, id value);

extern NSString *instance_getDescription(id obj);

NS_ASSUME_NONNULL_END
