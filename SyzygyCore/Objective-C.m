//
//  Objective-C.m
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

#import "Objective-C.h"

const NSErrorDomain SyzygyExceptionErrorDomain = @"SyzygyExceptionErrorDomain";

@implementation ObjectiveC

+ (BOOL)catchException:(NS_NOESCAPE void(^)(void))tryBlock error:(NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Catching ObjC exception: %@", exception);
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        info[@"name"] = exception.name;
        info[@"reason"] = exception.reason;
        info[@"userInfo"] = exception.userInfo;
        info[@"callStack"] = exception.callStackSymbols;
        
        *error = [[NSError alloc] initWithDomain:SyzygyExceptionErrorDomain code:0 userInfo:info];
    }
}

@end
