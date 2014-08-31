//
//  DTWallNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTWallNode.h"

@implementation DTWallNode
+ (instancetype)wallNodeAtPosition:(CGPoint)position size:(CGSize)size category:(DTCollisionCategory)category {
    DTWallNode *wall = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    wall.position = position;
    
    [wall setupPhysicsBodyWithCategory:category];
    
    return wall;
}

- (void)setupPhysicsBodyWithCategory:(DTCollisionCategory)category {
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = category;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = DTCollisionCategoryBall;
}
@end
