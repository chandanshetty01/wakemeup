//
//  WUNFlipsideViewController.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import <UIKit/UIKit.h>

@class WUNFlipsideViewController;

@protocol WUNFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(WUNFlipsideViewController *)controller;
@end

@interface WUNFlipsideViewController : UIViewController

@property (weak, nonatomic) id <WUNFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
