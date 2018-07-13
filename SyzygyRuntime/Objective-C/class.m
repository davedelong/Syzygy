//
//  class.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "class.h"
#import "property.h"

BOOL class_isSubclassOfClass(Class c, Class superclass) {
    __block BOOL found = NO;
    class_enumerateSuperclasses(c, ^(__unsafe_unretained Class c, BOOL *stop) {
        if (c == superclass) {
            found = YES;
            *stop = YES;
        }
    });
    return found;
}

BOOL class_instancesRespondToSelector(Class c, SEL s) {
    Method m = class_getMethod(c, s);
    return m != NULL;
}

Class class_getMetaClass(Class c) {
    return object_getClass(c);
}

Method class_getMethod(Class c, SEL s) {
    __block Method m = NULL;
    class_enumerateMethods(c, YES, ^(Class owning, Method method, BOOL *stop) {
        if (sel_isEqual(method_getName(method), s)) {
            m = method;
            *stop = YES;
        }
    });
    return m;
}

NSArray<Class> *class_getSuperclasses(Class c) {
    NSMutableArray *classes = [NSMutableArray array];
    Class current = c;
    while (current != nil) {
        [classes addObject:current];
        current = class_getSuperclass(current);
    }
    return classes;
}

objc_property_t class_getPropertyForSelector(Class c, SEL s) {
    __block objc_property_t p = NULL;
    class_enumerateProperties(c, YES, ^(__unsafe_unretained Class owning, objc_property_t property, BOOL *stop) {
        SEL getter = property_getGetterName(property);
        if (sel_isEqual(getter, s)) {
            p = property;
            *stop = YES;
        } else {
            SEL setter = property_getSetterName(property);
            if (setter && sel_isEqual(setter, s)) {
                p = property;
                *stop = YES;
            }
        }
    });
    return p;
}

void class_enumerateSuperclasses(Class c, void(^iterator)(Class c, BOOL *stop)) {
    NSArray *superclasses = class_getSuperclasses(c);
    [superclasses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        iterator(obj, stop);
    }];
}

void class_enumerateIvars(Class c, BOOL includeSuperclasses, void(^iterator)(Class c, Ivar i, BOOL *stop)) {
    NSArray *classes = includeSuperclasses ? class_getSuperclasses(c) : @[c];
    NSArray *descendingOrder = [[classes reverseObjectEnumerator] allObjects];
    
    BOOL stop = NO;
    for (Class c in descendingOrder) {
        unsigned int count;
        Ivar *ivars = class_copyIvarList(c, &count);
        for (int i = 0; i < count && !stop; ++i) {
            iterator(c, ivars[i], &stop);
        }
        free(ivars);
        if (stop) { break; }
    }
}

void class_enumerateMethods(Class c, BOOL includeSuperclasses, void(^iterator)(Class c, Method m, BOOL *stop)) {
    NSArray *classes = includeSuperclasses ? class_getSuperclasses(c) : @[c];
    NSArray *descendingOrder = [[classes reverseObjectEnumerator] allObjects];
    
    BOOL stop = NO;
    for (Class c in descendingOrder) {
        unsigned int count;
        Method *methods = class_copyMethodList(c, &count);
        for (int i = 0; i < count && !stop; ++i) {
            iterator(c, methods[i], &stop);
        }
        free(methods);
        if (stop) { break; }
    }
}

void class_enumerateProperties(Class c, BOOL includeSuperclasses, void(^iterator)(Class c, objc_property_t p, BOOL *stop)) {
    NSArray *classes = includeSuperclasses ? class_getSuperclasses(c) : @[c];
    NSArray *descendingOrder = [[classes reverseObjectEnumerator] allObjects];
    
    BOOL stop = NO;
    for (Class c in descendingOrder) {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(c, &count);
        for (int i = 0; i < count && !stop; ++i) {
            iterator(c, properties[i], &stop);
        }
        free(properties);
        if (stop) { break; }
    }
}

