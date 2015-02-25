//
//  ProgramInfo.h
//  Mod
//
//  Created by abner on 12/9/20.
//  Copyright (c) 2012年 abner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDGridView.h"


@protocol ProgramInfoDelegate

@optional
- (void) channelContentChange:(UITapGestureRecognizer *)gestureRecognizer;
@end


@interface ProgramInfo : UIView{
    UILabel *programNameTextView;
    UILabel *programTimeIntervalLabel;
}

@property(retain , readwrite) UIColor *colorData;
@property(retain, readwrite, nonatomic) NSString *programName;
@property(retain, nonatomic) NSString *programTimeInterval;
@property(assign, nonatomic) TDGridView *tDGridView;
@property (assign, nonatomic) id <ProgramInfoDelegate> programInfoDelegate;

- (void) textMove:(float) distance;

@end
