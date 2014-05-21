//
// Created by Soren Ulrikkeholm on 06/05/14.
// Copyright (c) 2014 SHAPE A/S. All rights reserved.
//


@interface PTFrameBuilder : NSObject

+ (CGRect)smallRect;
+ (CGRect)bigRect;

+ (CGRect)leftStartFrame;
+ (CGRect)leftEndFrame;
+ (CGRect)rightStartFrame;
+ (CGRect)rightEndFrame;

@end