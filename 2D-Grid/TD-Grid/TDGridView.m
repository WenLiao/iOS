//
//  2DGridView.m
//  adjustOpenSource
//
//  Created by jimliao on 2015/2/23.
//  Copyright (c) 2015年 jimliao. All rights reserved.
//

#import "TDGridView.h"
#import "ChannelContent.h"
#import "ProgramInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "common.h"



@interface TDGridView ()

@end

@implementation TDGridView
//@synthesize GridView;
@synthesize channelCell;
@synthesize channelCell_iPad;
@synthesize programData;

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    self.rowHeight = ProgramCellHeigh;


    //Loading Data
    /*
    */
    
}

- (void) produceTimeLine{
    if ([self.tDGridDelegate respondsToSelector:@selector(produceTimeLine)]) {
        [self.tDGridDelegate produceTimeLine];
    }
    else {
    // Do any additional setup after loading the view, typically from a nib.
    self.backgroundColor = [UIColor colorWithRed:0.020 green:0.050 blue:0.189 alpha:1.000];
    channelAction = [[ChannelAction alloc] init];
    channelAction.programData = programData;
    //timeLineView Produce
    timeLineView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, timeLineScaleHeigh)];
    timeLineView.backgroundColor = [UIColor colorWithRed:0.330 green:0.702 blue:1.000 alpha:0.900];
    timeLineView.showsHorizontalScrollIndicator = NO;
    timeLineView.showsVerticalScrollIndicator = NO;
    timeLineView.directionalLockEnabled = YES;
    timeLineView.bounces = NO;
    timeLineView.tag = 1986;
    if (!channelAction) {
        channelAction = [[ChannelAction alloc] init];
    }
    timeLineView.delegate = channelAction;
    
    //Clip time line
    for (int i=0; i<48; i++) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(channelNameWidth+timeLineScaleInterval*i, 0, timeLineScaleInterval, timeLineView.frame.size.height)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [timeLabel.font fontWithSize:timeLineFontSize];
        
        //Determine AM and PM
        if (i >= 24) {
            //calculate the time scale
            (i%2) ? (timeLabel.text = [NSString stringWithFormat:@"PM%d:30",(i/2-12)]) : (timeLabel.text = [NSString stringWithFormat:@"PM%d:00",(i/2-12)]);
            [timeLabel.font fontWithSize:50];
        }
        else{
            (i%2) ? (timeLabel.text = [NSString stringWithFormat:@"AM%d:30",i/2]) : (timeLabel.text = [NSString stringWithFormat:@"AM%d:00",i/2]);
            [timeLabel.font fontWithSize:50];
        }
        
        
        [timeLineView addSubview:timeLabel];
        
        if(i==47){
            timeLineView.contentSize = CGSizeMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, timeLabel.frame.size.height-5);
        }
        
        NSLog(@"%@",timeLabel.text);
        [timeLabel release];
    }
    
    NSLog(@"timeLineOffset:%f",channelAction.timeLineOffset);
    
    timeLineView.contentOffset = CGPointMake(channelAction.timeLineOffset, timeLineView.contentOffset.y);
    
    channelAction.timeLineScale = timeLineView;
    channelAction.gridView = self;
        
    }
}

- (void)viewDidUnload
{
    [self setChannelCell:nil];
    [self setChannelCell_iPad:nil];
    [self setProgramName:nil];
    [self setInfoView:nil];
    // Release any retained subviews of the main view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [programData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!timeLineView) {
        [self produceTimeLine];
    }
    static NSString *identifier = @"Cell";
    ChannelCell *cell = (ChannelCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        [[NSBundle mainBundle] loadNibNamed:@"ChannelCell" owner:self options:nil];
        ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? (cell = channelCell) : (cell = channelCell_iPad);
        [cell resizeCellHeigh:ProgramCellHeigh];
    }
    
    //if portrait resize the cell
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
        cell.program.frame = CGRectMake(cell.program.frame.origin.x, cell.program.frame.origin.y, [UIScreen mainScreen].bounds.size.width - cell.channelNumber.frame.size.width, cell.program.frame.size.height);
    }
    else  cell.program.frame = CGRectMake(cell.program.frame.origin.x, cell.program.frame.origin.y, [UIScreen mainScreen].bounds.size.height - cell.channelNumber.frame.size.width, cell.program.frame.size.height);
    
    cell.channelNumber.text = [[programData objectAtIndex:[indexPath row]] objectForKey:@"channel_id"];
    //    cell.channelNumber.textColor = [UIColor whiteColor];
    cell.channelName.text = [[programData objectAtIndex:[indexPath row]] objectForKey:@"channel_name"];
    cell.contentView.tag = [indexPath row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.program.delegate = channelAction;
    [cell setScrollSize:CGSizeMake(timeLineView.contentSize.width, cell.frame.size.height-1)];
    //    [cell randomViewInChannel:35];
    [cell setViewInChannel:[[programData objectAtIndex:[indexPath row]] objectForKey:@"Programs"] timeLineOffset:channelAction.timeLineOffset];
//    NSLog(@"%d",[indexPath row]);
    
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return timeLineScaleHeigh;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return timeLineView;
}

- (void) channelContentChange:(UITapGestureRecognizer *)gestureRecognizer {
    
    //Add infoProgramView and add animation if need
    ProgramInfo *view = (ProgramInfo *) gestureRecognizer.view;
    _programName.text = view.programName;
    CGRect infoRevealRect = CGRectMake(686, 52, _infoView.frame.size.width, _infoView.frame.size.height);
    
    if (!CGRectEqualToRect(_infoView.frame, infoRevealRect)) {
        [UIView beginAnimations:@"Hide" context:nil];
        [UIView setAnimationDuration:0.5];
        _infoView.transform = CGAffineTransformMakeTranslation(-_infoView.frame.size.width, 0);
        [UIView commitAnimations];
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Click !" message:view.programName delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    //Resize Table Cell
    NSArray *visibleCells = [self indexPathsForVisibleRows];
    [self reloadRowsAtIndexPaths:visibleCells withRowAnimation:NO];
}

- (IBAction) removeInfoView:(id)sender{
    
    [UIView beginAnimations:@"Hide" context:nil];
    [UIView setAnimationDuration:0.5];
    _infoView.transform = CGAffineTransformMakeTranslation(_infoView.frame.size.width, 0);
    [UIView commitAnimations];
}

- (void)dealloc {
    [channelAction release];
    [channelCell release];
    [channelCell_iPad release];
    [_programName release];
    [_infoView release];
    [super dealloc];
}
@end