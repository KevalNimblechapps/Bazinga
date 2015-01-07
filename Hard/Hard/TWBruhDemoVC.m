//
//  TWBruhDemoVC.m
//  Hard
//
//  Created by iOSDeveloper4 on 03/09/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import "TWBruhDemoVC.h"
#import "TWHBruhButtonViewController.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "TWHAppDelegate.h"



@interface TWBruhDemoVC ()

{
    int count;
    __weak IBOutlet UIButton *btnPlay;
}

@end

@implementation TWBruhDemoVC

#define keyScore @"score"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    count = 0;
    gameCenter_enabled = NO;
    
    leaderboard_identifier= @"";
    
    [self authenticateLocalPlayer];
    
    [self addLoad];
    
    self.bannerView.adUnitID =kSampleAdUnitID;
    self.bannerView.rootViewController = self;     
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    
}

- (void)dealloc {
    _interstitial.delegate = nil;
}

-(void)addLoad
{
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    self.interstitial.adUnitID = kSampleInterAdUnitID;
    
    [self.interstitial loadRequest:[self request]];
}

#pragma mark GADInterstitialDelegate implementation

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [self.interstitial presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Error :- %@",error.localizedDescription);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    
}

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ @"06aaf1e5008ddb50cc16854d5ae18d78" ];
    
    return request;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [audioPlayerPage1 stop];
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
    [audioPlayerButton stop];
    audioPlayerButton =nil;
    audioPlayerButton = [appDelegator createPlayer:@"BruhButton" repeat:0];
    [audioPlayerButton play];
    
    count++;
    if(count == 15)
    {
        count = 0;
        [self addLoad];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //  [audioPlayerTheme stop];
}

-(IBAction)backTapped:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)playTapped:(id)sender{
    
    count ++;
    
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
