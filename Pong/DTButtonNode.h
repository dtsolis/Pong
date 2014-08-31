//
//  DTButtonNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT NSString * const kDTButtonBeginNodeDefaultName;

@interface DTButtonNode : SKSpriteNode

+ (instancetype)buttonNodeAtPosition:(CGPoint)position;
+ (instancetype)buttonNodeWithName:(NSString *)name imageNamed:(NSString *)imageNamed atPosition:(CGPoint)position;

- (void)performTapAnimationWithCompletion:(void (^)())block;

@end
