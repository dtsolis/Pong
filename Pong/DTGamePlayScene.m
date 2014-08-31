//
//  DTGamePlayScene.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTGamePlayScene.h"
#import "SKScene+Extentions.h"
#import "DTBallNode.h"
#import "DTPaddleNode.h"
#import "DTHudNode.h"
#import "DTWallNode.h"
#import "DTCountDownNode.h"
#import "DTGameOverScene.h"
#import "DTButtonNode.h"
#import "DTLabelNode.h"
#import "DSMultilineLabelNode.h"
#import "SKAction+SKTExtras.h"
#import "SKAction+SKTSpecialEffects.h"
#import "SKEmitterNode+SKTExtras.h"

#import "SKNode+SKTExtras.h"
#import "SKTUtils.h"
#import "SKTEffects.h"

@interface DTGamePlayScene ()

@property (nonatomic) BOOL isRightScreenHalfTouched;
@property (nonatomic) BOOL isLeftScreenHalfTouched;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic, strong) DTHudNode *hud;

@end

@implementation DTGamePlayScene {
    SKNode *_baseNode;
    
    
    // values below are used to calculate the degrees of ball directions
    // after that, it's useful to apply to the opposite direction a fire to the ball
    NSTimeInterval _timeSinceBallPosition1Kept;
    CGPoint _ballPosition1;
    CGPoint _ballPosition2;
}


#pragma mark - Initializationss
- (instancetype)initWithSize:(CGSize)size {
    return [self initWithSize:size twoPlayersMode:NO];
}

- (instancetype)initWithSize:(CGSize)size twoPlayersMode:(BOOL)twoPlayersMode
{
    if (self = [super initWithSize:size]) {
        _timeSinceBallPosition1Kept = -1;
        self.backgroundColor = [DTUtils based255ColorWithRed:20.0f green:93.0f blue:36.0f alpha:1.0f];
        [self setupPhysicsBody];
        
        _baseNode = [SKNode node];
        _baseNode.position = self.frame.origin;
        [self addChild:_baseNode];
        
        
        /*
         * Enviroment nodes
         * ============================= */
        SKSpriteNode *tableSeparator = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(2, self.frame.size.height)];
        tableSeparator.position = self.center;
        tableSeparator.name = @"tableSeparator";
        [_baseNode addChild:tableSeparator];
        

        CGSize wallSize = CGSizeMake(5, self.size.height);
        DTWallNode *leftWallNode = [DTWallNode wallNodeAtPosition:CGPointMake(1, self.center.y)
                                                             size:wallSize
                                                         category:DTCollisionCategoryLeftWall];
        [_baseNode addChild:leftWallNode];
        
        DTWallNode *rightWallNode = [DTWallNode wallNodeAtPosition:CGPointMake(self.size.width, self.center.y)
                                                              size:wallSize
                                                          category:DTCollisionCategoryRightWall];
        [_baseNode addChild:rightWallNode];
        
        
        self.hud = [DTHudNode hudAtPosition:CGPointMake(0, 0) inFrame:self.frame];
        self.hud.isMultiplayerEnabled = twoPlayersMode;
        [_baseNode addChild:self.hud];
        
        
        /*
         * "Game Play" nodes
         * ============================= */
        DTPaddleNode *leftPaddle = [DTPaddleNode paddleNodeAtPosition:CGPointMake(DTConstPaddlePaddingOnScreen, self.center.y) category:DTCollisionCategoryLeftPaddle];
        leftPaddle.name = @"leftPaddle";
        [_baseNode addChild:leftPaddle];
        
        DTPaddleNode *rightPaddle = [DTPaddleNode paddleNodeAtPosition:CGPointMake(self.frame.size.width - DTConstPaddlePaddingOnScreen, self.center.y) category:DTCollisionCategoryRightPaddle];
        rightPaddle.name = @"rightPaddle";
        [_baseNode addChild:rightPaddle];
        
        DTButtonNode *btnEnd = [DTButtonNode buttonNodeWithName:@"btnEnd" imageNamed:@"btn_end" atPosition:CGPointMake(self.center.x, self.size.height - 20)];
        btnEnd.zPosition = 10;
        [_baseNode addChild:btnEnd];
        
        [self resetBallPositionWithCompletion:^{
            [self playSoundEffect:kDTSoundEffectsDingDing];
        }];
        
    }
    return self;
}

