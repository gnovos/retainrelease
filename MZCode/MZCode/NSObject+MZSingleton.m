//
//  NSObject+MZSingleton.m
//  MZCore
//
//  Created by Mason Glaves on 4/15/12.
//  Copyright (c) 2012 Masonsoft. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+MZSingleton.h"
#import "MZInvoker.h"

#define kMZSingletonNotFound -1
#define kMZSingletonInitialTokenCount 64

@implementation NSObject (MZSingleton)

+ (void)load {
    
    Class class = object_getClass(self);
    
    SEL forward = @selector(forwardingTargetForSelector:);
    SEL rforward = @selector(mzsingleton_forwardingTargetForSelector:);
    
    Method original = class_getClassMethod(class, forward);
    Method override = class_getClassMethod(class, rforward);
    
    method_exchangeImplementations(original, override);
    
}

+ (id) singleton {
    
    static void** singletons;    
    static Class* classes;
    static dispatch_once_t* tokens;
    
    static int count  = kMZSingletonInitialTokenCount;
    static int current = 0;  
    
    static dispatch_queue_t sync;
    
    static dispatch_once_t init = 0;    
    dispatch_once(&init, ^{
        sync       = dispatch_queue_create("me.rr.singletons", NULL);
        singletons = (void**)           calloc(count, sizeof(void*)); 
        classes    = (Class*)           calloc(count, sizeof(Class));
        tokens     = (dispatch_once_t*) calloc(count, sizeof(dispatch_once_t));        
    });
    
    Class class = [self class];  
    
    __block int location = kMZSingletonNotFound;
    
    for (int i = 0; i < current; i++) {
        if (classes[i] == class) {
            location = i;
            break;
        }        
    }
    
    if (location == kMZSingletonNotFound) {
        
        dispatch_sync(sync, ^{
            
            for (int i = 0; i < current; i++) {
                if (classes[i] == class) {
                    location = i;
                    break;
                }        
            }
            
            if (location == kMZSingletonNotFound) {
                
                if (count == current) {
                    count     *= 2;        
                    singletons = (void**)           realloc(singletons, count * sizeof(void*)); 
                    classes    = (Class*)           realloc(classes,    count * sizeof(Class));        
                    tokens     = (dispatch_once_t*) realloc(tokens,     count * sizeof(dispatch_once_t));        
                }
                
                location = current;            
                classes[location] = class;
                current++;                
            }            
        });                       
    }
    
    dispatch_once_t* token = &tokens[location];        
    dispatch_once(token, ^{          
        if ([class conformsToProtocol:@protocol(MZSingleton)]) {
            singletons[location] = (__bridge_retained void*)[[class alloc] initSingleton];
        } else {
            singletons[location] = (__bridge_retained void*)[[class alloc] init];             
        }
    });
    
    return (__bridge id) singletons[location];
}

+ (id) mzsingleton_forwardingTargetForSelector:(SEL)selector {
    if ([self conformsToProtocol:@protocol(MZSingleton)]) {
        return [self singleton];
    } 
    return [self mzsingleton_forwardingTargetForSelector:selector];    
}

@end
