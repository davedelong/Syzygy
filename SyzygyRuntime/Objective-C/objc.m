//
//  objc.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "objc.h"


void objc_enumerateImages(NS_NOESCAPE void(^iterator)(NSString *imagePath, BOOL *stop)) {
    unsigned int count;
    const char **names = objc_copyImageNames(&count);
    BOOL stop = NO;
    for (int i = 0; i < count && !stop; ++i) {
        iterator(@(names[i]), &stop);
    }
    free(names);
}

void objc_enumerateClasses(NS_NOESCAPE void(^iterator)(Class c, BOOL *stop)) {
    unsigned int count;
    Class *c = objc_copyClassList(&count);
    BOOL stop = NO;
    for (int i = 0; i < count && !stop; ++i) {
        iterator(c[i], &stop);
    }
    free(c);
}

void objc_enumerateClassesInImage(NSString *imagePath, void(^iterator)(Class c, BOOL *stop)) {
    unsigned int count;
    const char * _Nonnull *names = objc_copyClassNamesForImage(imagePath.UTF8String, &count);
    BOOL stop = NO;
    for (int i = 0; i < count && !stop; ++i) {
        Class class = objc_getClass(names[i]);
        if (class) { iterator(class, &stop); }
    }
    free(names);
}

void objc_enumerateProtocols(NS_NOESCAPE void(^iterator)(Protocol *, BOOL *stop)) {
    unsigned int count;
    Protocol *__unsafe_unretained*p = objc_copyProtocolList(&count);
    BOOL stop = NO;
    for (int i = 0; i < count && !stop; ++i) {
        iterator(p[i], &stop);
    }
    free(p);
    
}
