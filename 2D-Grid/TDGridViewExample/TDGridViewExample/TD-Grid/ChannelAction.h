//
//  ChannelAction.h
//  Mod
//
//  Created by abner on 12/9/19.
//  Copyright (c) 2012年 abner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChannelAction : NSObject<UIScrollViewDelegate>{
    NSMutableArray *queue;
    float lastContentOffset;
}

@property (assign, nonatomic) float timeLineOffset;
@property (assign, nonatomic) UIScrollView *timeLineScale;
@property (assign, nonatomic) UITableView *gridView;
@property (assign, nonatomic) NSMutableArray *programData;
@end
