//
//  DTHudNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DTHudNode : SKNode

@property (nonatomic) NSInteger player1Points;
@property (nonatomic) NSInteger player2Points;
@property (nonatomic, assign) BOOL isMultiplayerEnabled;

+ (instancetype)hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

- (void)addToPlayer1APoint;
- (void)addToPlayer2APoint;

- (void)addToPlayer1Points:(NSInteger)points;
- (void)addToPlayer2Points:(NSInteger)points;

@end
