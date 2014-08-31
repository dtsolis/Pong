//
//  DTLabelNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, DTLabelNodeStyle) {
    DTLabelNodeStyleExtraSmall = 9,
    DTLabelNodeStyleSmall = 14,
    DTLabelNodeStyleNormal = 17,
    DTLabelNodeStyleSubtitle = 19,
    DTLabelNodeStyleTitle= 24,
    DTLabelNodeStyleBig = 30,
    DTLabelNodeStyleExtraBig = 110
};


@interface DTLabelNode : SKLabelNode

+ (instancetype)labelNodeWithText:(NSString *)text atPosition:(CGPoint)position;
+ (instancetype)labelNodeWithText:(NSString *)text style:(DTLabelNodeStyle)style atPosition:(CGPoint)position;
- (void)setVisible:(BOOL)visible animated:(BOOL)animated;

@end
