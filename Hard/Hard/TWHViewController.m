//
//  TWHViewController.m
//  Hard
//
//  Created by iPhoneDev1 on 12/08/14.
//  Copyright (c) 2014 Yudiz. All rights reserved.
//

#import "TWHViewController.h"
#import "TWHGameOverViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define countdown 15

@interface TWHViewController ()
{
    __weak IBOutlet UIButton *btnGo;
    __weak IBOutlet UILabel *lbl321;
    
    __weak IBOutlet UIView *viewStart;
    int counter321;
}
@end

@implementation TWHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
         
    needle.layer.anchorPoint = CGPointMake(0.5,1);
    [needle setFrame:CGRectMake(140, 138, 40, 155)];
    
    needle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-62));
    //
    //    NSString *path = [[NSBundle mainBundle]pathForResource:@"Bruh_new" ofType:@".mp3"];
    //    url = [NSURL fileURLWithPath:path];
    //     needle.layer.anchorPoint = CGPointMake(0.5,1);
    //    [needle setFrame:CGRectMake(140, 15, 40, 155)];
    //    isFreshSession = YES;
    //    needle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-62));
    
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerView.adUnitID =kSampleAdUnitID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    //request.testDevices = @[ @"06aaf1e5008ddb50cc16854d5ae18d78" ];
    [self.bannerView loadRequest:request];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
    [timer4 invalidate];
    btnGo.selected = NO;
}

-(void)viewWillAppear:(BOOL)animated
{   
    
    [audioPlayerPage1 stop];
    [audioPlayerPage2 stop];
    [audioPlayerPage3 stop];
    
    
    audioPlayerTimer3 = [appDelegator createPlayer:@"Second3" repeat:0];
    audioPlayerTimer5 = [appDelegator createPlayer:@"Second5" repeat:0];
}

- (void)startAnimatingLabel:(UIView *)view
{
    view.alpha = 0;
    
    counter321--;
    
    if(counter321 == 2)
    {
        [audioPlayerTimer3 play];
    }
    
    if(counter321==-1){
        
        [audioPlayerTimer3 stop];
        [audioPlayerPage2 play];
        [self resetViewsAndTimers];
        
        viewStart.hidden=YES;
        
    }else{
        if(counter321==0)
            lbl321.text=[NSString stringWithFormat:@"GO"];
        else
            lbl321.text=[NSString stringWithFormat:@"%d",counter321];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             view.alpha = 1;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:0
                                                 options: UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  view.alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  [self startAnimatingLabel:lbl321];
                                              }];
                             
                         }];
    }
}

-(void)countDowntimer{
    
    [lbl_ReverseCounter setText:[NSString stringWithFormat:@"00:%02d:00",ReverseCounter-1]];
    
    if(ReverseCounter==6)
    {
        [audioPlayerPage1 stop];
        [audioPlayerPage2 stop];
        [audioPlayerPage3 stop];         
        [audioPlayerTimer5 play];
    }
//    else if(ReverseCounter==4)
//    { 
//        [audioPlayerTimer5 stop];
//        [audioPlayerTimer3 play];
//    }
    
    if(ReverseCounter==1){
        //[disableViewButton setUserInteractionEnabled:YES];
        [timer3 invalidate];
        [timer2 invalidate];
        [timer1 invalidate];
        [timer4 invalidate];
        
        [audioPlayerTimer5 stop];
        [audioPlayerButton stop];
        audioPlayerButton =nil;
        audioPlayerButton = [appDelegator createPlayer:@"BruhButton" repeat:0];
        [audioPlayerButton play];
        
        [self performSegueWithIdentifier:@"GameOverSegue" sender:nil];
    }
    
    ReverseCounter--;
}


-(void)timeEquilizer{
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:previousEntry];
    frequency = 1/timeInterval;
    
}

-(void)frequencyCalculator{
    
    if(!previousEntry){
        frequency = 0.0;
        return;
    }
    
    float feq = [self CalculateAngleDelta];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        needle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(feq));
        
    } completion:nil];
    
}



-(IBAction)hardTapped:(id)sender{
    
  [audioPlayerButton stop];
    audioPlayerButton =nil;
    audioPlayerButton = [appDelegator createPlayer:@"BruhButton" repeat:0];
    [audioPlayerButton play];
    
    if(!btnGo.selected)
        return;
    

    if(isFreshSession){
        isFreshSession = NO;
    }
    
    [lbl_Counter setText:[NSString stringWithFormat:@"%2d",++Counter]];
    
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:previousEntry];
    previousEntry = [NSDate date];
    frequency = 1/timeInterval;
    
    
    
    if(ReverseCounter<0){
        //[disableViewButton setUserInteractionEnabled:YES];
        [timer3 invalidate];
        [timer2 invalidate];
        [timer1 invalidate];
        [timer4 invalidate];
    }
    
}

-(float)CalculateAngleDelta
{
    
    float intermediateFrequency = (frequency*125)/25;
    
    if(intermediateFrequency>125)
        intermediateFrequency = 125;
    if(intermediateFrequency<0)
        intermediateFrequency = 0;
    
    if(intermediateFrequency<62)
        return MAX(intermediateFrequency-62, -62) ;
    else
        return MIN(intermediateFrequency-62, 62) ;
}
-(void)resetViewsAndTimers
{
    ReverseCounter = countdown;
    [lbl_ReverseCounter setText:[NSString stringWithFormat:@"00:%02d:00",countdown]];
    [lbl_Counter setText:@"0"];
    timer3 = [NSTimer scheduledTimerWithTimeInterval: 1
                                              target: self
                                            selector: @selector(countDowntimer)
                                            userInfo: nil
                                             repeats: YES];
    
    timer4 = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                              target: self
                                            selector: @selector(miliSecondCountDown)
                                            userInfo: nil
                                             repeats: YES];
    
    [timer4 fire];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(frequencyCalculator) userInfo:nil repeats:YES];
    timer2 =  [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(timeEquilizer) userInfo:nil repeats:YES];
}

- (void)miliSecondCountDown
{
    static int counter = 0;
    int toShow = 99-(counter%100);
    
    if(ReverseCounter!=0)
        [lbl_ReverseCounter setText:[NSString stringWithFormat:@"00:%02d:%02d",ReverseCounter-1,toShow]];
    else
        [lbl_ReverseCounter setText:[NSString stringWithFormat:@"00:%02d:00",ReverseCounter]];
    counter++;
}

-(void)dealloc{     
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
    [timer4 invalidate];
}

-(IBAction)backTapped:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onGo:(id)sender {
    
    btnGo.selected = !btnGo.selected;
    [lbl_ReverseCounter setText:[NSString stringWithFormat:@"00:%02d:00",countdown]];
    needle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-62));
    
    
    isFreshSession = YES;
    [lbl_Counter setText:@"0"];
    ReverseCounter = countdown;
    Counter = 0;
    counter321 = 4;
    [viewStart setHidden:NO];
    [self startAnimatingLabel:lbl321];
}


-(IBAction)openWebsite:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nimblechapps.com"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
  //  [audioPlayerTheme stop];
    if([segue.identifier isEqualToString:@"GameOverSegue"]){
        
        TWHGameOverViewController *gameOver  = segue.destinationViewController;
        gameOver.score = lbl_Counter.text;
    }
    
}
@end
