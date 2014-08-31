//
//  DTGenericScene.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 29/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DTGenericScene : SKScene

- (void)playSoundEffect:(NSString *)fileName;

- (void)playBackgroundMusic:(NSString *)fileName;
- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;

- (void)addCopyrightLabel;

@end
