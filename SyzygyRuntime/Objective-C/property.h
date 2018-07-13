//
//  property.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern void property_enumerateAttributes(objc_property_t p, void(^iterator)(const char *name, const char *value, BOOL *stop));

extern SEL property_getGetterName(objc_property_t p);

extern _Nullable SEL property_getSetterName(objc_property_t p);

extern objc_AssociationPolicy property_getAssociationPolicy(objc_property_t p);

extern BOOL property_isDynamic(objc_property_t p);

extern BOOL property_isWeak(objc_property_t p);

extern BOOL property_isReadonly(objc_property_t p);

extern _Nullable Class property_getObjectClass(objc_property_t p);

NS_ASSUME_NONNULL_END
