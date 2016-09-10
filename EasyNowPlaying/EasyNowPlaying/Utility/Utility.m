//
//  Utility.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/12.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "Utility.h"
#import <sys/utsname.h>

@implementation Utility

+ (BOOL)saveUserDefaults:(id)object key:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    BOOL successful = [defaults synchronize];
    if (successful) {
        return YES;
    }
    return NO;
}

+ (id)loadUserDefaults:(NSString *)key {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    if (object) {
        return object;
    } else {
        return nil;
    }
}


+ (NSString *)getDeviceName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
@end
