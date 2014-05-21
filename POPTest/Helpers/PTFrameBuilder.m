//
// Created by Soren Ulrikkeholm on 06/05/14.
// Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "PTFrameBuilder.h"

@interface PTFrameBuilder ()

@end

@implementation PTFrameBuilder

+ (CGRect)smallRect {
    static CGRect result;

    result.origin = (CGPoint){10.f, 10.f};
    result.size = (CGSize){10.f, 10.f};

    return result;
}

+ (CGRect)bigRect {
    static CGRect result;

    result.origin = (CGPoint){100.f, 200.f};
    result.size = (CGSize){200.f, 200.f};

    return result;
}

+ (CGRect)leftStartFrame {
    static CGRect result;

    result.origin = (CGPoint){200.f, 100.f};
    result.size = (CGSize){100.f, 100.f};

    return result;
}

+ (CGRect)leftEndFrame {
    static CGRect result;

    result.origin = (CGPoint){200.f, 800.f};
    result.size = (CGSize){100.f, 100.f};

    return result;
}

+ (CGRect)rightStartFrame {
    static CGRect result;

    result.origin = (CGPoint){500.f, 100.f};
    result.size = (CGSize){100.f, 100.f};

    return result;
}

+ (CGRect)rightEndFrame {
    static CGRect result;

    result.origin = (CGPoint){500.f, 800.f};
    result.size = (CGSize){100.f, 100.f};

    return result;
}


@end