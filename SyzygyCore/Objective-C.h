//
//  Objective-C.h
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern const NSErrorDomain SyzygyExceptionErrorDomain;

@interface ObjectiveC : NSObject

+ (BOOL)catchException:(NS_NOESCAPE void(^)(void))tryBlock error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
