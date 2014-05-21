//
// Created by Soren Ulrikkeholm on 06/05/14.
// Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "PTViewController.h"
#import "PTFrameBuilder.h"

static NSString * const kMoveAnimationKey = @"kMoveAnimationKey";
static NSString * const kTransformSizeAnimationKey = @"kTransformSizeAnimationKey";
static NSString * const kTransformShapeAnimationKey = @"kTransformShapeAnimationKey";
static NSString * const kChangeColorAnimationKey = @"kChangeColorAnimationKey";
static NSString * const kDecayAnimationKey = @"kDecayAnimationKey";

@interface PTViewController ()

@property (nonatomic, strong) UIView *shape;

@end

@implementation PTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self addSubviews];
    [self setupInitialState];
    [self setupGestureRecognizer];
}

- (void)addSubviews {
    [self.view addSubview:self.shape];
}

- (void)setupInitialState {
    self.shape.backgroundColor = [UIColor orangeColor];
    self.shape.frame = [PTFrameBuilder smallRect];
}


#pragma mark - Gestures

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *mainViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    [self.view addGestureRecognizer:mainViewGestureRecognizer];

    UITapGestureRecognizer *shapeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shapeWasTapped:)];
    [self.shape addGestureRecognizer:shapeGestureRecognizer];

    UIPanGestureRecognizer *shapePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(shapeDidPan:)];
    [self.shape addGestureRecognizer:shapePanGestureRecognizer];
}

- (void)shapeDidPan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    CGPoint destination = [gestureRecognizer locationInView:self.view];

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self moveDecayAnimationOnObject:gestureRecognizer.view withVelocity:velocity];
    }
    else {
//        self.shape.center = destination;
        [self moveSpringAnimationOnObject:gestureRecognizer.view toPoint:destination];
    }
}

- (void)viewWasTapped:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint destination = [gestureRecognizer locationInView:self.view];

    [self moveSpringAnimationOnObject:self.shape toPoint:destination];
}

- (void)shapeWasTapped:(UITapGestureRecognizer *)gestureRecognizer {
    static NSInteger tapCount = 0;
    tapCount++;

    UIView *shape = gestureRecognizer.view;

    if (1 == tapCount) {
        [self transformSizeSpringAnimationOnObject:shape];
    }
    else if (2 == tapCount) {
        [self transformToCircleBasicAnimationOnObject:shape];
    }
    else if (3 == tapCount) {
        [self changeColorBasicAnimationOnObject:shape];
    }
    else if (4 == tapCount) {
        [self transformToSquareBasicAnimationOnObject:shape];
    }

    else {
        [self setupInitialState];
        tapCount = 0;
    }
}

#pragma mark - POP Animations

- (void)moveDecayAnimationOnObject:(UIView *)view withVelocity:(CGPoint)velocity {
    POPDecayAnimation *animation = [view pop_animationForKey:kDecayAnimationKey];

    if (!animation) {
        animation = [POPDecayAnimation animationWithPropertyNamed:kPOPViewCenter];
        [view pop_addAnimation:animation forKey:kDecayAnimationKey];
        animation.deceleration = 0.99;
    }

    animation.velocity = [NSValue valueWithCGPoint:(CGPoint){velocity.x, velocity.y}];
}

- (void)changeColorBasicAnimationOnObject:(UIView *)view {
    POPBasicAnimation *animation = [view pop_animationForKey:kChangeColorAnimationKey];

    if (!animation) {
        animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 1.0f;
        [view pop_addAnimation:animation forKey:kChangeColorAnimationKey];
    }

    animation.toValue = [UIColor blueColor];
}

- (void)transformToCircleBasicAnimationOnObject:(UIView *)view {
    POPSpringAnimation *animation = [view pop_animationForKey:kTransformShapeAnimationKey];

    if (!animation) {
        animation = [self cornerRadiusAnimation];
        [view.layer pop_addAnimation:animation forKey:kTransformShapeAnimationKey];
    }

    animation.toValue = @([PTFrameBuilder bigRect].size.width/2);
}

- (void)transformToSquareBasicAnimationOnObject:(UIView *)view {
    POPSpringAnimation *animation = [view.layer pop_animationForKey:kTransformShapeAnimationKey];
    animation.toValue = @(0);
}

- (POPSpringAnimation *)cornerRadiusAnimation {
    POPSpringAnimation *animation = [POPSpringAnimation new];
    animation.removedOnCompletion = NO;

    POPAnimatableProperty *customProperty = [POPAnimatableProperty propertyWithName:@"layer.cornerRadius" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(id obj, CGFloat values[]) {
                values[0] = [obj cornerRadius];
            };

            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                [obj setCornerRadius:values[0]];
            };
        }];
    animation.property = customProperty;

    return animation;
}

- (void)transformSizeSpringAnimationOnObject:(id)animatableObject {
    POPSpringAnimation *animation = [animatableObject pop_animationForKey:kTransformSizeAnimationKey];

    if (!animation) {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
        animation.springSpeed = 50;
        animation.springBounciness = 50;
        [animatableObject pop_addAnimation:animation forKey:kTransformSizeAnimationKey];
    }

    animation.toValue = [NSValue valueWithCGSize:[PTFrameBuilder bigRect].size];
}

- (void)moveSpringAnimationOnObject:(id)animatableObject toPoint:(CGPoint)destination {
    POPSpringAnimation *animation = [animatableObject pop_animationForKey:kMoveAnimationKey];

    if (!animation) {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        animation.springSpeed = 3;
        animation.springBounciness = 3;
        [animatableObject pop_addAnimation:animation forKey:kMoveAnimationKey];
    }

    animation.toValue = [NSValue valueWithCGPoint:destination];
}


#pragma mark - UIView animations

- (void)moveUIViewAnimationOnObject:(UIView *)animatableView toPoint:(CGPoint)destination {
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [animatableView setCenter:destination];
                     } completion:^(BOOL finished) {

    }];
}


#pragma mark - Lazy loading views

- (UIView *)shape {
    if (!_shape) {
        _shape = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor orangeColor];
            view;
        });
    }
    return _shape;
}

@end