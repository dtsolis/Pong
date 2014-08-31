//
//  DTLabelNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTLabelNode.h"

@implementation DTLabelNode

+ (instancetype)labelNodeWithText:(NSString *)text atPosition:(CGPoint)position {
    return [DTLabelNode labelNodeWithText:text style:DTLabelNodeStyleNormal atPosition:position];
}

+ (instancetype)labelNodeWithText:(NSString *)text style:(DTLabelNodeStyle)style atPosition:(CGPoint)position {
    DTLabelNode *labelNode = [DTLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.position = position;
    labelNode.text = text;
    labelNode.fontSize = style;
    
    return labelNode;
}

- (void)setVisible:(BOOL)visible animated:(BOOL)animated {
    if (!animated) {
        self.xScale = (visible) ? 1 : 0;
        self.yScale = (visible) ? 1 : 0;
    }
    
    if (visible) {
        self.xScale = 0;
        self.yScale = 0;
        SKAction *scaleUp = [SKAction scaleTo:1.2f duration:0.35f];
        SKAction *scaleDown = [SKAction scaleTo:1.0f duration:0.15f];
        SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleDown]];
        [self runAction:scaleSequence];
    }
    else {
        [self runAction:[SKAction scaleTo:0 duration:0.35f]];
    }
}


@end
