//
//  protocol.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern void protocol_enumerateConformedProtocols(Protocol *p, BOOL includeTransitive, NS_NOESCAPE void(^iterator)(Protocol *protocol, BOOL *stop));

extern void protocol_enumerateConformingProtocols(Protocol *p, BOOL includeTransitive, NS_NOESCAPE void(^iterator)(Protocol *protocol, BOOL *stop));

extern void protocol_enumerateMethods(Protocol *p, NS_NOESCAPE void(^iterator)(struct objc_method_description method, BOOL isInstanceMethod, BOOL isRequired, BOOL *stop));

extern void protocol_enumerateProperties(Protocol *p, NS_NOESCAPE void(^iterator)(objc_property_t property, BOOL isInstanceProperty, BOOL isRequired, BOOL *stop));

NS_ASSUME_NONNULL_END
