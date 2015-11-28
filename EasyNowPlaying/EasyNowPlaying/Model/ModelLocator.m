//
//  ModelLocator.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "ModelLocator.h"

@implementation ModelLocator

static ModelLocator *_instance;

#pragma mark - Initializer
+ (void)initialize {
    
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ModelLocator alloc] initInternal];
        }
    }
}

+ (ModelLocator *)sharedInstance {
    
    return _instance;
}

- (id)init {
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initInternal {
    
    self = [super init];
    self.playbackViewModel = [[PlaybackViewModel alloc] init];
    return self;
}

@end
