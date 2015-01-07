//
//  TWHAppDelegate.h
//  Hard
//
//  Created by iPhoneDev1 on 12/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TWHAppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
-(AVAudioPlayer *)createPlayer:(NSString *)sound repeat:(NSInteger)repeat;
@end
