//
//  UIImage+Ex.m
//  EasyNowPlaying
//
//  Created by inaba masaya on 2015/11/28.
//  Copyright © 2015年 inaba masaya. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage (Ex)

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius {
    UIImage *resultImage;
    UIImage *maskImage;
    CGRect imageBounds = (CGRect){CGPointZero, self.size};

    // Make mask image
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageBounds cornerRadius:cornerRadius];
    UIGraphicsBeginImageContextWithOptions(path.bounds.size, NO, 0.0);
    [[UIColor blackColor] setFill];
    [path fill];
    maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Draw image
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, imageBounds, [maskImage CGImage]);
    [self drawAtPoint:CGPointZero];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
