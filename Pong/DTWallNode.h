//
//  DTWallNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/*!
  An invisible node used for creating borders and advantage of contact delegates etc. It's SKSpriteNode and not a simple SKNode in order to have the ability to se a color, which is useful for debug.
 */
@interface DTWallNode : SKSpriteNode

+ (instancetype)wallNodeAtPosition:(CGPoint)position size:(CGSize)size category:(DTCollisionCategory)category;

@end
