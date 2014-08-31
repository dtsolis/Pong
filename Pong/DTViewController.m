//
//  DTViewController.m
//  Pong
//
//  Created by Dimitris-Sotiris Tsolis on 26/8/14.
//  Copyright (c) 2014 DFG-Team. All rights reserved.
//

#import "DTViewController.h"
#import "DTTitleScene.h"
#import "SKTUtils/SKTAudio.h"

@implementation DTViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [DTTitleScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self handleBackgroundMusic];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
}

- (void)appWillEnterBackground
{
    SKView *skView = (SKView *)self.view;
    skView.paused = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:NULL];
}

- (void)didBecomeActive
{
    SKView * skView = (SKView *)self.view;
    skView.paused = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Helpers
- (void)handleBackgroundMusic {
    /*
     To cover the concept where the user activates background music AFTER game launch,
     but if music is selected to be disabled, it stops immediately
     */
    
    [[SKTAudio sharedInstance] playBackgroundMusic:kDTMusicMainTheme];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kDTDefaultsMusicEnabled])
        [[SKTAudio sharedInstance] pauseBackgroundMusic];
}

@end
