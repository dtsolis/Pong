//
//  SKScene+Extentions.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "SKScene+Extentions.h"

@implementation SKScene (Extentions)

- (CGPoint)center {
    return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
}

- (CGRect)leftHalfFrame {
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width / 2, self.frame.size.height);
}

- (CGRect)rightHalfFrame {
    CGFloat halfWidth = self.frame.size.width / 2;
    return CGRectMake(self.frame.origin.x + halfWidth, self.frame.origin.y, halfWidth, self.frame.size.height);
}

@end
