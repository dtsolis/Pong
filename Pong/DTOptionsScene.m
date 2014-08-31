//
//  DTOptionsScene.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTOptionsScene.h"
#import "DTLabelNode.h"
#import "SKScene+Extentions.h"
#import "DTTitleScene.h"
#import "DTCheckBoxNode.h"
#import "DTBallNode.h"

@implementation DTOptionsScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [DTUtils based255ColorWithRed:20 green:93 blue:36 alpha:1];
        
        [self addCopyrightLabel];
        
        DTLabelNode *lbTitle   = [DTLabelNode labelNodeWithText:@"Options"
                                                          style:DTLabelNodeStyleTitle
                                                     atPosition:CGPointMake(self.center.x, self.center.y + 100)];
        [self addChild:lbTitle];
        
        DTLabelNode *lbMain    = [DTLabelNode labelNodeWithText:@"Main Menu ↑"
                                                          style:DTLabelNodeStyleSmall
                                                     atPosition:CGPointMake(self.center.x, self.center.y - 120)];
        lbMain.name = @"mainMenu";
        [self addChild:lbMain];
        
        
        
        /*
         * Option 1
         * ================= */
        DTLabelNode *lbOption  = [DTLabelNode labelNodeWithText:@"Games are endless"
                                                          style:DTLabelNodeStyleNormal
                                                     atPosition:CGPointMake(self.center.x - 20, self.center.y + 54)];
        lbOption.name = @"labelOption";
        lbOption.fontColor = [SKColor yellowColor];
        [self addChild:lbOption];
        
        
        DTCheckBoxNode *checkbox = [DTCheckBoxNode checkBoxNodeAtPosition:CGPointMake(self.center.x + 140, self.center.y + 61)];
        checkbox.name = @"checkboxScore";
        checkbox.isChecked = ![[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsFirstScores];
        checkbox.valueChangedBlock = ^(BOOL newValue) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:!newValue forKey:kDTDefaultsFirstScores];
            [defaults synchronize];
        };
        [self addChild:checkbox];
        
        
        
        /*
         * Option 2
         * ================= */
        DTLabelNode *lbOption2  = [DTLabelNode labelNodeWithText:@"Music is enabled"
                                                          style:DTLabelNodeStyleNormal
                                                     atPosition:CGPointMake(self.center.x - 20, self.center.y + 7)];
        lbOption2.name = @"labelOption2";
        lbOption2.fontColor = [SKColor yellowColor];
        [self addChild:lbOption2];
        
        
        DTCheckBoxNode *checkbox2 = [DTCheckBoxNode checkBoxNodeAtPosition:CGPointMake(self.center.x + 140, self.center.y + 16)];
        checkbox2.name = @"checkboxMusic";
        checkbox2.isChecked = [[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsMusicEnabled];
        checkbox2.valueChangedBlock = ^(BOOL newValue) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:newValue forKey:kDTDefaultsMusicEnabled];
            [defaults synchronize];
            
            
            if (newValue) {
                [self resumeBackgroundMusic];
            }
            else {
                [self pauseBackgroundMusic];
            }
        };
        [self addChild:checkbox2];
        
        
        /*
         * Option 3
         * ================= */
        DTLabelNode *lbOption3  = [DTLabelNode labelNodeWithText:@"Sound effects are enabled"
                                                           style:DTLabelNodeStyleNormal
                                                      atPosition:CGPointMake(self.center.x - 20, self.center.y - 38)];
        lbOption3.name = @"labelOption3";
        lbOption3.fontColor = [SKColor yellowColor];
        [self addChild:lbOption3];
        
        
        DTCheckBoxNode *checkbox3 = [DTCheckBoxNode checkBoxNodeAtPosition:CGPointMake(self.center.x + 140, self.center.y - 30)];
        checkbox3.name = @"checkboxSfx";
        checkbox3.isChecked = [[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsSfxEnabled];
        checkbox3.valueChangedBlock = ^(BOOL newValue) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:newValue forKey:kDTDefaultsSfxEnabled];
            [defaults synchronize];
        };
        [self addChild:checkbox3];
        
        
        
        
        /*
         * Option 4
         * ================= */
        DTLabelNode *lbOption4  = [DTLabelNode labelNodeWithText:@"Select ball"
                                                           style:DTLabelNodeStyleNormal
                                                      atPosition:CGPointMake(self.center.x - 20, self.center.y - 80)];
        lbOption4.name = @"labelOption4";
        lbOption4.fontColor = [SKColor yellowColor];
        [self addChild:lbOption4];
        
        
        DTBallNode *ballNode = [DTBallNode ballNodeAtPosition:CGPointMake(self.center.x + 140, self.center.y - 80) presentationMode:YES];
        ballNode.anchorPoint = CGPointMake(0.5, 0.0);
        [self addChild:ballNode];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"mainMenu"]) {
            if (node.alpha < 1)
                return;
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            
            DTTitleScene *titleScene = [DTTitleScene sceneWithSize:self.frame.size];
            SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionDown duration:0.6f];
            [self.view presentScene:titleScene transition:transition];
        }
        else if ([node.name hasPrefix:@"checkbox"]) {
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            
            DTCheckBoxNode *checkbox = (DTCheckBoxNode *)node;
            checkbox.isChecked = !checkbox.isChecked;
        }
        else if ([node.name isEqualToString:kDTBallNodeDefaultName]) {
            [self hideAllNodes];
            [self showMoreBalls];
        }
        else if ([node.name hasPrefix:@"ball_"]) {
            
            DTBallNode *selectedBall = (DTBallNode *)[self childNodeWithName:kDTBallNodeDefaultName];
            selectedBall.texture = [SKTexture textureWithImageNamed:node.name];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:node.name forKey:kDTDefaultsSelectedBall];
            [defaults synchronize];
            
            [self removeMoreBalls];
            [self showAllNodes];
        }
    }
}