- (void)setupPhysicsBody {
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    self.physicsWorld.contactDelegate = self;
    
    // Create a physics body that borders the screen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0.0f;
}


#pragma mark - Loop
- (void)update:(NSTimeInterval)currentTime {
    if (_timeSinceBallPosition1Kept == -1)
        _timeSinceBallPosition1Kept = currentTime;
    
    
    if (!self.hud.isMultiplayerEnabled && !self.isGameOver)
        [self centerLeftPaddleWithBall];
    
    /* Called before each frame is rendered */
    DTBallNode *ball = (DTBallNode *) [_baseNode childNodeWithName: kDTBallNodeDefaultName];
    
    if ((currentTime - _timeSinceBallPosition1Kept) >= 0.25f) {
        _ballPosition1 = ball.position;
        _timeSinceBallPosition1Kept = currentTime;
    }
    else {
        _ballPosition2 = ball.position;
        
        float angle = [DTUtils pointPairToBearingRadiansWithStartingPoint:_ballPosition1 endingPoint:_ballPosition2];
        [ball fireOppositeToAngle:angle];
    }
}



#pragma mark - Contact Physics delegate
- (void)didBeginContact:(SKPhysicsContact*)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody  = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody  = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    if (firstBody.categoryBitMask == DTCollisionCategoryBall && (secondBody.categoryBitMask == DTCollisionCategoryLeftWall || secondBody.categoryBitMask == DTCollisionCategoryRightWall)) {
        
        // effects about when the ball hit a wall
        [self shakeScreen];
        [self playSoundEffect:kDTSoundEffectsDamage];
        DTBallNode *ball = (DTBallNode *)[_baseNode childNodeWithName:kDTBallNodeDefaultName];
        [self addExplosionAtPosition:ball.position];
        
    }
    
    if (firstBody.categoryBitMask == DTCollisionCategoryBall && secondBody.categoryBitMask == DTCollisionCategoryRightWall) {
        NSLog(@"Hit the right wall. Point to player 1.");
        [self.hud addToPlayer1APoint];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsFirstScores] && self.hud.player1Points == DTConstMaxScoreToWinSomeone) {
            // game over
            self.isGameOver = YES;
            NSString *title = (self.hud.isMultiplayerEnabled) ? @"Player 1 won!" : @"Game over";
            NSString *msg   = (self.hud.isMultiplayerEnabled) ? @"It was a great game!" : @"No worries! Next time will be better ;)";
            if (!self.hud.isMultiplayerEnabled) {
                [self dropObjectsWithCompletion:^{
                    [self gameOverWithTitle:title message:msg];
                }];
            }
            else {
                [self gameOverWithTitle:title message:msg animated:YES];
            }
        }
        else {
            [self resetBallPositionWithCompletion:nil];
        }
    }
    else if (firstBody.categoryBitMask == DTCollisionCategoryBall && secondBody.categoryBitMask == DTCollisionCategoryLeftWall) {
        NSLog(@"hit the left wall. Point to player 2.");
        [self.hud addToPlayer2APoint];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsFirstScores] && self.hud.player2Points == DTConstMaxScoreToWinSomeone) {
            // game over
            self.isGameOver = YES;
            NSString *title = (self.hud.isMultiplayerEnabled) ? @"Player 2 won!" : @"You won!!";
            NSString *msg   = (self.hud.isMultiplayerEnabled) ? @"It was a great game!" : @"You are awesome!! \nWish i could hi-five you!!";
            [self gameOverWithTitle:title message:msg animated:YES];
        }
        else {
            [self playSoundEffect:kDTSoundEffectsBoom2];
            [self resetBallPositionWithCompletion:nil];
        }
    }
    else if (firstBody.categoryBitMask == DTCollisionCategoryBall &&
             (secondBody.categoryBitMask == DTCollisionCategoryLeftPaddle ||
              secondBody.categoryBitMask == DTCollisionCategoryRightPaddle)) {
                 [self playSoundEffect:kDTSoundEffectsPong];
                 
                 // speed up
                 DTBallNode *ball = (DTBallNode *)[_baseNode childNodeWithName:kDTBallNodeDefaultName];
                 [ball speedUp];
                 [self scaleBarrier:ball];
    }
}




