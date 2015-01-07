//
//  TWHGameOverViewController.m
//  Hard
//
//  Created by iPhoneDev1 on 26/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import "TWHGameOverViewController.h"
#import "ScoreTableViewCell.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "TWHAppDelegate.h"

#define keyScore @"score"
#define shareText(s) [NSString stringWithFormat:@"I just pressed the  #Bazinga %ld times in 15 seconds. Can you beat my score? \n https://itunes.apple.com/app/id908989995 " ,s]

@interface TWHGameOverViewController ()<MFMailComposeViewControllerDelegate>
{
    NSMutableArray *arrScore ;
    CGRect frameScoreView;
    NSInteger highScoreValue;
    MFMailComposeViewController *mailComposer;
    
    UIImage *imgScreenShort;
    
    
    BOOL isLoad;
    BOOL isError;
}


@property (nonatomic) int lives;

@property (nonatomic) int level;
@property (nonatomic) int currentAdditionCounter;
@property (weak, nonatomic) IBOutlet UIView *viewScore;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblHScore;

@end


@implementation TWHGameOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        mailComposer = [[MFMailComposeViewController alloc]init];
    self.scoreValue = [self.score integerValue];
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:keyScore]){
        [[NSUserDefaults standardUserDefaults] setInteger:self.scoreValue  forKey:keyScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    highScoreValue =[[NSUserDefaults standardUserDefaults] integerForKey:keyScore];
    
    if(highScoreValue<self.scoreValue){
        highScoreValue =self.scoreValue;
        [[NSUserDefaults standardUserDefaults] setInteger:self.scoreValue  forKey:keyScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [lbl_Score setText:self.score];
    self.lblHScore.text = [NSString stringWithFormat:@"%ld",(long)highScoreValue];
    frameScoreView =self.viewScore.frame;
    
    [self reportScore];
    
    [self addLoad];
    
    imgScreenShort = renderToImage(self.view);
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
    
    isLoad = YES;
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    
    NSLog(@"Error %@",error.localizedDescription);
    isError = YES;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if(![audioPlayerPage3 play]){
        [audioPlayerPage1 stop];
        [audioPlayerPage2 stop];
        [audioPlayerPage3 play];
    }
    
    
}

-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboard_identifier];
    score.value = highScoreValue;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void) retrieveTopTenScores
{
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.identifier = leaderboard_identifier;
        leaderboardRequest.range = NSMakeRange(1,10);
        
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error)
         {
             if (error != nil) {
                 NSLog(@"Error Handle : %@", error);
             }
             if (scores != nil)
             {
                 arrScore = [[NSMutableArray alloc]init];
                 NSMutableArray *idArray =[[NSMutableArray alloc]init];
                 [scores enumerateObjectsUsingBlock:^(GKScore *obj, NSUInteger idx, BOOL *stop) {
                     
                     NSMutableDictionary *tempDict =[[NSMutableDictionary alloc]init];
                     
                     [tempDict setObject:[NSString stringWithFormat:@"%lld",obj.value] forKey:@"score"] ;
                     [tempDict setObject:obj.playerID forKey:@"playerID"];
                     
                     [arrScore addObject:tempDict];
                     [idArray addObject:obj.playerID];
                 }];
                 
                 [GKPlayer loadPlayersForIdentifiers:idArray withCompletionHandler:^(NSArray *playerArray, NSError *error)
                  {
                      [playerArray enumerateObjectsUsingBlock:^(GKPlayer *obj, NSUInteger idx, BOOL *stop) {
                          NSMutableDictionary *tempDict =arrScore [idx];
                          [tempDict setObject:obj.alias forKey:@"name"];
                          arrScore[idx] = tempDict;
                      }];
                      
                      [self.tblView reloadData];
                      
                      frameScoreView.origin.y=0;
                      [UIView animateWithDuration:0.3 animations:^{
                          self.viewScore.frame=frameScoreView;
                      }];
                      //
                      //                      [arrScore enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
                      //                          NSLog(@"Name : %@", obj[@"name"]);
                      //                          NSLog(@"Score : %@", obj[@"score"]);
                      //                      }];
                  }];
             }
         }];
    }
}

#pragma mark - GKGameCenterControllerDelegate method implementation

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Leaderboard";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrScore count];
}
- (ScoreTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text=arrScore [indexPath.row] [@"name"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ pts",arrScore [indexPath.row] [@"score"]];
    
    return cell;
}

#pragma mark - mail compose delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -Button Action

- (IBAction)onFaceBook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:shareText((long)self.scoreValue)];
        
        [mySLComposerSheet addImage:imgScreenShort];
        
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else
    {
        showAletViewWithMessage(@"Please setup atleast one Facebook account. Go to Settings->Facebook and add a account.");
    }
    
}

- (IBAction)onTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:shareText((long)self.scoreValue)];
        
        [mySLComposerSheet addImage:imgScreenShort];
        
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else
    {
        showAletViewWithMessage(@"Please setup atleast one Twitter account. Go to Settings->Twitter and add a account.");
    }
}

- (IBAction)onMail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"Check out #Bazinga on app store"];
        [mailComposer setMessageBody:shareText((long)self.scoreValue) isHTML:NO];
        NSLog(@"Scroe Str ---- >>>> %@",shareText((long)self.scoreValue));
        NSData *data = UIImagePNGRepresentation(imgScreenShort);
        [mailComposer addAttachmentData:data mimeType:@"image/png" fileName:@"Score"];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        showAletViewWithMessage(@"Please setup atleast one Mail account. Go to Settings->Mail and add a account.");
    }
}

- (IBAction)onReplay:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showGCOptions:(id)sender {
    
    if (gameCenter_enabled) {
        [self retrieveTopTenScores];
    }
    else
    {
        showAletViewWithMessage(@"Game Center not available.");
    }
}
-(void)dealloc
{
    
}
-(IBAction)replayTapped:(id)sender{
    // [audioPlayerTheme stop];
    
    if (isLoad)
        [self.interstitial presentFromRootViewController:self];
    else if(isError)
        [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)homeTapped:(id)sender{
    //  [audioPlayerTheme stop];
    
    // [self.navigationController popToRootViewControllerAnimated:YES];
    //    UINavigationController *navCtrl = (id)self.presentingViewController;
    //    [navCtrl popToRootViewControllerAnimated:NO];
    //    [self dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction)linkTapped:(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nimblechapps.com"]];
}

- (IBAction)onBack:(id)sender {
    frameScoreView.origin.y=580;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewScore.frame=frameScoreView;
    }];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // [audioPlayerTheme stop];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
