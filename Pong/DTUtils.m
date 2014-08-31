//
//  DTUtils.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTUtils.h"


NSString *const kDTDefaultsFirstScores    = @"kDTDefaultsFirstScores";
NSString *const kDTDefaultsMusicEnabled   = @"kDTDefaultsMusicEnabled";
NSString *const kDTDefaultsSfxEnabled     = @"kDTDefaultsSfxEnabled";
NSString *const kDTDefaultsSelectedBall   = @"kDTDefaultsSelectedBall";

NSString *const kDTSoundEffectsPong       = @"Pong.caf";
NSString *const kDTSoundEffectsBubblePop  = @"bubble_pop.caf";
NSString *const kDTSoundEffectsDingDing   = @"dingding.caf";
NSString *const kDTSoundEffectsBoom2      = @"boom2.caf";
NSString *const kDTSoundEffectsApplause   = @"applause.caf";
NSString *const kDTSoundEffectsThrow      = @"throw.caf";
NSString *const kDTSoundEffectsDamage     = @"Damage.caf";

NSString *const kDTMusicMainTheme         = @"sunshine_0.mp3";
NSString *const kDTMusicGamePlay          = @"Gameplay.mp3";
NSString *const kDTMusicGameOver          = @"GameOver.mp3";


@implementation DTUtils

+ (void)initDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:kDTDefaultsFirstScores]) {
        [defaults setBool:YES forKey:kDTDefaultsFirstScores];
        [defaults setBool:YES forKey:kDTDefaultsMusicEnabled];
        [defaults setBool:YES forKey:kDTDefaultsSfxEnabled];
        [defaults setObject:@"ball_1" forKey:kDTDefaultsSelectedBall];
        [defaults synchronize];
    }
    
}

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random() % (max - min) + min;
}

+ (CGVector)randomBallDirectionVector {
    // the ball will always goes from-up-to-down
    // but the direction (right or left) will be random
    
    NSInteger randomDx = [DTUtils randomWithMin:-1 max:1];
    return CGVectorMake((randomDx == 0) ? +1.0f : randomDx, -1.0f);
}

+ (UIColor *)based255ColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [SKColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (CGPoint)centerOfRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

+ (NSInteger)signForNumber:(CGFloat)number {
    if (number < 0)
        return -1;
    else if (number > 0)
        return +1;
    else
        return 0;
}


+ (float)pointPairToBearingRadiansWithStartingPoint:(CGPoint)startingPoint endingPoint:(CGPoint) endingPoint {
    // get origin point to origin by subtracting end from start
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    // get bearing in radians
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    return bearingRadians;
}


@end
