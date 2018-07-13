//
//  objc.h
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

extern void objc_enumerateImages(NS_NOESCAPE void(^iterator)(NSString *imagePath, BOOL *stop));

extern void objc_enumerateClasses(NS_NOESCAPE void(^iterator)(Class c, BOOL *stop));

extern void objc_enumerateClassesInImage(NSString *imagePath, NS_NOESCAPE void(^iterator)(Class c, BOOL *stop));

extern void objc_enumerateProtocols(NS_NOESCAPE void(^iterator)(Protocol *, BOOL *stop));

NS_ASSUME_NONNULL_END
