//
//  Objective-C.h
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectiveC : NSObject

+ (BOOL)catchException:(NS_NOESCAPE void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
