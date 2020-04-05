//
//  _LSSharedFileList.h
//  SyzygyKit
//
//  Created by Dave DeLong on 9/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_MAC

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _LSSharedFileList : NSObject

+ (instancetype)sessionLoginItems;

@property (nonatomic, readonly) NSSet<NSURL *> *items;

@property (nonatomic, copy, nullable) void(^changeHandler)(_LSSharedFileList *);

- (BOOL)containsItem:(NSURL *)url;
- (void)addItem:(NSURL *)url;
- (void)removeItem:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END

#endif
