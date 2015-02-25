//
//  TDGridView.h
//  TDGridViewExample
//
//  Created by jimliao on 2015/2/23.
//  Copyright (c) 2015年 jimliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelAction.h"
#import "ChannelCell.h"


@protocol TDGridViewDelegate<NSObject>

@optional
- (void) produceTimeLine;
@end


@interface TDGridView : UITableView<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
    UIScrollView *timeLineView;
    ChannelAction *channelAction;
}
//@property (retain, nonatomic) IBOutlet TDGridView *GridView;
@property (retain, nonatomic) IBOutlet ChannelCell *channelCell;
@property (retain, nonatomic) IBOutlet ChannelCell *channelCell_iPad;
@property (retain, nonatomic) IBOutlet UILabel *programName;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) NSMutableArray *programData;
@property (assign, nonatomic) id <TDGridViewDelegate> tDGridDelegate;

- (IBAction) removeInfoView :(id)sender;
- (void) produceTimeLine;




@end
