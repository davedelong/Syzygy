//
//  Authorization.m
//  SyzygyKit
//
//  Created by Dave DeLong on 9/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

#import "Authorization.h"
#import <dlfcn.h>

typedef OSStatus (*Execute)(AuthorizationRef authorization, const char *pathToTool,
                            AuthorizationFlags options, const char **arguments,
                            FILE **communicationsPipe);

@implementation Authorization {
    AuthorizationRef _ref;
    AuthorizationItem _item;
    AuthorizationRights _rights;
    AuthorizationFlags _flags;
}

+ (Execute)executeFunc {
    static Execute function = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        function = (Execute)dlsym(RTLD_DEFAULT, "AuthorizationExecuteWithPrivileges");
    });
    
    return function;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // Get the authorization
        OSStatus err = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &_ref);
        if (err != errAuthorizationSuccess) { return nil; }
        
        _item.name = kAuthorizationRightExecute;
        _rights.count = 1;
        _rights.items = &_item;
        
        _flags = (kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights | kAuthorizationFlagPreAuthorize);
        
        err = AuthorizationCopyRights(_ref, &_rights, NULL, _flags, NULL);
        if (err != errAuthorizationSuccess) { return nil; }
        if ([Authorization executeFunc] == NULL) { return nil; }
        
    }
    return self;
}

- (void)dealloc {
    AuthorizationFree(_ref, kAuthorizationFlagDefaults);
}

- (BOOL)execute:(NSString *)executable arguments:(NSArray<NSString *> *)arguments {
    Execute func = [Authorization executeFunc];
    
    NSUInteger argCount = arguments.count;
    const char **args = calloc(argCount + 1, sizeof(char *));
    for (NSUInteger i = 0; i < argCount; i++) {
        args[i] = arguments[i].UTF8String;
    }
    
    OSStatus error = func(_ref, executable.UTF8String, kAuthorizationFlagDefaults, args, NULL);
    if (error != errAuthorizationSuccess) { return NO; }
    
    int status = 0;
    int pid = wait(&status);
    if (pid == -1 || !WIFEXITED(status) || WEXITSTATUS(status)) { return NO; }
    return YES;
}

@end

#endif
