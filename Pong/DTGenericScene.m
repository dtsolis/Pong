//
//  DTGenericScene.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 29/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTGenericScene.h"
#import "SKTAudio.h"
#import "DTLabelNode.h"


@implementation DTGenericScene

- (void)playSoundEffect:(NSString *)fileName {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsSfxEnabled])
        [self runAction:[SKAction playSoundFileNamed:fileName waitForCompletion:NO]];
}


- (void)playBackgroundMusic:(NSString *)fileName {
    
    /*
     To cover the concept where the user activates background music AFTER game launch,
     but if music is selected to be disabled, it stops immediately
     */
    
    [[SKTAudio sharedInstance] playBackgroundMusic:fileName];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsMusicEnabled])
        [self pauseBackgroundMusic];
}

- (void)pauseBackgroundMusic {
    [[SKTAudio sharedInstance] pauseBackgroundMusic];
}

- (void)resumeBackgroundMusic {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsMusicEnabled])
        [[SKTAudio sharedInstance] resumeBackgroundMusic];
}

- (void)addCopyrightLabel {
    DTLabelNode *copyright = [DTLabelNode labelNodeWithText:@"© DFG-Team"
                                                      style:DTLabelNodeStyleExtraSmall
                                                 atPosition:CGPointMake(45, 10)];
    copyright.name = @"copyright";
    copyright.fontColor    = [DTUtils based255ColorWithRed:85 green:140 blue:97 alpha:1];
    [self addChild:copyright];
}

@end
