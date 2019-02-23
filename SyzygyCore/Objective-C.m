//
//  Objective-C.m
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

#import "Objective-C.h"

@implementation ObjectiveC

+ (BOOL)catchException:(NS_NOESCAPE void(^)(void))tryBlock error:(NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
    }
}

@end
