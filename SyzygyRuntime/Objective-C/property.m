//
//  property.m
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/12/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#import "property.h"

void property_enumerateAttributes(objc_property_t p, void(^iterator)(const char *name, const char *value, BOOL *stop)) {
    unsigned int count;
    objc_property_attribute_t *attrs = property_copyAttributeList(p, &count);
    BOOL stop = NO;
    for (unsigned int i = 0; i < count && !stop; ++i) {
        iterator(attrs[i].name, attrs[i].value, &stop);
    }
    free(attrs);
}

SEL property_getGetterName(objc_property_t p) {
    SEL s = NULL;
    char *customGetter = property_copyAttributeValue(p, "G");
    if (customGetter != NULL) {
        s = sel_registerName(customGetter);
        free(customGetter);
    }
    
    if (s == NULL) {
        s = sel_registerName(property_getName(p));
    }
    
    return s;
}

SEL property_getSetterName(objc_property_t p) {
    SEL s = NULL;
    
    // see if the property is readonly.
    if (property_isReadonly(p) == NO) {
        // not readonly; see if there's a custom setter
        char *customSetter = property_copyAttributeValue(p, "S");
        if (customSetter != NULL) {
            s = sel_registerName(customSetter);
            free(customSetter);
        }
        
        if (s == NULL) {
            // no custom setter; derive setter from property name
            NSMutableString *name = [NSMutableString string];
            const char *pname = property_getName(p);
            while (*pname == '_') {
                [name appendString:@"_"];
                pname++;
            }
            [name appendFormat:@"set%c%s:", toupper(*pname), pname+1];
            
            s = sel_registerName([name UTF8String]);
        }
    }
    
    return s;
}

objc_AssociationPolicy property_getAssociationPolicy(objc_property_t p) {
    objc_AssociationPolicy policy = OBJC_ASSOCIATION_ASSIGN;
    
    BOOL isNonatomic = NO;
    char *nonatomic = property_copyAttributeValue(p, "N");
    if (nonatomic != NULL) {
        isNonatomic = YES;
        free(nonatomic);
    }
    
    char *copy = property_copyAttributeValue(p, "C");
    if (copy != NULL) {
        policy = isNonatomic ? OBJC_ASSOCIATION_COPY_NONATOMIC : OBJC_ASSOCIATION_COPY;
        free(copy);
    } else {
        char *strong = property_copyAttributeValue(p, "&");
        if (strong != NULL) {
            policy = isNonatomic ? OBJC_ASSOCIATION_RETAIN_NONATOMIC : OBJC_ASSOCIATION_RETAIN;
            free(strong);
        }
    }
    
    return policy;
}

BOOL property_isDynamic(objc_property_t p) {
    BOOL isDynamic = NO;
    
    char *dynamic = property_copyAttributeValue(p, "D");
    if (dynamic != NULL) {
        isDynamic = YES;
        free(dynamic);
    }
    
    return isDynamic;
}

BOOL property_isWeak(objc_property_t p) {
    BOOL isWeak = NO;
    
    if (property_getAssociationPolicy(p) == OBJC_ASSOCIATION_ASSIGN) {
        char *weak = property_copyAttributeValue(p, "W");
        if (weak) {
            isWeak = YES;
            free(weak);
        }
    }
    return isWeak;
}

BOOL property_isReadonly(objc_property_t p) {
    BOOL isReadonly = NO;
    char *readonly = property_copyAttributeValue(p, "R");
    if (readonly != NULL) {
        isReadonly = YES;
        free(readonly);
    }
    return isReadonly;
}

Class property_getObjectClass(objc_property_t p) {
    char *type = property_copyAttributeValue(p, "T");
    if (type) {
        unsigned long len = strlen(type);
        if (type[0] == _C_ID && len > 3) {
            // it's an object type with name embedded
            NSString *class = [[NSString alloc] initWithBytes:type+2 length:len-3 encoding:NSASCIIStringEncoding];
            Class klass = NSClassFromString(class);
            if (klass != nil) {
                free(type);
                return klass;
            }
        }
        if (type[0] == _C_ID || type[0] == _C_CLASS) {
            free(type);
            return [NSObject class];
        }
        
        free(type);
    }
    return nil;
}
