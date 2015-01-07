//
//  TWHBruhButtonViewController.m
//  Hard
//
//  Created by iPhoneDev1 on 26/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import "TWHBruhButtonViewController.h"

@implementation TWHBruhButtonViewController
#define keyScore @"score"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // Replace this ad unit ID with your own ad unit ID.
//    self.bannerView.adUnitID = @"ca-app-pub-8523325810078218/4945670283";
//    self.bannerView.rootViewController = self;
//    self.bannerView.delegate = self;
//    GADRequest *request = [GADRequest request];
//    request.testDevices = @[@"06aaf1e5008ddb50cc16854d5ae18d78"];
//    [self.bannerView loadRequest:request];
    
    gameCenter_enabled = NO;
    leaderboard_identifier= @"";
    [self authenticateLocalPlayer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [audioPlayerPage1 play];
    [audioPlayerPage2 stop];
    [audioPlayerPage3 stop];
}

-(void)authenticateLocalPlayer{
    // Instantiate a GKLocalPlayer object to use for authenticating a player.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            // If it's needed display the login view controller.
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // If the player is already authenticated then indicate that the Game Center features can be used.
                gameCenter_enabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        leaderboard_identifier = leaderboardIdentifier;
                        [self getLoadLeaderboardPositions];
                    }
                }];
            }
            else{
                showAletViewWithMessage(@"Please go to settings and login into game center.");
                gameCenter_enabled = NO;
            }
        }
        
    };
}
- (void) getLoadLeaderboardPositions
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *nsError) {
        
        if( nsError != nil )
        {
            return ;
        }
        
        for( GKLeaderboard* board in leaderboards )
        {
            // fetch score for minimum amt of data, b/c must call `loadScore..` to get MY score.
            board.playerScope = GKLeaderboardPlayerScopeFriendsOnly ;
            board.timeScope = GKLeaderboardTimeScopeAllTime ;
            
            NSRange range = {.location = 1, .length = 1};
            board.range = range ;
            
            [board loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
                
                if( error != nil )
                {
                    showAletViewWithMessage(@"Oops !!The game center is not connecting, Please check internet connection.");
                }
                
                NSInteger newScore =(NSInteger) board.localPlayerScore.value;
                if(![[NSUserDefaults standardUserDefaults] integerForKey:keyScore]){
                    [[NSUserDefaults standardUserDefaults] setInteger:newScore   forKey:keyScore];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    NSInteger oldScore =[[NSUserDefaults standardUserDefaults] integerForKey:keyScore];
                    if(oldScore > newScore){
                        [self reportScore:oldScore];
                        [[NSUserDefaults standardUserDefaults] setInteger:oldScore   forKey:keyScore];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else
                    {
                        [[NSUserDefaults standardUserDefaults] setInteger:newScore   forKey:keyScore];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                printf( "YOUR SCORE ON BOARD %s WAS %lld\n", [board.title UTF8String], board.localPlayerScore.value ) ;
            }] ;
        }
    }] ;
}

-(void)reportScore:(NSInteger)scoreValue{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboard_identifier];
    score.value = scoreValue;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(IBAction)bruhTapped:(id)sender
{
    [self performSegueWithIdentifier:@"BruhSegue" sender:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //  [audioPlayerTheme stop];
}

-(IBAction)playTapped:(id)sender{
    [audioPlayerButton stop];
    audioPlayerButton =nil;
    audioPlayerButton = [appDelegator createPlayer:@"BruhButton" repeat:0];
    [audioPlayerButton play];
    [self performSegueWithIdentifier:@"PlayGameSegue" sender:nil];
}

-(IBAction)linkTapped:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nimblechapps.com"]];
}


@end
