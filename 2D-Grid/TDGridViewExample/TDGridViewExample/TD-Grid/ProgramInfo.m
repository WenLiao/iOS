//
//  ProgramInfo.m
//  Mod
//
//  Created by abner on 12/9/20.
//  Copyright (c) 2012年 abner. All rights reserved.
//

#import "ProgramInfo.h"
#import "ChannelContent.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "common.h"


@implementation ProgramInfo
@synthesize colorData;
@synthesize programName=_programName;
@synthesize programTimeInterval= _programTimeInterval;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        UINavigationController *basedNav = (UINavigationController *)appDelegate.window.rootViewController;
//        ViewController *viewController = [basedNav.viewControllers objectAtIndex:0];
        
        //Add touch event
        UITapGestureRecognizer *touchOnView = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(channelContentChange:)];
        [self addGestureRecognizer:touchOnView];
        [touchOnView release];
        
        
        programNameTextView = [[UILabel alloc] init];
        programNameTextView.backgroundColor = [UIColor clearColor];
        programNameTextView.font = [programNameTextView.font fontWithSize:20];
        programNameTextView.textColor = [UIColor whiteColor];
        
        
        programTimeIntervalLabel = [[UILabel alloc] init];
        programTimeIntervalLabel.backgroundColor = [UIColor clearColor];
        programTimeIntervalLabel.font = [programNameTextView.font fontWithSize:18];
        programTimeIntervalLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        self.backgroundColor = [UIColor colorWithRed:0.020 green:0.050 blue:0.189 alpha:1.000];

    }
    return self;
}

- (void) setProgramName:(NSString *)programName{
    if (_programName!=programName) {
        [_programName release];
        
        _programName = [programName retain];
        
        programNameTextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
        
        programNameTextView.text = programName;
        
        [self addSubview:programNameTextView];
    }
}

- (void) setProgramTimeInterval:(NSString *)programTimeInteval{
    if (_programTimeInterval!=programTimeInteval) {
        [_programTimeInterval release];
        
        _programTimeInterval = [programTimeInteval retain];
        
        programTimeIntervalLabel.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
        
        programTimeIntervalLabel.text = programTimeInteval;
        
        [self addSubview:programTimeIntervalLabel];
    }
}

- (void) textMove:(float) distance{
    programNameTextView.frame = CGRectMake(distance, programNameTextView.frame.origin.y, programNameTextView.frame.size.width, programNameTextView.frame.size.height);
    
    programTimeIntervalLabel.frame = CGRectMake(distance, programTimeIntervalLabel.frame.origin.y, programTimeIntervalLabel.frame.size.width, programTimeIntervalLabel.frame.size.height);
}



- (void) channelContentChange:(UITapGestureRecognizer *)gestureRecognizer {
    ChannelCell *channelCell = (ChannelCell *)[self superview].superview.superview;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Click !" message:[NSString stringWithFormat:@"Line Number:%@   %@",channelCell.channelNumber.text,_programName] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) drawRect:(CGRect)rect{
//    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, ProgramLineColor.CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextStrokePath(context);
}

- (void) dealloc{
    [colorData release];
    [_programName release];
    [programNameTextView release];
    [programTimeIntervalLabel release];
    [_programTimeInterval release];
    [super dealloc];
}

@end
