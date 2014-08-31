//
//  DTPaddleNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTPaddleNode.h"

NSString *const kDTPaddleNodeDefaultName = @"paddle";

@implementation DTPaddleNode

+ (instancetype)paddleNodeAtPosition:(CGPoint)position {
    CGFloat height = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 100 : 50;
    DTPaddleNode *paddleNode = [self spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(10, height)];
    paddleNode.position = position;
    paddleNode.name = kDTPaddleNodeDefaultName;
    
    [paddleNode setupPhysicsBody];
    
    return paddleNode;
}

+ (instancetype)paddleNodeAtPosition:(CGPoint)position category:(DTCollisionCategory)category {
    DTPaddleNode *paddle = [self paddleNodeAtPosition:position];
    paddle.physicsBody.categoryBitMask = category;
    return paddle;
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.friction = 0.4f;
    self.physicsBody.restitution = 0.1f;
    self.physicsBody.dynamic = NO;
}


#pragma mark - Align AI
- (void)moveTowardsTheCenterOfNode:(SKNode *)node {
    CGFloat yDifference = node.position.y - self.position.y;
    NSInteger sign = [DTUtils signForNumber:yDifference];
    CGFloat absoluteDiff = yDifference * sign;
    
    CGFloat speed = (isIPad) ? DTConstLeftPaddleSpeediPad : DTConstLeftPaddleSpeediPhone;
    if (absoluteDiff < speed)
        speed = absoluteDiff;
    CGFloat yToMoveTo = self.position.y + (sign * speed);
    
    [self keepInsideFrame:self.scene.frame withDestinationY:yToMoveTo];
}

- (void)keepInsideFrame:(CGRect)frame withDestinationY:(int)destinationY {
    destinationY = MAX(destinationY, self.size.height/2);
    destinationY = MIN(destinationY, frame.size.height - self.size.height/2);
    self.position = CGPointMake(self.position.x, destinationY);
}

@end
