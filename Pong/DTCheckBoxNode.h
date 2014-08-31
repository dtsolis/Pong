//
//  DTCheckBoxNode.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^DTCheckBoxValueChangedBlock)(BOOL newValue);


@interface DTCheckBoxNode : SKSpriteNode

@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, copy) DTCheckBoxValueChangedBlock valueChangedBlock;

+ (instancetype)checkBoxNodeAtPosition:(CGPoint)position;

@end
