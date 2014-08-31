//
//  DTCountDownNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTCountDownNode.h"
#import "DTLabelNode.h"

@interface DTCountDownNode ()

@property (nonatomic, assign) BOOL orderedToStop;

@end

@implementation DTCountDownNode

+ (instancetype)countDownNodeAtPosition:(CGPoint)position {
    DTCountDownNode *countDownNode = [self node];
    countDownNode.position = CGPointMake(0, 0);
    countDownNode.orderedToStop = NO;
    
    
    SKSpriteNode *numberNode = [SKSpriteNode spriteNodeWithImageNamed:@"cd_4"];
    numberNode.anchorPoint = CGPointMake(0.5, 0.5);
    numberNode.position = position;
    numberNode.name = @"numberNode";
    [countDownNode addChild:numberNode];
    
    
    return countDownNode;
}


- (void)countDownFromNumber:(NSInteger)count completion:(void (^)())block {
    
    if (count > 0) {
        NSString *imageName = [NSString stringWithFormat:@"cd_%ld", (long)count];
        SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
        
        if (count > 4) {
            texture = [SKTexture textureWithImageNamed:@"cd_unknown"];
        }
        
        SKSpriteNode *node = (SKSpriteNode *) [self childNodeWithName:@"numberNode"];
        node.texture = texture;
        node.xScale = 0;
        node.yScale = 0;
        node.alpha = 1;
        
        __block NSInteger blockCount = count;
        
        SKAction *scaleUp    = [SKAction scaleTo:1 duration:0.35f];
        SKAction *pop        = [SKAction playSoundFileNamed:kDTSoundEffectsBubblePop waitForCompletion:NO];
        SKAction *waitAction = [SKAction waitForDuration:0.3f];
        SKAction *scaleDown  = [SKAction scaleTo:0 duration:0.35f];
        SKAction *run        = [SKAction runBlock:^{
            if (self.orderedToStop) {
                [self removeFromParent];
                return;
            }
            blockCount--;
            [self countDownFromNumber:blockCount completion:block];
        }];
        
        
        NSArray *sequenceArray = [NSArray array];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsSfxEnabled]) {
            sequenceArray = @[pop, scaleUp, waitAction, scaleDown, run];
        }
        else {
            sequenceArray = @[scaleUp, waitAction, scaleDown, run];
        }
            
        SKAction *scaleSequence = [SKAction sequence:sequenceArray];
        [node runAction:scaleSequence];
    }
    else {
        [self removeFromParent]; // remove the node completely
        if (block)
            block();
    }
}

- (void)stop {
    self.orderedToStop = YES;
}

@end
