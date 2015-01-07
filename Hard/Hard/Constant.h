//
//  Constant.h
//  ShiftCalendar
//
//  Created by iOSDeveloper2 on 03/10/13.
//  Copyright (c) 2013 Yudiz Pvt. Solution Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CoreLocation/CLLocation.h>
#import "TWHAppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

//#define kSampleAdUnitID @"ca-app-pub-8523325810078218/4945670283"
#define kSampleAdUnitID @"ca-app-pub-1054211624293428/8670147399"
#define kSampleInterAdUnitID @"ca-app-pub-1054211624293428/1146880590"

#define __THEME_COLOR [UIColor colorWithRed:(float)61/255 green:(float)169/255  blue:(float)235/255  alpha:1.0]
#define __THEME_COLOR_DARK [UIColor colorWithRed:(float)24/255 green:(float)26/255  blue:(float)26/255  alpha:1.0]
#define __THEME_COLOR_LIGHT_DARK [UIColor colorWithRed:(float)35/255 green:(float)35/255  blue:(float)31/255  alpha:1.0]
#define __THEME_COLOR_DARK_GRAY [UIColor colorWithRed:(float)75/255 green:(float)84/255  blue:(float)89/255  alpha:1.0]
#define __THEME_COLOR_GREY [UIColor colorWithRed:(float)75/255 green:(float)84/255  blue:(float)89/255  alpha:1.0]

#define setFontLight(X) [UIFont fontWithName:@"Lato-Light" size:X]
#define setFontLightItalicFont(X) [UIFont fontWithName:@"Lato-LightItalic" size:X]
#define setFontBoldText(X) [UIFont fontWithName:@"Lato-Bold" size:X]
#define setFontRegularText(X) [UIFont fontWithName:@"Lato-Regular" size:X]




#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

// Check Device

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPHONE     ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD       ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )
#define IS_IPHONE5    ( !IS_IPAD && IS_WIDESCREEN)

#define _COLOR(R,G,B,ALPHA) [[UIColor alloc]initWithRed:(float)R/255 green:(float)G/255 blue:(float)B/255 alpha:ALPHA]

#define __APP_FONT_THEME(X)       [UIFont fontWithName:@"App-Font-Bold" size:X]
#define __APP_BOLD_FONT(X)  [UIFont fontWithName:@"AvenirNext-DemiBold" size:X]
#define __APP_DEFAULT_FONT  [UIFont fontWithName:@"HelveticaNeue" size:15]

#define UserDefault   [NSUserDefaults standardUserDefaults]
#define DefaultCenter [NSNotificationCenter defaultCenter]

#define __PUB_PLACEHOLDER_IMAGE     [UIImage imageNamed:@"_pub_logo_holder"]
#define __USER_PLACEHOLDER_IMAGE    [UIImage imageNamed:@"_img_dot"]
#define __PLACE_HOLDER [UIImage imageNamed:@"Placeholder"]

#define kAppName @"Social Events"
#define __CURRENT_USER userInformation[@"iUserID"]
#define __DEVICE_TOKEN [UserDefault objectForKey:kUserDeviceTokenKey]
#define NMNotificationProfilePicChange @"ProfilePicChange"

/* global variables */

UIImage *profileImage;
NSDictionary            *userInformation;
TWHAppDelegate           *appDelegator;
CLLocation              *userCurrentLocation;

NSString *fbId;
NSString * userPasword;
NSDictionary *countryCode;

NSString *leaderboard_identifier;
BOOL gameCenter_enabled;

NSMutableArray *friendAcceptanceIds;
NSMutableArray *friendRequestIds;
NSMutableArray *pendingIDFriendArray;
NSMutableArray *friendIDArray;

NSString *latitudeFromProfile;
NSString *longitudeFromProfile;


AVAudioPlayer *audioPlayerPage1;
AVAudioPlayer *audioPlayerPage2;
AVAudioPlayer *audioPlayerPage3;

AVAudioPlayer *audioPlayerTimer3;
AVAudioPlayer *audioPlayerTimer5;

AVAudioPlayer *audioPlayerButton;


// NSDate                  *lastCheckInTime;
/*Profile Setting */
BOOL GPS;
BOOL Private;

/* keys */
//extern NSString* const kUserInformationKey;
extern NSString* const kUserLocationKey;
extern NSString* const kUserCurrentPubKey;
extern NSString* const kUserDeviceTokenKey;
// extern NSString* const kPubUsersInfoKey;
extern NSString* const kLastCheckInTime;
NSString* const kLoginUseArrayKey;

/* errors */
extern NSString* const kInternalError;
extern NSString* const kNoRecord;

/* C functions */
extern NSString* NSStringFromCurrentDate(void);
extern NSString* NSStringFullname(NSDictionary* aDict);
extern NSString* NSStringWithoutSpace(NSString* string);
extern NSString* NSStringFromRemoveNull(NSString* string);
extern NSString* NSStringRemoveNull(NSString* string);
extern NSString* NSStringWithMergeofString(NSString* first,NSString* last);

extern NSString* NSImageNameStringFromCurrentDate(void);
extern NSString* NSMovieNameStringFromCurrentDate(void);

extern NSString* NSStringFromSelectedDate(NSString *selectedDate);
extern NSString* dateType(NSString *startDateStr,NSString *endDateStr);

extern BOOL validateEmail(NSString* checkString);

void getCurrentLocation(NSArray * dataArray,NSDictionary ** obj);

extern void showAletViewWithMessage(NSString* msg);

extern  UIView * viewWithRoundedCornersSize(float cornerRadius,UIView * original);

extern void downloadImageFromUrl(NSString* urlString, UIImageView * imageview);

extern void downloadProfileImage(NSString* urlString);

extern void addAccessToken(NSString* accessToken, NSString* userId);
extern void removeAccessToken(NSString* userId);

extern BOOL isCanSentFriendRequest(NSString* checkString);

extern UIImage* renderToImage(UIView *viewImage);