#pragma mark - Touch delegates
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:_baseNode];
        SKNode *node = [_baseNode nodeAtPoint:location];
        
        if (node && [node.name isEqualToString:@"btnEnd"]) {
            [self playSoundEffect:kDTSoundEffectsBubblePop];
            
            DTButtonNode *btn = (DTButtonNode *)node;
            [btn performTapAnimationWithCompletion:^{
                
                self.isGameOver = YES;
                [self dropObjectsWithCompletion:^{
                    NSString *title = @"Game ended!";
                    NSString *msg   = [NSString stringWithFormat:@"Player 1 scored %ld \nPlayer 2 scored %ld", (long)self.hud.player1Points, (long)self.hud.player2Points];
                    [self gameOverWithTitle:title message:msg];
                }];
                
            }];
            
        }
        else {
            if (CGRectContainsPoint(self.rightHalfFrame, location)) {
                self.isRightScreenHalfTouched = YES;
            }
            
            if (CGRectContainsPoint(self.leftHalfFrame, location) && self.hud.isMultiplayerEnabled) {
                self.isLeftScreenHalfTouched = YES;
            }
        }
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {

    for (UITouch *touch in touches) {
        
        if (self.isRightScreenHalfTouched || self.isLeftScreenHalfTouched) {
            CGPoint touchLocation = [touch locationInNode:_baseNode];
            CGPoint previousLocation = [touch previousLocationInNode:_baseNode];
            
            
            if (CGRectContainsPoint(self.rightHalfFrame, touchLocation) && self.isRightScreenHalfTouched) {

                DTPaddleNode *paddle = (DTPaddleNode *)[_baseNode childNodeWithName:@"rightPaddle"];
                // Calculate new position along y for paddle
                int paddleY = paddle.position.y + (touchLocation.y - previousLocation.y);
                [paddle keepInsideFrame:self.frame withDestinationY:paddleY];
            }
            
            if (CGRectContainsPoint(self.leftHalfFrame, touchLocation) && self.isLeftScreenHalfTouched) {
                
                DTPaddleNode *paddle = (DTPaddleNode *)[_baseNode childNodeWithName:@"leftPaddle"];
                // Calculate new position along y for paddle
                int paddleY = paddle.position.y + (touchLocation.y - previousLocation.y);
                [paddle keepInsideFrame:self.frame withDestinationY:paddleY];
            }
        }
        
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:_baseNode];
        
        if (CGRectContainsPoint(self.rightHalfFrame, location)) {
            self.isRightScreenHalfTouched = NO;
        }
        
        if (CGRectContainsPoint(self.leftHalfFrame, location)) {
            self.isLeftScreenHalfTouched = NO;
        }
    }
}



#pragma mark - Helpers
#pragma mark - Effects
- (void)shakeScreen {
    [self playSoundEffect:kDTSoundEffectsBoom2];
    [self runAction:[SKAction skt_screenShakeWithNode:_baseNode amount:CGPointMake(5, 5) oscillations:10 duration:1.0f]];
}

- (void)addExplosionAtPosition:(CGPoint)position {
    SKEmitterNode *explosion = [SKEmitterNode skt_emitterNamed:@"Explosion"];
    explosion.position = position;
    [_baseNode addChild:explosion];
}

- (void)scaleBarrier:(SKNode *)node {
    // Quickly scale the barrier down and up again.
    
    CGPoint currentScale = [node skt_scale];
    CGPoint newScale = CGPointMultiplyScalar(currentScale, 0.5);
    
    SKTScaleEffect *effect = [SKTScaleEffect effectWithNode:node duration:0.5 startScale:newScale endScale:currentScale];
    effect.timingFunction = SKTTimingFunctionElasticEaseOut;
    
    [node runAction:[SKAction actionWithEffect:effect]];
}

#pragma mark Ball reset
- (CGPoint)randomPositionOnYAxisWithX:(CGFloat)x {
    NSInteger randomY = [DTUtils randomWithMin:0 max:self.size.height - 60];
    return CGPointMake(x, randomY);
}

