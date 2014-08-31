//
//  DTPaddleNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT NSString * const kDTPaddleNodeDefaultName;

@interface DTPaddleNode : SKSpriteNode

+ (instancetype)paddleNodeAtPosition:(CGPoint)position;
+ (instancetype)paddleNodeAtPosition:(CGPoint)position category:(DTCollisionCategory)category;


/*!
  Makes a move towards a certain node. The move, is depending on the paddle's speed. If the distance to the node's center is lower than the paddle's speed, then the paddle aligns directly to the node's center.
 */
- (void)moveTowardsTheCenterOfNode:(SKNode *)node;

/*!
  Makes the appropriate calculations and corrects (if needed) the Y position of the paddle in order to keep it inside a specific frame.
 
  @param frame The frame which contains the paddle
  @param destinationY The Y position to move the paddle. If it's outside of the frame, the position will then be changed and keep the paddle in frame.
 */
- (void)keepInsideFrame:(CGRect)frame withDestinationY:(int)destinationY;

@end
