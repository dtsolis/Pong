//
//  DTGameOverScene.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTGenericScene.h"

@interface DTGameOverScene : DTGenericScene

- (instancetype)initWithSize:(CGSize)size title:(NSString *)title message:(NSString *)message twoPlayersMode:(BOOL)twoPlayersMode;
@end
