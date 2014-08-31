//
//  DTButtonNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTButtonNode.h"
#import "DTLabelNode.h"


NSString *const kDTButtonBeginNodeDefaultName = @"buttonBegin";

@implementation DTButtonNode

+ (instancetype)buttonNodeAtPosition:(CGPoint)position {
    return [DTButtonNode buttonNodeWithName:nil imageNamed:nil atPosition:position];
}

+ (instancetype)buttonNodeWithName:(NSString *)name imageNamed:(NSString *)imageNamed atPosition:(CGPoint)position {
    if (imageNamed.length == 0)
        imageNamed = @"btn_begin";
    
    DTButtonNode *buttonNode = [DTButtonNode spriteNodeWithImageNamed:imageNamed];
    buttonNode.position = position;
    if (name.length > 0) {
        buttonNode.name = name;
    }
    else {
        buttonNode.name = kDTButtonBeginNodeDefaultName;
    }
    
    return buttonNode;
}

- (void)performTapAnimationWithCompletion:(void (^)())block {
    SKAction *scaleDown = [SKAction scaleTo:0.95f duration:0.15f];
    SKAction *scaleDefault = [SKAction scaleTo:1.0f duration:0.15f];
    SKAction *runAction = [SKAction runBlock:^{
        if (block)
            block();
    }];
    SKAction *scaleSequence = [SKAction sequence:@[scaleDown, scaleDefault, runAction]];
    [self runAction:scaleSequence];
}

@end
