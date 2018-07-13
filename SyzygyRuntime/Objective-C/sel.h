//
//  sel.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSArray<NSString *> * sel_getComponents(SEL selector);

extern NSUInteger sel_getNumberOfArguments(SEL selector);

extern void sel_enumerateComponents(SEL selector, NS_NOESCAPE void (^iterator)(NSString *component, BOOL *stop));

NS_ASSUME_NONNULL_END
