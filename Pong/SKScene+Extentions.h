//
//  SKScene+Extentions.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScene (Extentions)

/// The center of the frame.
- (CGPoint)center;

- (CGRect)leftHalfFrame;
- (CGRect)rightHalfFrame;

@end
