//
//  ChannelAction.m
//  Mod
//
//  Created by abner on 12/9/19.
//  Copyright (c) 2012年 abner. All rights reserved.
//

#import "ChannelAction.h"
#import "ChannelCell.h"
#import "ProgramInfo.h"
#import "AppDelegate.h"

@implementation ChannelAction
@synthesize timeLineOffset;
@synthesize timeLineScale;
@synthesize gridView;

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //Avoid the callback function of scrollViewDidEndDecelerating
    NSLog(@"didEndDragging called");
    if (!decelerate) {
        
        //the rebound animation
        int moveMulti = scrollView.contentOffset.x/timeLineScaleInterval;
        if( (scrollView.contentOffset.x - moveMulti*timeLineScaleInterval) < timeLineScaleInterval/2){
            [scrollView setContentOffset:CGPointMake(timeLineScaleInterval*moveMulti, scrollView.contentOffset.y) animated:YES];
        }
        else [scrollView setContentOffset:CGPointMake(timeLineScaleInterval*(moveMulti+1), scrollView.contentOffset.y) animated:YES];
        
//        timeLineOffset = scrollView.contentOffset.x;
        
        //Lock scrollview
//        scrollView.scrollEnabled = NO;
    }

}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    [self reduceMemory:scrollView];
//    lastContentOffset = scrollView.contentOffset.x;
    
    //Notice other scrollview to reduce memory
    NSArray *cells = [gridView visibleCells];
    if (scrollView == timeLineScale) {
        
    }
    else{        
        for(ChannelCell *temp in cells){
          [self reduceMemory:temp.program];
        }
    }
    
    lastContentOffset = scrollView.contentOffset.x;
    timeLineOffset = scrollView.contentOffset.x;
    
}

//Cancel the scrolling Decelerating : scroll the view before decelerating
- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    //the rebound animation
    int moveMulti = scrollView.contentOffset.x/timeLineScaleInterval;
    if( (scrollView.contentOffset.x - moveMulti*timeLineScaleInterval) < timeLineScaleInterval/2){
        [scrollView setContentOffset:CGPointMake(timeLineScaleInterval*moveMulti, scrollView.contentOffset.y) animated:YES];
    }
    else [scrollView setContentOffset:CGPointMake(timeLineScaleInterval*(moveMulti+1), scrollView.contentOffset.y) animated:YES];
    
    timeLineOffset = scrollView.contentOffset.x;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"scrollViewDidEndDecelerating");
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *cells = [gridView visibleCells];
    if (scrollView == timeLineScale) {
        for(ChannelCell *temp in cells){
            temp.program.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
        }
    }
    else{
        
        timeLineScale.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
        
        for(ChannelCell *temp in cells){
            //scroll other scrollView by programming
            if (!(temp.program == scrollView)) {
                temp.program.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
            }
            //check view cross the folder line
            for (ProgramInfo *unitView in temp.program.subviews) {

                CGRect detectFrame = CGRectOffset(unitView.frame, -scrollView.contentOffset.x, -scrollView.contentOffset.y);
                
                CGRect triggerArea = CGRectMake(0, 0, timeLineScaleInterval, 1);
                CGRect rectDiff = CGRectIntersection(triggerArea,detectFrame);

                if (!CGRectIsNull(rectDiff)) {
                    if (rectDiff.size.width == timeLineScaleInterval) {
                        float distance = (unitView.frame.origin.x - scrollView.contentOffset.x);
                        [unitView textMove:-distance];
                    }
                }
                
            }
        
        }

    }
}


- (void) reduceMemory:(UIScrollView *) scrollView{
    if (scrollView.tag != 1986 && (scrollView.contentOffset.x != lastContentOffset)) {
        [self removeUnvisibleCell:scrollView];
        [self addVisibleCell:scrollView];
        
        //Unlock the scrollView
        scrollView.scrollEnabled = YES;
    }
}

- (void) removeUnvisibleCell:(UIScrollView *) scrollView{
    for(ProgramInfo * viewCell in scrollView.subviews){
        CGRect reservedRect = CGRectMake(scrollView.contentOffset.x - [UIScreen mainScreen].bounds.size.height, scrollView.contentOffset.y, [UIScreen mainScreen].bounds.size.height*3, viewCell.bounds.size.height);

        if(!CGRectIntersectsRect(reservedRect, viewCell.frame)){
//            [self enqueueReusableCell:viewCell];
            [viewCell removeFromSuperview];
        }
    }
}

