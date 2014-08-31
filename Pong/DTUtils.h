//
//  DTUtils.h
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>


#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )
#define isIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//#define DTConstPaddlePaddingOnScreen ([UIDevice currentDevice].userInterfaceIdiom = UIUserInterfaceIdiomPad) ? 70 : 90
/*
 * Constants
 * ========================= */
/// Total points a player needs to win the game.
static const int     DTConstMaxScoreToWinSomeone = 3;
/// Total number of balls available for the user to select.
static const int     DTConstTotalBallsAvailable = 5;
/// The padding for the paddles to have from right and left of the screen.
static const int     DTConstPaddlePaddingOnScreen = 80;
/// The paddle's speed (for iPhone/iPod).
static const CGFloat DTConstLeftPaddleSpeediPhone = 4.5f;
/// The paddle's speed (for iPad).
static const CGFloat DTConstLeftPaddleSpeediPad = 7.5f;
/// A value to speed up the ball each time it hits a paddle (for iPhone/iPod).
static const CGFloat DTConstBallSpeedUpiPhone = 0.1f;
/// A value to speed up the ball each time it hits a paddle (for iPad).
static const CGFloat DTConstBallSpeedUpiPad = 0.2f;


/// If the value for this constant is NO, the game will never end.
FOUNDATION_EXPORT NSString *const kDTDefaultsFirstScores;
FOUNDATION_EXPORT NSString *const kDTDefaultsMusicEnabled;
FOUNDATION_EXPORT NSString *const kDTDefaultsSfxEnabled;
FOUNDATION_EXPORT NSString *const kDTDefaultsSelectedBall;

FOUNDATION_EXPORT NSString *const kDTSoundEffectsPong;
FOUNDATION_EXPORT NSString *const kDTSoundEffectsBubblePop;
FOUNDATION_EXPORT NSString *const kDTSoundEffectsDingDing;
FOUNDATION_EXPORT NSString *const kDTSoundEffectsBoom2;
FOUNDATION_EXPORT NSString *const kDTSoundEffectsApplause;
FOUNDATION_EXPORT NSString *const kDTSoundEffectsThrow;
FOUNDATION_EXPORT NSString *const kDTSoundEffectsDamage;

FOUNDATION_EXPORT NSString *const kDTMusicMainTheme;
FOUNDATION_EXPORT NSString *const kDTMusicGamePlay;
FOUNDATION_EXPORT NSString *const kDTMusicGameOver;



/*
 * Options
 * ========================= */
typedef NS_OPTIONS(uint32_t, DTCollisionCategory) {
    DTCollisionCategoryBall        = 1 << 0,     // 0000 0000
    DTCollisionCategoryRightWall   = 1 << 1,     // 0000 0010
    DTCollisionCategoryLeftWall    = 1 << 2,     // 0000 0100
    DTCollisionCategoryRightPaddle = 1 << 3,     // 0000 1000
    DTCollisionCategoryLeftPaddle  = 1 << 4      // 0001 0000
};


@interface DTUtils : NSObject

+ (void)initDefaults;

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;
+ (CGVector)randomBallDirectionVector;

/// Returns a SKColor object with RGB based on values up to 255.0f (not 1.0f)
+ (SKColor *)based255ColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (CGPoint)centerOfRect:(CGRect)rect;

+ (NSInteger)signForNumber:(CGFloat)number;

+ (float)pointPairToBearingRadiansWithStartingPoint:(CGPoint)startingPoint endingPoint:(CGPoint) endingPoint;

@end
