//
//  instance.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "instance.h"
#import "type.h"
#import "class.h"
#import <objc/runtime.h>

BOOL instance_respondsToSelector(id obj, SEL selector) {
    Class c = object_getClass(obj);
    return class_instancesRespondToSelector(c, selector);
}

void instance_enumerateIvars(id obj, void(^iterator)(Ivar ivar, BOOL *stop)) {
    Class c = object_getClass(obj);
    class_enumerateIvars(c, YES, ^(Class  _Nonnull __unsafe_unretained owningClass, Ivar  _Nonnull ivar, BOOL * _Nonnull stop) {
        iterator(ivar, stop);
    });
}

id instance_getIvarValue(id obj, Ivar ivar) {
    const char *type = ivar_getName(ivar);
    ptrdiff_t offset = ivar_getOffset(ivar);
    
    id value = nil;
    if (offset == 0) {
        value = object_getClass(obj);
    } else if (type[0] == _C_ID || type[0] == _C_CLASS) {
        value = object_getIvar(obj, ivar);
    } else {
        uintptr_t *location = ((__bridge void *)obj) + offset;
        value = [NSValue valueWithBytes:location objCType:type];
    }
    return value;
}


void instance_setIvarValue(id obj, Ivar ivar, id value) {
    const char *type = ivar_getTypeEncoding(ivar);
    ptrdiff_t offset = ivar_getOffset(ivar);
    
    if (offset == 0) {
        object_setClass(obj, value);
    } else if (type[0] == _C_ID || type[0] == _C_CLASS) {
        object_setIvar(obj, ivar, value);
    } else if ([value isKindOfClass:[NSValue class]] && type_isEqualToType(@(type), @([value objCType]))) {
        void *ivarLocation = ((__bridge void *)obj)+offset;
        [value getValue:ivarLocation];
    } else {
        NSCAssert(NO, @"Non-NSValue object when setting a non-object ivar");
    }
}

NSString *instance_getDescription(id obj) {
    static id(*NSObjectDescription)(id,SEL) = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObjectDescription = (id(*)(id,SEL))[NSObject instanceMethodForSelector:@selector(description)];
    });
    return NSObjectDescription(obj, @selector(description));
}
