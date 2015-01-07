//
//  TWBruhDemoVC.h
//  Hard
//
//  Created by iOSDeveloper4 on 03/09/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> 
#import "GADInterstitialDelegate.h"

@class GADInterstitial;
@class GADRequest;
@class GADBannerView;

@interface TWBruhDemoVC : UIViewController<AVAudioPlayerDelegate,GADInterstitialDelegate>{
    IBOutlet UIButton *btn_Bruh;
    IBOutlet UIButton *btn_StoreLink;
    NSURL *url;
    NSURL *urlTheme;
}

@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;

- (GADRequest *)request;

-(IBAction)bruhTapped:(id)sender;
-(IBAction)linkTapped:(id)sender;
-(IBAction)playTapped:(id)sender;


@end