#pragma mark - Helpers
- (void)hideAllNodes {
    for (SKNode *node in self.children) {
        if (![node.name isEqualToString:@"copyright"]) {
            
            if ([node isKindOfClass:[DTCheckBoxNode class]] || [node.name isEqualToString:@"labelOption4"]) {
                [node runAction:[SKAction fadeOutWithDuration:.35f]];
            }
            else if ([node.name hasPrefix:@"labelOption"] || [node.name isEqualToString:@"mainMenu"]) {
                [node runAction:[SKAction fadeAlphaTo:.1f duration:.35f]];
            }
        }
    }
}

- (void)showAllNodes {
    for (SKNode *node in self.children) {
        [node runAction:[SKAction fadeInWithDuration:.35f]];
    }
}

- (void)removeMoreBalls {
    DTBallNode *selectedBall = (DTBallNode *)[self childNodeWithName:kDTBallNodeDefaultName];
    for (SKNode *node in self.children) {
        if ([node.name hasPrefix:@"ball_"]) {
            DTBallNode *tmp = (DTBallNode *)node;
            [tmp runAction:[SKAction sequence:@[[SKAction moveTo:selectedBall.position duration:0.35f],
                                                [SKAction fadeOutWithDuration:0.20f],
                                                [SKAction removeFromParent]]]];
        }
        
    }
}

- (void)showMoreBalls {
    DTBallNode *selectedBall = (DTBallNode *)[self childNodeWithName:kDTBallNodeDefaultName];
    for (int i = 0; i < DTConstTotalBallsAvailable; i++) {
        NSString *currentBall = [NSString stringWithFormat:@"ball_%d", i];
        
        DTBallNode *ballNode = [DTBallNode ballNodeAtPosition:CGPointMake(self.center.x + 140, self.center.y - 80) presentationMode:YES];
        ballNode.anchorPoint = CGPointMake(0.5, 0.0);
        ballNode.name = currentBall;
        ballNode.texture = [SKTexture textureWithImageNamed:currentBall];
        ballNode.position = selectedBall.position;
        ballNode.zPosition = 10;
        [self addChild:ballNode];
        
        int awayFromSelected = (-1)*(selectedBall.size.width + 30) * i;
        [ballNode runAction:[SKAction moveBy:CGVectorMake(awayFromSelected, 0) duration:0.35f]];
    }
}



@end
