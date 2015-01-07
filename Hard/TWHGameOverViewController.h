//
//  TWHGameOverViewController.h
//  Hard
//
//  Created by iPhoneDev1 on 26/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GADInterstitialDelegate.h"

@class GADInterstitial;
@class GADRequest;

@interface TWHGameOverViewController : UIViewController<GKGameCenterControllerDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,GADInterstitialDelegate>{
    
    IBOutlet UIButton *btn_Replay;
    IBOutlet UIButton *btn_Home;
    IBOutlet UIButton *btn_Link;
    IBOutlet UILabel  *lbl_Score;
    
     NSURL *urlTheme;
}

@property(nonatomic,strong)NSString *score;
@property (nonatomic) NSInteger scoreValue;

@property(nonatomic, strong) GADInterstitial *interstitial;

- (GADRequest *)request;


-(IBAction)replayTapped:(id)sender;
-(IBAction)homeTapped:(id)sender;
-(IBAction)linkTapped:(id)sender;

@end
