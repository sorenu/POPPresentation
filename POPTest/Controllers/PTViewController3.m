//
// Created by Soren Ulrikkeholm on 21/05/14.
// Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "PTViewController3.h"
#import "PTFrameBuilder.h"

static NSString * const kCoreAnimationAnimationKey = @"kCoreAnimationAnimationKey";
static NSString * const kPopAnimationKey = @"kPopAnimationKey";

@interface PTViewController3 ()

@property (nonatomic, strong) UIView *coreAnimationAnimatedView;
@property (nonatomic, strong) UIView *popAnimatedView;

@property (nonatomic, strong) UIBarButtonItem *startBarButton;
@property (nonatomic, strong) UIBarButtonItem *stopBarButton;

@end

@implementation PTViewController3

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSubviews];
    [self setupInitialState];
}

- (void)addSubviews {
    [self.view addSubview:self.coreAnimationAnimatedView];
    [self.view addSubview:self.popAnimatedView];
    self.navigationItem.rightBarButtonItem = self.startBarButton;
    self.navigationItem.leftBarButtonItem = self.stopBarButton;
}

- (void)setupInitialState {
    self.coreAnimationAnimatedView.frame = [PTFrameBuilder leftStartFrame];
    self.popAnimatedView.frame = [PTFrameBuilder rightStartFrame];
}

- (void)startAnimations {
    [self applyCoreAnimationToView:self.coreAnimationAnimatedView];
    [self applyPopAnimationToView:self.popAnimatedView];
}

- (void)stopAnimations {
    [self removeCoreAnimationFromView:self.coreAnimationAnimatedView];
    [self removePopAnimationFromView:self.popAnimatedView];
}

- (void)removeCoreAnimationFromView:(UIView *)view {
    [view.layer removeAnimationForKey:kCoreAnimationAnimationKey];
}

- (void)removePopAnimationFromView:(UIView *)view {
    [view pop_removeAnimationForKey:kPopAnimationKey];
}

- (void)applyCoreAnimationToView:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 10.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = [NSValue valueWithCGPoint:[PTFrameBuilder leftEndFrame].origin];
    [view.layer addAnimation:animation forKey:kCoreAnimationAnimationKey];
}

- (void)applyPopAnimationToView:(UIView *)view {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.duration = 10.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = [NSValue valueWithCGPoint:[PTFrameBuilder rightEndFrame].origin];
    [view pop_addAnimation:animation forKey:kPopAnimationKey];
}


#pragma mark - Lazy loading views

- (UIView *)coreAnimationAnimatedView {
    if (!_coreAnimationAnimatedView) {
        _coreAnimationAnimatedView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor redColor];
            view;
        });
    }
    return _coreAnimationAnimatedView;
}

- (UIView *)popAnimatedView {
    if (!_popAnimatedView) {
        _popAnimatedView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor blueColor];
            view;
        });
    }
    return _popAnimatedView;
}

- (UIBarButtonItem *)startBarButton {
    if (!_startBarButton) {
        _startBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(startAnimations)];
    }
    return _startBarButton;
}

- (UIBarButtonItem *)stopBarButton {
    if (!_stopBarButton) {
        _stopBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopAnimations)];
    }
    return _stopBarButton;
}


@end