//
//  ChannelCell.m
//  Mod
//
//  Created by abner on 12/9/19.
//  Copyright (c) 2012年 abner. All rights reserved.
//

#import "ChannelCell.h"
#import "ProgramInfo.h"

@implementation CustomScrollView

//- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event{
//    NSLog(@"touches:%@",touches);
//}
//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touches Began");
//}


@end


@implementation ChannelCell
@synthesize program;
@synthesize channelNumber;
@synthesize channelName=_channelName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, self.frame.size.width, ProgramCellHeigh);
    }
    return self;
}

- (void) resizeCellHeigh:(float) heigh{
    self.frame = CGRectMake(0, 0, self.frame.size.width, heigh);
}

- (void) setScrollSize:(CGSize) scrollSize{
    program.contentSize = scrollSize;
    program.showsHorizontalScrollIndicator = NO;
    program.showsVerticalScrollIndicator = NO;
    program.directionalLockEnabled = YES;
    program.bounces = NO;
//    program.scrollEnabled = NO;
    program.decelerationRate = 0.0;
    program.frame = CGRectMake(channelNameWidth, 0, [UIScreen mainScreen].bounds.size.height-channelNameWidth, ProgramCellHeigh);
    _channelName.frame = CGRectMake(0, 0,channelNameWidth,ProgramCellHeigh/2.0);
    channelNumber.frame = CGRectMake(0, _channelName.frame.size.height, channelNameWidth, ProgramCellHeigh/2.0);


}

- (void) randomViewInChannel:(int) count{
    //clear all view
    for (UIView *temp in program.subviews) {
        [temp removeFromSuperview];
        
    }
    
    float lastPos=0;
    
    for (int i= 0; i<count; i++) {
        float width = rand()%(timeLineScaleInterval+2)+ timeLineScaleInterval;
//        float width = timeLineScaleInterval*2;
        //Delete the cell out of screen
        if (lastPos > self.bounds.size.width + timeLineScaleInterval) {
            break;
        }
        ProgramInfo *temp = [[ProgramInfo alloc] initWithFrame:CGRectMake(lastPos, 0, width, program.contentSize.height)];
        lastPos += width;
        
//        temp.backgroundColor = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:1.0];
        temp.backgroundColor = [UIColor colorWithRed:0.020 green:0.050 blue:0.189 alpha:1.000];
        

    
        temp.programName = [programNameSet objectAtIndex:rand()%[programNameSet count]];
        [program addSubview:temp];

        [temp release];
    }
}

- (void) setViewInChannel:(NSArray *) programInfoSet timeLineOffset:(float) timeLineOffset{
    //clear all view
    for (UIView *temp in program.subviews) {
        [temp removeFromSuperview];
        
    }
    
    float lastPos=0;
    
    for (int i= 0; i<[programInfoSet count]; i++) {
        
        //check whether first program at the 0:00
        if (i==0) {
            lastPos = [self transferMinis:[[programInfoSet objectAtIndex:0] objectForKey:@"start_time"]]/30.0*timeLineScaleInterval;
        }
        
        float width = ([[[programInfoSet objectAtIndex:i] objectForKey:@"duration"] floatValue]/30.0) *timeLineScaleInterval;

        
//        //Delete the cell out of screen
//        if (lastPos > 2*self.bounds.size.width) {
//            break;
//        }

        ProgramInfo *temp = [[ProgramInfo alloc] initWithFrame:CGRectMake(lastPos, 0, width, program.contentSize.height)];
        lastPos += width;
        
        temp.backgroundColor = [UIColor colorWithRed:0.020 green:0.050 blue:0.189 alpha:1.000];
        temp.programName = [[programInfoSet objectAtIndex:i] objectForKey:@"program_name"];
        temp.tag = i;
        
        if (i==[programInfoSet count]-1)
            temp.programTimeInterval = [[[programInfoSet objectAtIndex:i] objectForKey:@"start_time"] stringByAppendingFormat:@" - %@",@"00:00"];
        else
            temp.programTimeInterval = [[[programInfoSet objectAtIndex:i] objectForKey:@"start_time"] stringByAppendingFormat:@" - %@",[[programInfoSet objectAtIndex:i+1] objectForKey:@"start_time"]];
        
        //check whether out of bounds
        CGRect reservedRect = CGRectMake(timeLineOffset - [UIScreen mainScreen].bounds.size.height, 0 , [UIScreen mainScreen].bounds.size.height*3, temp.bounds.size.height);
        
        if(CGRectIntersectsRect(reservedRect, temp.frame)){
            //Check the text over the single timeInteval for reveal
            CGRect detectFrame = CGRectOffset(temp.frame, -timeLineOffset, -0);
            CGRect triggerArea = CGRectMake(0, 0, timeLineScaleInterval, 1);
            CGRect rectDiff = CGRectIntersection(triggerArea,detectFrame);
            
            if (!CGRectIsNull(rectDiff)) {
                if (rectDiff.size.width == timeLineScaleInterval) {
                    float distance = (temp.frame.origin.x - timeLineOffset);
                    [temp textMove:-distance];
                }
            }
            
            [program addSubview:temp];
            [temp release];
        }
        else {
            [temp release];
        }
        
    }
    
    program.contentOffset = CGPointMake(timeLineOffset, 0);

}

- (float) transferMinis:(NSString *) time{
    NSArray *timeSet = [time componentsSeparatedByString:@":"];
    return ([[timeSet objectAtIndex:0] floatValue]*60+[[timeSet objectAtIndex:1] floatValue]);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *) reuseIdentifier{
    return @"Cell";
}

- (void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, ProgramLineColor.CGColor);
    
    //row line
//    CGContextMoveToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    
    //
    CGContextMoveToPoint(context, program.frame.origin.x, 0);
    CGContextAddLineToPoint(context, program.frame.origin.x, rect.size.height);
    
    CGContextStrokePath(context);
}


- (void)dealloc {
    [program release];
    [channelNumber release];
    [_channelName release];
    [super dealloc];
}
@end
