//
//  sel.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "sel.h"

NSArray<NSString *> * sel_getComponents(SEL selector) {
    NSString *s = NSStringFromSelector(selector);
    NSScanner *scanner = [NSScanner scannerWithString:s];
    
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:4];
    
    while ([scanner isAtEnd] == NO) {
        NSString *component = nil;
        [scanner scanUpToString:@":" intoString:&component];
        
        if (component == nil) { component = @""; }
        
        if ([scanner scanString:@":" intoString:nil]) {
            component = [component stringByAppendingString:@":"];
        }
        
        [components addObject:component];
    }
    
    return components;
    
}

NSUInteger sel_getNumberOfArguments(SEL selector) {
    NSString *s = NSStringFromSelector(selector);
    NSUInteger argCount = 0;
    for (NSUInteger i = 0; i < s.length; i++) {
        if ([s characterAtIndex:i] == ':') {
            argCount += 1;
        }
    }
    return argCount;
}

void sel_enumerateComponents(SEL selector, void (^iterator)(NSString *component, BOOL *stop)) {
    NSArray<NSString *> *components = sel_getComponents(selector);
    [components enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        iterator(obj, stop);
    }];
}
