//
//  DTGameOverScene.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTGameOverScene.h"
#import "DTLabelNode.h"
#import "DTTitleScene.h"
#import "DTGamePlayScene.h"
#import "SKScene+Extentions.h"
#import "DSMultilineLabelNode.h"

@interface DTGameOverScene ()
{
    BOOL _wasTwoPlayersMode;
}

@end

@implementation DTGameOverScene

- (instancetype)initWithSize:(CGSize)size title:(NSString *)title message:(NSString *)message twoPlayersMode:(BOOL)twoPlayersMode {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [DTUtils based255ColorWithRed:20 green:93 blue:36 alpha:1];
        
        DTLabelNode *copyright = [DTLabelNode labelNodeWithText:@"© DFG-Team"
                                                          style:DTLabelNodeStyleExtraSmall
                                                     atPosition:CGPointMake(45, 10)];
        copyright.fontColor    = [DTUtils based255ColorWithRed:85 green:140 blue:97 alpha:1];
        [self addChild:copyright];
        
        DTLabelNode *lbTitle   = [DTLabelNode labelNodeWithText:title
                                                          style:DTLabelNodeStyleTitle
                                                     atPosition:CGPointMake(self.center.x, self.center.y + 80)];
        [self addChild:lbTitle];
        
        DSMultilineLabelNode *lbMessage = [DSMultilineLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        lbMessage.position = CGPointMake(self.center.x, self.center.y);
        lbMessage.fontSize = DTLabelNodeStyleSubtitle;
        lbMessage.paragraphWidth = 400;
        lbMessage.fontColor = [SKColor yellowColor];
        lbMessage.text = message;
        [self addChild:lbMessage];
        
        
        DTLabelNode *lbMain    = [DTLabelNode labelNodeWithText:@"← Back to main menu"
                                                          style:DTLabelNodeStyleNormal
                                                     atPosition:CGPointMake(self.center.x, self.center.y - 80)];
        lbMain.name = @"mainMenu";
        [self addChild:lbMain];
        
        DTLabelNode *lbRestart = [DTLabelNode labelNodeWithText:@"Restart game ↺"
                                                          style:DTLabelNodeStyleNormal
                                                     atPosition:CGPointMake(self.center.x, self.center.y - 120)];
        lbRestart.name = @"restart";
        [self addChild:lbRestart];
        
        _wasTwoPlayersMode = twoPlayersMode;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        if ([node.name isEqualToString:@"mainMenu"]) {
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            
            DTTitleScene *titleScene = [DTTitleScene sceneWithSize:self.frame.size];
            SKTransition *transition = [SKTransition fadeWithDuration:0.6f];
            [self.view presentScene:titleScene transition:transition];
        }
        else if ([node.name isEqualToString:@"restart"]) {
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            [self playBackgroundMusic:kDTMusicGamePlay];
            
            DTGamePlayScene *gameScene = [[DTGamePlayScene alloc] initWithSize:self.frame.size twoPlayersMode:_wasTwoPlayersMode];
            SKTransition *transition = [SKTransition fadeWithDuration:1.0f];
            [self.view presentScene:gameScene transition:transition];
        }
    }
}



@end
