//
//  ViewController.m
//  TDGridViewExample
//
//  Created by jimliao on 2015/2/23.
//  Copyright (c) 2015年 jimliao. All rights reserved.
//

#import "ViewController.h"

#define rowNum 12

@interface ViewController ()


@end

@implementation ViewController
@synthesize tDGridView;

NSMutableArray *data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"test");
    
    if (!tDGridView.programData)
        tDGridView.programData = [[NSMutableArray alloc] init];
    
    tDGridView.tDGridDelegate = self;

    
    //Setting Data
    NSArray *programSet = [[NSArray alloc] initWithObjects:
                           [[NSDictionary alloc] initWithObjectsAndKeys:@"Wen",@"program_name",@"00:00",@"start_time",@"120",@"duration", nil],
                           [[NSDictionary alloc] initWithObjectsAndKeys:@"Abner",@"program_name",@"02:00",@"start_time",@"60",@"duration", nil],
                           [[NSDictionary alloc] initWithObjectsAndKeys:@"Jim",@"program_name",@"03:00",@"start_time",@"120",@"duration", nil],
                           nil];
    for (int i=0; i<rowNum; i++) {
        [tDGridView.programData addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"channel_id",[NSString stringWithFormat:@"%d",i],@"channel_name",programSet,@"Programs", nil]];
    }
    
    NSLog(@"_td:%@",[tDGridView.programData objectAtIndex:2]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
