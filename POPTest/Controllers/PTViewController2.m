//
// Created by Soren Ulrikkeholm on 21/05/14.
// Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "PTViewController2.h"
#import "AnimatableObject.h"

@interface PTViewController2 ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) AnimatableObject *animatableObject;
@property (nonatomic, strong) UIBarButtonItem *animationBarButton;

@end

@implementation PTViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    [self setupRAC];
}

- (void)setupView {
    [self.view addSubview:self.label];
    _label.frame = self.view.bounds;
    self.navigationItem.rightBarButtonItem = self.animationBarButton;
}

- (void)setupRAC {
    RAC(self.label, text) = [RACObserve(self.animatableObject, numberProperty) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%d", [value integerValue]];
    }];
}

- (void)startAnimation {
    [self applyAnimationToAnimatableObject:self.animatableObject];
}

- (void)applyAnimationToAnimatableObject:(AnimatableObject *)object {
    POPBasicAnimation *animation = [POPBasicAnimation new];
    animation.removedOnCompletion = NO;
    animation.duration = 10.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    POPAnimatableProperty *customProperty = [POPAnimatableProperty propertyWithName:@"numberProperty" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [[obj numberProperty] floatValue];
        };

        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setNumberProperty:@(values[0])];
        };
    }];

    animation.fromValue = @0;
    animation.toValue = @100;
    animation.property = customProperty;
    [object pop_addAnimation:animation forKey:@"custom"];
}


#pragma mark - Properties

- (UILabel *)label {
    if (!_label) {
        _label = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont fontWithName:@"Helvetica" size:300.f];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label;
        });
    }
    return _label;
}

- (AnimatableObject *)animatableObject {
    if (!_animatableObject) {
        _animatableObject = [AnimatableObject new];
    }
    return _animatableObject;
}

- (UIBarButtonItem *)animationBarButton {
    if (!_animationBarButton) {
        _animationBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(startAnimation)];
    }
    return _animationBarButton;
}

@end