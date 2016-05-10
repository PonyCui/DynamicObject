//
//  DYNObject.m
//  DynamicObject
//
//  Created by 崔 明辉 on 16/5/10.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import "DYNObject.h"
#import <objc/runtime.h>

@interface DYNWeakObject : NSObject
@property (nonatomic, weak) id anObject;
@end

@implementation DYNWeakObject
@end

@interface DYNObject () {
    NSMutableDictionary *_strongValues;
    NSMutableDictionary *_weakValues;
}

@end

@implementation DYNObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _strongValues = [NSMutableDictionary dictionary];
        _weakValues = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSString *sel = NSStringFromSelector(selector);
    if ([sel rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *aKey = NSStringFromSelector([invocation selector]);
    if ([aKey rangeOfString:@"set"].location == 0) {
        aKey = [[aKey substringWithRange:NSMakeRange(3, [aKey length]-4)] lowercaseString];
        id arg;
        [invocation getArgument:&arg atIndex:2];
        if (arg == nil) {
            [_strongValues removeObjectForKey:aKey];
            [_weakValues removeObjectForKey:aKey];
        }
        else if ([aKey hasPrefix:@"weak"]) {
            DYNWeakObject *weakObject = [[DYNWeakObject alloc] init];
            weakObject.anObject = arg;
            [_weakValues setObject:weakObject forKey:aKey];
        }
        else {
            [_strongValues setObject:arg forKey:aKey];
        }
    } else {
        if ([aKey hasPrefix:@"weak"]) {
            DYNWeakObject *obj = [_weakValues objectForKey:[aKey lowercaseString]];
            id anObject = obj.anObject;
            if (anObject != nil) {
                [invocation setReturnValue:&anObject];
            }
        }
        else {
            id obj = [_strongValues objectForKey:[aKey lowercaseString]];
            [invocation setReturnValue:&obj];
        }
    }
}

@end
