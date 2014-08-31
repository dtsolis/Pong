//
//  DTGamePlayScene.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTGenericScene.h"

@interface DTGamePlayScene : DTGenericScene <SKPhysicsContactDelegate>

- (instancetype)initWithSize:(CGSize)size twoPlayersMode:(BOOL)twoPlayersMode;

@end
