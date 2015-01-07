//
//  TWHViewController.h
//  Hard
//
//  Created by iPhoneDev1 on 12/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class GADBannerView;
@interface TWHViewController : UIViewController<AVAudioPlayerDelegate>{
    
    NSURL *url;
    NSURL *urlTheme;
    
    IBOutlet UIImageView *needle;
    NSDate *previousEntry;
    double  frequency;
    NSTimer *timer1,*timer2,*timer3,*timer4;
    IBOutlet UILabel *lbl_Counter, *lbl_ReverseCounter;
    IBOutlet UIButton *btn_Reset,*btn_Bruh;
    int Counter,ReverseCounter;
    BOOL isFreshSession;
    IBOutlet UIButton *disableViewButton;
}

@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;

-(IBAction)hardTapped:(id)sender;
-(IBAction)openWebsite:(id)sender;
-(IBAction)backTapped:(id)sender;

@end
