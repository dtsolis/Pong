//
//  DTBallNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT NSString * const kDTBallNodeDefaultName;

@interface DTBallNode : SKSpriteNode

+ (instancetype)ballNodeAtPosition:(CGPoint)position;
+ (instancetype)ballNodeAtPosition:(CGPoint)position presentationMode:(BOOL)presentationMode;


/// Increases the ball's speed.
- (void)speedUp;
/// Applies an impulse to start the ball moving.
- (void)kickOff;
/// Resets the velocity to stop it from moving.
- (void)freeze;

- (void)fireOppositeToAngle:(float)angle;
- (void)fireUp;
- (void)fireReset;

@end
