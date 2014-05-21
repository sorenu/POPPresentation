//
// Created by Soren Ulrikkeholm on 21/05/14.
// Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "UIColor+random.h"

@implementation UIColor (random)

// From https://gist.github.com/kylefox/1689973
+ (UIColor *)randomColor {
    CGFloat hue = (CGFloat) ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = (CGFloat) (( arc4random() % 128 / 256.0 ) + 0.5);  //  0.5 to 1.0, away from white
    CGFloat brightness = (CGFloat) (( arc4random() % 128 / 256.0 ) + 0.5);  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


@end