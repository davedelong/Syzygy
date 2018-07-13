//
//  type.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "type.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

NSString * __type_getNextTypeFromString(const char *string, unsigned long characterIndex, unsigned long *nextCharacterIndex) {
    // This uses a side effect of how NSGetSizeAndAlignment works
    const char *typeStart = string + characterIndex;
    const char *nextTypeStart = NSGetSizeAndAlignment(typeStart, NULL, NULL);
    if (nextTypeStart != NULL) {
        ptrdiff_t lengthOfType = nextTypeStart - typeStart;
        *nextCharacterIndex = characterIndex + lengthOfType;
        return [[NSString alloc] initWithBytes:typeStart length:lengthOfType encoding:NSASCIIStringEncoding];
    } else {
        *nextCharacterIndex = strlen(string);
        return [[NSString alloc] initWithCString:typeStart encoding:NSASCIIStringEncoding];
    }
}


extern NSArray<NSString *> * type_getTypes(NSString *typeString) {
    NSMutableArray *types = [NSMutableArray array];
    
    const char *rawType = typeString.UTF8String;
    unsigned long typelen = strlen(rawType);
    unsigned long index = 0;
    while (index < typelen) {
        NSString *type = __type_getNextTypeFromString(rawType, index, &index);
        if (type) { [types addObject:type]; }
    }
    return types;
}

BOOL type_isEqualToType(NSString *lhsString, NSString *rhsString) {
    const char *lhs = lhsString.UTF8String;
    const char *rhs = rhsString.UTF8String;
    
    // equal types must start with the same letter
    if (lhs[0] != rhs[0]) { return NO; }
    
    switch (lhs[0]) {
        case _C_VOID:
        case _C_SEL:
        case _C_CHR:
        case _C_UCHR:
        case _C_SHT:
        case _C_USHT:
        case _C_INT:
        case _C_UINT:
        case _C_LNG:
        case _C_ULNG:
        case _C_LNG_LNG:
        case _C_ULNG_LNG:
        case _C_FLT:
        case _C_DBL:
        case _C_CHARPTR:
        case _C_CLASS:
        case _C_BOOL:
        case _C_PTR:
            return YES;
        default:
            break;
    }
    
    if (*lhs == _C_STRUCT_B || *lhs == _C_UNION_B) {
        // this makes sure the union/structure have the same name, like "CGSize"
        while (*lhs == *rhs && *lhs != '=') {
            lhs++; rhs++;
        }
        return (*lhs == '=' && *rhs == '=');
    }
    
    if (*lhs == _C_ID) {
        unsigned long lhsLen = strlen(lhs);
        unsigned long rhsLen = strlen(rhs);
        // @ == @"NSString"
        // @ == @
        // @"NSString" == @
        if (lhsLen == 1 || rhsLen == 1) { return YES; }
    }
    
    // return true if they're the same string
    return (strcmp(lhs, rhs) == 0);
}

NS_ASSUME_NONNULL_END
