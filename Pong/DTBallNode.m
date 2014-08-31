//
//  DTBallNode.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 27/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTBallNode.h"
#import "SKEmitterNode+SKTExtras.h"

NSString *const kDTBallNodeDefaultName = @"ball";

@interface DTBallNode()

//@property (nonatomic) SKEmitterNode *fire;

@end

@implementation DTBallNode {
    NSUInteger ballFireHits;
    NSUInteger nextParticleChangeAtHit;
}

+ (instancetype)ballNodeAtPosition:(CGPoint)position {
    return [self ballNodeAtPosition:position presentationMode:NO];
}

+ (instancetype)ballNodeAtPosition:(CGPoint)position presentationMode:(BOOL)presentationMode {
    NSString *ballName = [[NSUserDefaults standardUserDefaults] objectForKey:kDTDefaultsSelectedBall];
    
    DTBallNode *ballNode = [self spriteNodeWithTexture:[SKTexture textureWithImageNamed:ballName]];
    ballNode.position = position;
    ballNode.name = kDTBallNodeDefaultName;
    ballNode.zPosition = 9;
    
    if (!presentationMode) {
        [ballNode setupPhysicsBody];
        [ballNode fireReset];
    }
    else {
        ballNode.xScale = 1.3f;
        ballNode.yScale = 1.3f;
    }
    
    return ballNode;
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    self.physicsBody.friction = 0.0f;
    self.physicsBody.restitution = 1.0f;
    self.physicsBody.linearDamping = 0.0f;
    self.physicsBody.categoryBitMask = DTCollisionCategoryBall;
    self.physicsBody.contactTestBitMask = DTCollisionCategoryLeftWall | DTCollisionCategoryRightWall | DTCollisionCategoryLeftPaddle | DTCollisionCategoryRightPaddle; // 0010 | 0100 | 1000 | 1 0000 = 0001 1111
    
}


#pragma mark - Movement
- (void)speedUp {
    CGFloat speedUp = (isIPad) ? DTConstBallSpeedUpiPad : DTConstBallSpeedUpiPhone;
    CGVector velocity = self.physicsBody.velocity;
    velocity.dx = (velocity.dx > 0) ? speedUp : -speedUp;
    velocity.dy = (velocity.dy > 0) ? speedUp : -speedUp;
    
    [self.physicsBody applyImpulse:velocity];
    
    // fire Up the ball
    [self fireUp];
}

- (void)kickOff {
    [self.physicsBody applyImpulse:[DTUtils randomBallDirectionVector]];
}

- (void)freeze {
    self.physicsBody.velocity = CGVectorMake(0,0);
}


#pragma mark - Particle effects
- (void)fireOppositeToAngle:(float)angle {
    float angleDegrees = radiansToDegrees(angle);
    float opposite = angleDegrees + 180;
    
    SKEmitterNode *fireNode = (SKEmitterNode *)[self childNodeWithName:@"fireNode"];
    if (fireNode) {
        /* Found that setting the new direction and THEN fire up all particles,
           makes the change of direction looks more natural */
        
        fireNode.numParticlesToEmit = 1;
        fireNode.emissionAngle = degreesToRadians(opposite);
        fireNode.numParticlesToEmit = 0;
    }
}

- (void)fireReset {
    nextParticleChangeAtHit = 2;
    ballFireHits = 0;
    
    SKEmitterNode *fireNode = (SKEmitterNode *)[self childNodeWithName:@"fireNode"];
    if (fireNode) {
        [fireNode removeFromParent];
    }
}

- (void)fireUp {
    ballFireHits += 1;
    [self refreshParticles];
}

- (void)refreshParticles {
    if (nextParticleChangeAtHit == -1 || ballFireHits != nextParticleChangeAtHit)
        return;
    
    SKEmitterNode *fireNode = (SKEmitterNode *)[self childNodeWithName:@"fireNode"];
    if (fireNode) {
        [fireNode removeFromParent];
    }
    
    
    if (ballFireHits < 4) {
        [self addNewFireEmitterWithName:@"SmokeParticle"];
        nextParticleChangeAtHit = 6;
    }
    else if (ballFireHits <= 6) {
        [self addNewFireEmitterWithName:@"SmallFireParticle"];
        nextParticleChangeAtHit = 8;
    }
    else {
        [self addNewFireEmitterWithName:@"FireParticle"];
        nextParticleChangeAtHit = -1; // it means never
    }
}


- (void)addNewFireEmitterWithName:(NSString *)name {
    SKEmitterNode *newFireNode = [SKEmitterNode skt_emitterNamed:name];
    newFireNode.name = @"fireNode";
    newFireNode.zPosition = 1;
    [self addChild:newFireNode];
    
}



@end
