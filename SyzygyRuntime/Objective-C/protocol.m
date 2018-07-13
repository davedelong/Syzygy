//
//  protocol.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "protocol.h"

NSOrderedSet *_protocol_allConformedProtocols(Protocol *p, BOOL transitive) {
    NSMutableOrderedSet *chain = [NSMutableOrderedSet orderedSet];
    NSMutableOrderedSet *toProcess = [NSMutableOrderedSet orderedSetWithObject:p];
    
    while (toProcess.count > 0) {
        Protocol *next = toProcess.firstObject;
        [toProcess removeObjectAtIndex:0];
        if ([chain containsObject:next] == YES) { continue; }
        
        [chain addObject:next];
        
        unsigned int count = 0;
        Protocol *__unsafe_unretained *conformed = protocol_copyProtocolList(next, &count);
        for (unsigned int i = 0; i < count; i++) {
            [chain addObject:conformed[i]];
            if (transitive) {
                [toProcess addObject:conformed[i]];
            }
        }
        free(conformed);
    }
    
    return chain;
}

void protocol_enumerateConformedProtocols(Protocol *p, BOOL includeTransitive, NS_NOESCAPE void(^iterator)(Protocol *protocol, BOOL *stop)) {
    NSOrderedSet *conformed = _protocol_allConformedProtocols(p, includeTransitive);
    [conformed enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        iterator(obj, stop);
    }];
}

void protocol_enumerateConformingProtocols(Protocol *p, BOOL includeTransitive, NS_NOESCAPE void(^iterator)(Protocol *protocol, BOOL *stop)) {
    // TODO
}

void protocol_enumerateMethods(Protocol *p, NS_NOESCAPE void(^iterator)(struct objc_method_description method, BOOL isInstanceMethod, BOOL isRequired, BOOL *stop)) {
    BOOL stop = NO;
    for (char options = 0; options < 4 && !stop; options++) {
        BOOL isRequired = (options & 1);
        BOOL isInstance = (options & (1 << 1));
        
        unsigned int count;
        struct objc_method_description *methods = protocol_copyMethodDescriptionList(p, isRequired, isInstance, &count);
        for (int i = 0; i < count && !stop; ++i) {
            iterator(methods[i], isInstance, isRequired, &stop);
        }
        free(methods);
    }
}

void protocol_enumerateProperties(Protocol *p, NS_NOESCAPE void(^iterator)(objc_property_t property, BOOL isInstanceProperty, BOOL isRequired, BOOL *stop)) {
    
    BOOL stop = NO;
    for (char options = 0; options < 4 && !stop; options++) {
        BOOL isRequired = (options & 1);
        BOOL isInstance = (options & (1 << 1));
        
        unsigned int count;
        objc_property_t *props = protocol_copyPropertyList2(p, &count, isRequired, isInstance);
        for (int i = 0; i < count && !stop; ++i) {
            iterator(props[i], isInstance, isRequired, &stop);
        }
        free(props);
    }
}


