//
//  ChannelCell.h
//  Mod
//
//  Created by abner on 12/9/19.
//  Copyright (c) 2012年 abner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomScrollView;

@interface ChannelCell : UITableViewCell
@property (retain, nonatomic) IBOutlet CustomScrollView *program;
@property (retain, nonatomic) IBOutlet UILabel *channelNumber;
@property (retain, nonatomic) IBOutlet UILabel *channelName;

- (void) setScrollSize:(CGSize) scrollSize;
- (void) randomViewInChannel:(int) count;
- (void) resizeCellHeigh:(float) heigh;
- (void) setViewInChannel:(NSArray *) programInfoSet timeLineOffset:(float) timeLineOffset;

@end


@interface CustomScrollView:UIScrollView
@end

