//
//  ViewController.h
//  TDGridViewExample
//
//  Created by jimliao on 2015/2/23.
//  Copyright (c) 2015年 jimliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDGridView.h"

@interface ViewController : UIViewController<TDGridViewDelegate>{

}

@property(retain, nonatomic) IBOutlet TDGridView *tDGridView;


@end

