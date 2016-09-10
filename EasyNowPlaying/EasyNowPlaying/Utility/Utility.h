//
//  Utility.h
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/12/12.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (BOOL)saveUserDefaults:(id)object key:(NSString *)key;
+ (id)loadUserDefaults:(NSString *)key;
+ (NSString *)getDeviceName;

@end
