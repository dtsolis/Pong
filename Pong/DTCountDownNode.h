//
//  DTCountDownNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DTCountDownNode : SKNode

+ (instancetype)countDownNodeAtPosition:(CGPoint)position;

/*!
  Starts the count from a given number (max is 4).
 
  @param count The number to start count (max is 4).
  @param block Completion block.
 */
- (void)countDownFromNumber:(NSInteger)count completion:(void (^)())block;
- (void)stop;

@end
