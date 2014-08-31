//
//  DTMyScene.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTTitleScene.h"
#import "DTLabelNode.h"
#import "DTButtonNode.h"
#import "SKScene+Extentions.h"
#import "DTGamePlayScene.h"
#import "DTOptionsScene.h"
#import "SKTAudio.h"



@implementation DTTitleScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [DTUtils based255ColorWithRed:20 green:93 blue:36 alpha:1];
        
        SKSpriteNode *titleBG = [SKSpriteNode spriteNodeWithImageNamed:@"titleBG"];
        titleBG.position = self.center;
        [self addChild:titleBG];
        
        [self addCopyrightLabel];
        
        DTLabelNode *lbTitle   = [DTLabelNode labelNodeWithText:@"Play Pong"
                                                          style:DTLabelNodeStyleTitle
                                                     atPosition:CGPointMake(self.center.x, self.center.y + 100)];
        [self addChild:lbTitle];
        
        DTLabelNode *lbOptions = [DTLabelNode labelNodeWithText:@"Options ↓"
                                                          style:DTLabelNodeStyleSmall
                                                     atPosition:CGPointMake(self.center.x, self.center.y - 120)];
        lbOptions.name = @"options";
        [self addChild:lbOptions];
        
        
        NSString *playForeverText = @"The game never stops!";
        NSString *playForScoreText = [NSString stringWithFormat:@"First who scores %d wins!", DTConstMaxScoreToWinSomeone];
        BOOL firstScores = [[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsFirstScores];
        DTLabelNode *lbInfo = [DTLabelNode labelNodeWithText:(firstScores) ? playForScoreText : playForeverText
                                                       style:DTLabelNodeStyleSmall
                                                  atPosition:CGPointMake(self.center.x, self.center.y - 80)];
        lbInfo.alpha = .2f;
        [self addChild:lbInfo];
        
        
        
        /*
         * Buttons
         * ===================== */
        
        DTButtonNode *btnStart = [DTButtonNode buttonNodeWithName:kDTButtonBeginNodeDefaultName imageNamed:@"btn_one_player" atPosition:CGPointMake(self.center.x , self.center.y + 30)];
        [self addChild:btnStart];
        
        
        DTButtonNode *btnTwoPlayers = [DTButtonNode buttonNodeWithName:@"btn_two_players" imageNamed:@"btn_two_players" atPosition:CGPointMake(self.center.x, self.center.y - 30)];
        [self addChild:btnTwoPlayers];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
       
        
        if ([node isKindOfClass:[DTButtonNode class]]) {
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            [(DTButtonNode *)node performTapAnimationWithCompletion:^{
                [self playBackgroundMusic:kDTMusicGamePlay];
                BOOL twoPlayersMode = [node.name isEqualToString:@"btn_two_players"];
                
                DTGamePlayScene *gameScene = [[DTGamePlayScene alloc] initWithSize:self.frame.size twoPlayersMode:twoPlayersMode];
                SKTransition *transition = [SKTransition fadeWithDuration:1.0f];
                [self.view presentScene:gameScene transition:transition];
            }];
            
        }
        else if ([node.name isEqualToString:@"options"]) {
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            DTOptionsScene *optionsScene = [DTOptionsScene sceneWithSize:self.frame.size];
            SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.6f];
            [self.view presentScene:optionsScene transition:transition];
        }
    }
}

@end
