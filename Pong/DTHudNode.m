//
//  DTHudNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTHudNode.h"
#import "DTLabelNode.h"
#import "DTButtonNode.h"

@interface DTHudNode ()

@property (nonatomic, assign) CGRect inFrame;
@property (nonatomic, assign) CGPoint initialP1Position;
@property (nonatomic, assign) CGPoint initialP2Position;


@end


@implementation DTHudNode
@synthesize isMultiplayerEnabled = _isMultiplayerEnabled;

+ (instancetype)hudAtPosition:(CGPoint)position inFrame:(CGRect)frame {
    DTHudNode *hud = [self node];
    hud.position = position;
    hud.zPosition = 1;
    hud.name = @"HUD";
    
    hud.player1Points = 0;
    hud.player2Points = 0;
    
    CGRect firstHalf  = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width / 2, frame.size.height);
    CGRect secondHalf = CGRectMake(frame.origin.x + firstHalf.size.width, 0, firstHalf.size.width, frame.size.height);
    
    hud.inFrame = frame;
    hud.initialP1Position = CGPointMake(CGRectGetMidX(firstHalf), firstHalf.size.height - 30);
    hud.initialP2Position = CGPointMake(CGRectGetMidX(secondHalf), secondHalf.size.height - 30);
    
    
    /*
     * Player 1
     * ======================= */
    DTLabelNode *player1ScoreNode = [DTLabelNode labelNodeWithText:[NSString stringWithFormat:@"Score: %ld", (long)hud.player1Points]
                                                             style:DTLabelNodeStyleNormal
                                                        atPosition:hud.initialP1Position];
    player1ScoreNode.name = @"player1Score";
    player1ScoreNode.alpha = 0.1f;
    [hud addChild:player1ScoreNode];
    
    
    /*
     * Player 2
     * ======================= */
    DTLabelNode *player2ScoreNode = [DTLabelNode labelNodeWithText:[NSString stringWithFormat:@"Score: %ld", (long)hud.player2Points]
                                                             style:DTLabelNodeStyleNormal
                                                        atPosition:hud.initialP2Position];
    player2ScoreNode.name = @"player2Score";
    player2ScoreNode.alpha = 0.1f;
    [hud addChild:player2ScoreNode];
    
    
    return hud;
}

- (BOOL)isMultiplayerEnabled {
    return _isMultiplayerEnabled;
}

- (void)setIsMultiplayerEnabled:(BOOL)isMultiplayerEnabled {
    
    if (_isMultiplayerEnabled == isMultiplayerEnabled)
        return;
    _isMultiplayerEnabled = isMultiplayerEnabled;
    
    DTLabelNode *player1ScoreNode = (DTLabelNode *)[self childNodeWithName:@"player1Score"];
    DTLabelNode *player2ScoreNode = (DTLabelNode *)[self childNodeWithName:@"player2Score"];
    if (_isMultiplayerEnabled) {
        CGPoint center = [DTUtils centerOfRect:_inFrame];
        
        SKAction *action1 = [SKAction rotateToAngle:degreesToRadians(-90) duration:0.3f];
        SKAction *action2 = [SKAction moveTo:CGPointMake(center.x - 30, center.y) duration:0.3f];
        [player1ScoreNode runAction:[SKAction group:@[action1, action2]]];
        
        
        SKAction *action3 = [SKAction rotateToAngle:degreesToRadians(90) duration:0.3f];
        SKAction *action4 = [SKAction moveTo:CGPointMake(center.x + 30, center.y) duration:0.3f];
        [player2ScoreNode runAction:[SKAction group:@[action3, action4]]];
    }
    else {
        SKAction *action1 = [SKAction rotateToAngle:0 duration:0.3f];
        SKAction *action2 = [SKAction moveTo:self.initialP1Position duration:0.3f];
        [player1ScoreNode runAction:[SKAction group:@[action1, action2]]];
        
        
        SKAction *action3 = [SKAction rotateToAngle:0 duration:0.3f];
        SKAction *action4 = [SKAction moveTo:self.initialP2Position duration:0.3f];
        [player2ScoreNode runAction:[SKAction group:@[action3, action4]]];
    }
}





- (void)addToPlayer1APoint {
    [self addToPlayer1Points:1];
}

- (void)addToPlayer2APoint {
    [self addToPlayer2Points:1];
}

- (void)addToPlayer1Points:(NSInteger)points {
    self.player1Points += points;
    
    DTLabelNode *scoreNode = (DTLabelNode *)[self childNodeWithName:@"player1Score"];
    scoreNode.text = [NSString stringWithFormat:@"Score: %ld", (long)self.player1Points];
}

- (void)addToPlayer2Points:(NSInteger)points {
    self.player2Points += points;
    
    DTLabelNode *scoreNode = (DTLabelNode *)[self childNodeWithName:@"player2Score"];
    scoreNode.text = [NSString stringWithFormat:@"Score: %ld", (long)self.player2Points];
}


@end
