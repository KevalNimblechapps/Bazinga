//
//  TWHAppDelegate.m
//  Hard
//
//  Created by iPhoneDev1 on 12/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import "TWHAppDelegate.h"
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>

@implementation TWHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    appDelegator =  (TWHAppDelegate*)[UIApplication sharedApplication].delegate;
    
    audioPlayerPage1 = [self createPlayer:@"Page1" repeat:-1];
    audioPlayerPage2 = [self createPlayer:@"Page2" repeat:-1];
    audioPlayerPage3 = [self createPlayer:@"Page3" repeat:-1];
    audioPlayerTimer3 = [self createPlayer:@"Second3" repeat:0];
    audioPlayerTimer5 = [self createPlayer:@"Second5" repeat:0];
    audioPlayerButton = [self createPlayer:@"BruhButton" repeat:0];
    
    //[application ignoreSnapshotOnNextApplicationLaunch];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

-(AVAudioPlayer *)createPlayer:(NSString *)sound repeat:(NSInteger)repeat;
{
    NSString *path = [[NSBundle mainBundle]pathForResource:sound ofType:@".mp3"];
    NSURL *urlTheme = [NSURL fileURLWithPath:path];
    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlTheme error:&error];
    
    if (error)
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    else {
        [player prepareToPlay];
        player.numberOfLoops = repeat;
    }
    
    return player;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    exit(0);
}

- (void)applicationWillResignActive:(UIApplication *)application
{ }

- (void)applicationWillEnterForeground:(UIApplication *)application
{ }

- (void)applicationDidBecomeActive:(UIApplication *)application
{ }

- (void)applicationWillTerminate:(UIApplication *)application
{ }

@end