- (void)centerLeftPaddleWithBall {
    DTBallNode *ball = (DTBallNode *)[_baseNode childNodeWithName:@"ball"];
    DTPaddleNode *paddle = (DTPaddleNode *)[_baseNode childNodeWithName:@"leftPaddle"];
    [paddle moveTowardsTheCenterOfNode:ball];
}

- (void)resetBallPositionWithCompletion:(void (^)())block {
    
    DTBallNode *ball = (DTBallNode *)[_baseNode childNodeWithName:kDTBallNodeDefaultName];
    if (ball) {
        [ball removeFromParent];
    }
    
    DTBallNode *newball = [DTBallNode ballNodeAtPosition:[self randomPositionOnYAxisWithX:self.center.x]];
    [_baseNode addChild:newball];
    
    DTCountDownNode *countDownNode = [DTCountDownNode countDownNodeAtPosition:self.center];
    countDownNode.zPosition = 10;
    countDownNode.name = @"countDownNode";
    [_baseNode addChild:countDownNode];
    [countDownNode countDownFromNumber:3 completion:^{
        if (block)
            block();
        [newball kickOff];
    }];
    _ballPosition1 = newball.position;
    _timeSinceBallPosition1Kept = -1;
}


#pragma mark Game Over
- (void)dropObjectsWithCompletion:(void (^)())block {
    DTBallNode *ball = (DTBallNode *)[_baseNode childNodeWithName:kDTBallNodeDefaultName];
    if (ball) {
        [ball freeze];
    }
    SKAction *removeAction = [SKAction sequence:@[[SKAction fadeOutWithDuration:.35f],
                                                  [SKAction removeFromParent]]];
    
    DTPaddleNode *leftPaddle = (DTPaddleNode *)[_baseNode childNodeWithName:@"leftPaddle"];
    leftPaddle.physicsBody.dynamic = YES;
    
    DTPaddleNode *rightPaddle = (DTPaddleNode *)[_baseNode childNodeWithName:@"rightPaddle"];
    rightPaddle.physicsBody.dynamic = YES;
    
    DTButtonNode *btnEnd = (DTButtonNode *)[_baseNode childNodeWithName:@"btnEnd"];
    [btnEnd runAction:removeAction];
    
    DTCountDownNode *countDownNode = (DTCountDownNode *)[_baseNode childNodeWithName:@"countDownNode"];
    if (countDownNode) {
        [countDownNode stop];
    }
    
    SKSpriteNode *tableSeparator = (SKSpriteNode *) [_baseNode childNodeWithName:@"tableSeparator"];
    [tableSeparator runAction:removeAction];
    
    [self.hud runAction:removeAction];
    
    
    self.physicsBody = nil;
    [self runAction:[SKAction waitForDuration:0.2f] completion:^{
        self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
        
        [self runAction:[SKAction waitForDuration:1.0f] completion:^{
            
            if (block)
                block();
        }];
    }];
}

- (void)gameOverWithTitle:(NSString *)title message:(NSString *)message {
    [self playBackgroundMusic:kDTMusicMainTheme];
    
    DTGameOverScene *gameOver = [[DTGameOverScene alloc] initWithSize:self.frame.size title:title message:message twoPlayersMode:self.hud.isMultiplayerEnabled];
    [self.view presentScene:gameOver];
}

- (void)gameOverWithTitle:(NSString *)title message:(NSString *)message animated:(BOOL)animated {
    if (!animated) {
        [self gameOverWithTitle:title message:message];
        return;
    }
    
    [self dropObjectsWithCompletion:nil];
    [self playSoundEffect:kDTSoundEffectsApplause];
    [_baseNode runAction:[SKAction waitForDuration:2.0f] completion:^{
        [self gameOverWithTitle:title message:message];
    }];
    
    
    NSString *gameOverText = (self.hud.isMultiplayerEnabled) ? @"Well played both players!" : @"Awesome performance!";
    DTLabelNode *lbMessage = [DTLabelNode labelNodeWithText:gameOverText style:DTLabelNodeStyleBig atPosition:self.center];
    lbMessage.fontColor = [SKColor yellowColor];
    [lbMessage setVisible:NO animated:NO];
    [self addChild:lbMessage];
    [lbMessage setVisible:YES animated:YES];
}



@end
