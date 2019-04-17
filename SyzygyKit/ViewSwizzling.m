//
//  ViewSwizzling.m
//  SyzygyKit
//
//  Created by Dave DeLong on 4/16/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

#import "ViewSwizzling.h"

#if BUILDING_FOR_MAC
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <objc/runtime.h>
#import <objc/message.h>

typedef void(*v_id_sel_id)(id, SEL, id);
typedef void(*v_id_sel)(id, SEL);
typedef id(*id_id_sel)(id, SEL);

v_id_sel_id callVC = (v_id_sel_id)objc_msgSend;
id_id_sel getProp = (id_id_sel)objc_msgSend;

SEL getVCSEL;
Class baseVC;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

#define callVCMethod(_view, _getter, _callback) ({          \
    do {                                                    \
        id vc = getProp(_view, getVCSEL);                   \
        if (vc == nil) { break; }                           \
        if ([vc isKindOfClass:baseVC] == NO) { break; }     \
        id arg = getProp(_view, _getter);                   \
        callVC(vc, _callback, arg);                         \
    } while (0);                                            \
})

void replaceMethodUsingProperty(Class target, SEL targetMethod, SEL vcMethod, SEL argProperty) {
    Method m = class_getInstanceMethod(target, targetMethod);
    if (m == NULL) {
        // method does not exist; add it
        IMP newIMP = imp_implementationWithBlock(^(id _self) {
            callVCMethod(_self, argProperty, vcMethod);
        });
        class_addMethod(target, targetMethod, newIMP, "v@:");
    } else {
        // method exists; replace it
        v_id_sel existingIMP = (v_id_sel)method_getImplementation(m);
        IMP newIMP = imp_implementationWithBlock(^(id _self) {
            callVCMethod(_self, argProperty, vcMethod);
            existingIMP(_self, targetMethod);
        });
        method_setImplementation(m, newIMP);
    }
}

@implementation ViewSwizzling
- (void)_viewController { }
- (void)_viewDelegate { }

+ (void)swizzleInHierarchyHooks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        baseVC = NSClassFromString(@"SyzygyKit._SyzygyViewControllerBase");
        
#if BUILDING_FOR_MAC
        Class target = [NSView class];
        SEL didMoveToSuperview = @selector(viewDidMoveToSuperview);
        SEL didMoveToWindow = @selector(viewDidMoveToWindow);
        getVCSEL = @selector(_viewController);
#else
        Class target = [UIView class];
        SEL didMoveToSuperview = @selector(didMoveToSuperview);
        SEL didMoveToWindow = @selector(didMoveToWindow);
        getVCSEL = @selector(_viewDelegate);
#endif
        
        SEL viewDidMoveToSuperview = @selector(viewDidMoveToSuperview:);
        SEL viewDidMoveToWindow = @selector(viewDidMoveToWindow:);
        
        replaceMethodUsingProperty(target, didMoveToSuperview, viewDidMoveToSuperview, @selector(superview));
        replaceMethodUsingProperty(target, didMoveToWindow, viewDidMoveToWindow, @selector(window));
    });
}

@end

#pragma clang diagnostic pop
