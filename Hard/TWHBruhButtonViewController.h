//
//  TWHBruhButtonViewController.h
//  Hard
//
//  Created by iPhoneDev1 on 26/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import "GADRequest.h"

@interface TWHBruhButtonViewController : UIViewController<AVAudioPlayerDelegate,GADBannerViewDelegate>{
    
    IBOutlet UIButton *btn_Bruh;
    IBOutlet UIButton *btn_StoreLink;
    NSURL *url;
    NSURL *urlTheme;
}

 


-(IBAction)bruhTapped:(id)sender;
-(IBAction)linkTapped:(id)sender;
-(IBAction)playTapped:(id)sender;
 

@end
