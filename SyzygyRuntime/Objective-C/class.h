//
//  class.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL class_isSubclassOfClass(Class c, Class superclass);

extern BOOL class_instancesRespondToSelector(Class c, SEL s);

extern Class class_getMetaClass(Class c);

extern Method class_getMethod(Class c, SEL s);

extern NSArray<Class> *class_getSuperclasses(Class c);

extern objc_property_t class_getPropertyForSelector(Class c, SEL s);

extern void class_enumerateSuperclasses(Class c, void(^iterator)(Class c, BOOL *stop));

extern void class_enumerateIvars(Class c, BOOL includeSuperclasses, void(^iterator)(Class c, Ivar i, BOOL *stop));

extern void class_enumerateMethods(Class c, BOOL includeSuperclasses, void(^iterator)(Class c, Method m, BOOL *stop));

extern void class_enumerateProperties(Class c, BOOL includeSuperclasses, void(^iterator)(Class c, objc_property_t p, BOOL *stop));

NS_ASSUME_NONNULL_END
