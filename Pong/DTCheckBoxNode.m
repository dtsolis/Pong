//
//  DTCheckBoxNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 28/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTCheckBoxNode.h"

@implementation DTCheckBoxNode
@synthesize isChecked = _isChecked;

+ (instancetype)checkBoxNodeAtPosition:(CGPoint)position {
    DTCheckBoxNode *checkbox = [self spriteNodeWithImageNamed:@"ckb_unchecked"];
    checkbox.anchorPoint = CGPointMake(0.5, 0.5);
    checkbox.position = position;
    
    return checkbox;
}

- (BOOL)isChecked {
    return _isChecked;
}

- (void)setIsChecked:(BOOL)isChecked {
    if (_isChecked == isChecked)
        return;
    _isChecked = isChecked;
    
    SKTexture *texture = (isChecked) ? [SKTexture textureWithImageNamed:@"ckb_checked"] : [SKTexture textureWithImageNamed:@"ckb_unchecked"];
    self.texture = texture;
    
    
    
    if (self.valueChangedBlock)
        self.valueChangedBlock(isChecked);
}

@end
