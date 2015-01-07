//  Constant.m
//  ShiftCalendar
//  Created by iOSDeveloper2 on 03/10/13.
//  Copyright (c) 2013 Yudiz Pvt. Solution Ltd. All rights reserved.

#import "Constant.h"

NSString* const kInternalError      = @"Some internal error occured";
NSString* const kNoRecord           = @"No record found";
NSString* const kUserCurrentPubKey  = @"CurrentPubKey";
NSString* const kLastCheckInTime    = @"LastCheckInTime";
NSString* const kUserDeviceTokenKey = @"UserDeviceTokenKey";
NSString* const kUserLocationKey    = @"UserCurrentLocationKey";
NSString* const kLoginUseArrayKey    = @"LoginUseArrayKey";

NSString* NSStringFromCurrentDate(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

NSString* NSStringFullname(NSDictionary* aDict)
{
    if(!aDict[@"vFirst"] || ![aDict[@"vLast"] length])
        return aDict[@"vFirst"];
    else
        return [NSString stringWithFormat:@"%@ %@",aDict[@"vFirst"],aDict[@"vLast"]];
}

BOOL validateEmail(NSString *checkString)
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

NSString* NSStringWithoutSpace(NSString* string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

NSString* NSStringFromSelectedDate(NSString *selectedDate)
{
    NSString *dateWithInitialFormat =selectedDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:dateWithInitialFormat];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateWithNewFormat = [dateFormatter stringFromDate:date];
    return dateWithNewFormat;
}

NSString* NSImageNameStringFromCurrentDate(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpeg",[formatter stringFromDate:[NSDate date]]];
    return imageName;
}

NSString* NSStringWithMergeofString(NSString* first,NSString* last)
{
    return [NSString stringWithFormat:@"%@ %@",first,last];
}

extern  NSString* NSStringFromRemoveNull(NSString* string)
{
    NSString *str=[[string stringByReplacingOccurrencesOfString:@"(null)" withString:@""] stringByReplacingOccurrencesOfString:@"(NULL)" withString:@""];
    NSString *str1=[[str stringByReplacingOccurrencesOfString:@"null" withString:@""] stringByReplacingOccurrencesOfString:@"NULL" withString:@""];
    str1=[str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(str1.length<=0)
        return @"Not Available.";
    else
        return str1;
}

extern  NSString* NSStringRemoveNull(NSString* string)
{
    NSString *str=[[string stringByReplacingOccurrencesOfString:@"(null)" withString:@""] stringByReplacingOccurrencesOfString:@"(NULL)" withString:@""];
    str=[[str stringByReplacingOccurrencesOfString:@"null" withString:@""] stringByReplacingOccurrencesOfString:@"NULL" withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(str.length > 2){
        str=[str stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,2)];
        str=[str stringByReplacingOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,2)];
    }
    
    if(str.length<=0)
        return @"";
    else
        return str;
}

void showAletViewWithMessage(NSString* msg)
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"#Bazinga" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}

UIView* viewWithRoundedCornersSize(float cornerRadius,UIView * original)
{
    
    // Create a white border with defined width
    original.layer.borderColor = [UIColor yellowColor].CGColor;
    original.layer.borderWidth = 1.5;
    // Set image corner radius
    original.layer.cornerRadius =cornerRadius;
    
    // To enable corners to be "clipped"
    [original setClipsToBounds:YES];
    return original;
}

void downloadImageFromUrl(NSString* urlString, UIImageView * imageview)
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        UIImage *img = [UIImage imageWithData:data];
        if(img) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                profileImage=img;
                imageview.image=img;
                
            });
        }
    });
}

void downloadProfileImage(NSString* urlString)
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        UIImage *img = [UIImage imageWithData:data];
        if(img) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                profileImage=img;
            });
        }
    });
}


BOOL isCanSentFriendRequest(NSString* checkString)
{
    if([checkString isEqualToString:@"0"])
        return NO;
    if([checkString isEqualToString:@"1"])
        return NO;
    
    return YES;     
}

UIImage* renderToImage(UIView *viewImage)

{
    
    UIGraphicsBeginImageContext(viewImage.bounds.size);
    
    [viewImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
