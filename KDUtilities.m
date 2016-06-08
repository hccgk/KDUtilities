//
//  KDCUtil.c
//  koudaixiang
//
//  Created by Liu Yachen on 2/13/12.
//  Copyright (c) 2012 Suixing Tech. All rights reserved.
//

#import "KDUtilities.h"

extern NSNumber *KDUtilIntegerValueNumberGuard(id obj) {
    if (!obj) return nil;
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return @([(NSString *)obj integerValue]);
    }
    return nil;
}

extern NSString *KDUtilStringGuard(id obj) {
    if (!obj) return nil;
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue];
    }
    return nil;
}

@implementation NSObject (KDUtilitiesNotNull)

- (BOOL)KD_notNull {
    return self != [NSNull null];
}

@end


#if TARGET_OS_IOS

#import "KDAlertView.h"
#import <UIKit/UIKit.h>

NSComparisonResult _compareVersions(NSString* leftVersion, NSString* rightVersion)
{
    int i;
    
    // Break version into fields (separated by '.')
    NSMutableArray *leftFields = [[NSMutableArray alloc] initWithArray:[leftVersion componentsSeparatedByString:@"."]];
    NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[rightVersion componentsSeparatedByString:@"."]];
    
    // Implict ".0" in case version doesn't have the same number of '.'
    if ([leftFields count] < [rightFields count]) {
        while ([leftFields count] != [rightFields count]) {
            [leftFields addObject:@"0"];
        }
    } else if ([leftFields count] > [rightFields count]) {
        while ([leftFields count] != [rightFields count]) {
            [rightFields addObject:@"0"];
        }
    }
    
    // Do a numeric comparison on each field
    for(i = 0; i < [leftFields count]; i++) {
        NSComparisonResult result = [leftFields[i] compare:rightFields[i] options:NSNumericSearch];
        if (result != NSOrderedSame) {
            return result;
        }
    }
    
    return NSOrderedSame;
}

BOOL KDUtilIsOSVersionHigherOrEqual(NSString* version) {
    return (_compareVersions([[UIDevice currentDevice] systemVersion], version) != NSOrderedAscending);
}

extern UIView *KDUtilFindViewInSuperViews(UIView *view, Class viewClass) {
    while (view != nil) {
        view = view.superview;
        if ([view isKindOfClass:viewClass]) return view;
    }
    return nil;
}

#endif

extern BOOL KDUtilIsOSMajorVersionHigherOrEqual(int version) {
    static int OSMajorVersion;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
#if TARGET_OS_IOS

        OSMajorVersion = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue];
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        Gestalt(gestaltSystemVersionMinor, &OSMajorVersion);
#pragma clang diagnostic pop
#endif
    });
    
    return OSMajorVersion >= version;
}

extern void KDAssert(BOOL eval, NSString *format, ...) {
    va_list ap;
    va_start(ap, format);
    if (!eval) {
#if TARGET_OS_IOS
        Class class = NSClassFromString(@"KDAlertView");
        if (class) {
            NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
            [[[class alloc] initWithTitle:@"Fatal Error" message:message cancelButtonTitle:@"OK" cancelAction:nil] show];
        }
#endif
#if DEBUG
        [NSException raise:NSInternalInconsistencyException format:format arguments:ap];
#endif
    }
    va_end(ap);
}

@implementation NSNumber (KDUtilities)

- (void)KD_forLoop:(void (^)(int i))block {
    int value = self.intValue;
    
    for (int i = 0; i < value; i++) {
        block(i);
    }
}

@end