- (void) addVisibleCell:(UIScrollView *) scrollView{
    static BOOL isSlideLeft;
    //slide to left
    if ((scrollView.contentOffset.x - lastContentOffset) >0) {
        isSlideLeft = YES;
    }
    //slide to right
    else{
        isSlideLeft = NO;
    }
    
    //Supplement the view
    //Reuse the view

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray *programData = [[[[appDelegate valueForKey:@"programData"] objectForKey:@"days"] objectAtIndex:0] objectForKey:@"channels"];
    
    ProgramInfo *temp;
    float width;
    
    for (int i = 0; i < INFINITY; i++) {
        NSLog(@"adding view:%d",i);
        
        if (isSlideLeft) {
            int maxTag = [self findMinOrMaxTagInView:NO UIScrollView:scrollView];
            NSArray *programSet = [[programData objectAtIndex:[scrollView superview].tag] objectForKey:@"Programs"];
            
            //Check whether index over the data bound
            if ([programSet count] == (maxTag+1)) {
                break;
            }
            
            NSDictionary *programDetail = [programSet objectAtIndex:maxTag+1];
            width = ([[programDetail objectForKey:@"duration"] floatValue]/30.0) *timeLineScaleInterval;
            temp = [self dequeueReusableCell];
            UIView *lastView = [scrollView viewWithTag:maxTag];
            if(!temp) temp = [[ProgramInfo alloc] initWithFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width, lastView.frame.origin.y, width, lastView.frame.size.height)];
            else temp.frame = CGRectMake(lastView.frame.origin.x + lastView.frame.size.width, lastView.frame.origin.y, width, lastView.frame.size.height);
            //Data we want to appear
            temp.programName = [programDetail objectForKey:@"program_name"];
            temp.tag = maxTag+1;
            
            //Time scale
            if (temp.tag==[programSet count]-1)
                temp.programTimeInterval = [[[programSet objectAtIndex:i] objectForKey:@"start_time"] stringByAppendingFormat:@" - %@",@"00:00"];
            else
                temp.programTimeInterval = [[[programSet objectAtIndex:maxTag+1] objectForKey:@"start_time"] stringByAppendingFormat:@" - %@",[[programSet objectAtIndex:maxTag+2] objectForKey:@"start_time"]];
        }
        else {
            int minTag = [self findMinOrMaxTagInView:YES UIScrollView:scrollView];
            if (minTag !=0) {
                NSArray *programSet = [[programData objectAtIndex:[scrollView superview].tag] objectForKey:@"Programs"];
                NSDictionary *programDetail = [programSet objectAtIndex:minTag-1];
                width = ([[programDetail objectForKey:@"duration"] floatValue]/30.0) *timeLineScaleInterval;
                temp = [self dequeueReusableCell];
                UIView *lastView = [scrollView viewWithTag:minTag];
                if(!temp) temp = [[ProgramInfo alloc] initWithFrame:CGRectMake(lastView.frame.origin.x-width, lastView.frame.origin.y, width, lastView.frame.size.height)];
                else temp.frame = CGRectMake(lastView.frame.origin.x-width, lastView.frame.origin.y, width, lastView.frame.size.height);
                //Data we want to appear
                temp.programName = [programDetail objectForKey:@"program_name"];
                temp.tag = minTag-1;
                
                //Time scale
                if (temp.tag==[programSet count]-1)
                    temp.programTimeInterval = [[[programSet objectAtIndex:i] objectForKey:@"start_time"] stringByAppendingFormat:@" - %@",@"00:00"];
                else
                    temp.programTimeInterval = [[[programSet objectAtIndex:minTag-1] objectForKey:@"start_time"] stringByAppendingFormat:@" - %@",[[programSet objectAtIndex:minTag] objectForKey:@"start_time"]];
                
            }
            else break;
        }
        
        
        //check view in visible area
        CGRect reservedRect = CGRectMake(scrollView.contentOffset.x - [UIScreen mainScreen].bounds.size.height, scrollView.contentOffset.y, [UIScreen mainScreen].bounds.size.height*3, temp.bounds.size.height);
        
        NSLog(@"temp.frame:%f",temp.frame.origin.x);
        if(CGRectIntersectsRect(reservedRect, temp.frame)){
            [scrollView addSubview:temp];
            [temp release];
        }
        else {
            [temp release];
            break;
        }
    }
    
    
 }

- (int) findMinOrMaxTagInView:(BOOL) wantingMin UIScrollView:(UIScrollView *) scrollView{
    int tagValue;
    NSArray *subviews = [scrollView subviews];
    for (int i=0; i< subviews.count; i++) {
        UIView *tempView = [subviews objectAtIndex:i];
        if (i==0) tagValue = tempView.tag;
        if (wantingMin){
            if (tempView.tag < tagValue) tagValue = tempView.tag;
        }
        else{
            if (tempView.tag > tagValue) tagValue = tempView.tag;
        }
    }
    
    return tagValue;
        
}

- (void) enqueueReusableCell:(ProgramInfo *) cell{
    if (!queue) {
        queue = [[NSMutableArray alloc] init];
    }
    
    [queue addObject:[cell retain]];
}

- (ProgramInfo *) dequeueReusableCell{
    ProgramInfo *result = nil;
    if (queue) {
        result = [[[queue lastObject] retain] autorelease];
        if (result) {
            [queue removeLastObject];
        }
    }
    
    return result;
}

- (void) dealloc{
    [super dealloc];
    [queue release];

}


@end
