//
//  WUNMainViewController.h
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNFlipsideViewController.h"
#import "WUNPuck.h"
#import "WUNGridView.h"
#import "WUNBlock.h"
#import "WUNHole.h"
#import "WUNAppDelegate.h"
#import "Colours.h"

typedef enum WUNGridCellStatus {
    eElementEmpty,
    eElementBlock,
    eElementHole,
    eElementFilled
    }WUNGridCellStatus;

typedef void (^completionBlock)(BOOL finished);

@interface WUNMainViewController : UIViewController <WUNFlipsideViewControllerDelegate, UIPopoverControllerDelegate,WUNPuckDelegate>

@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (weak, nonatomic) IBOutlet UILabel *levelNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UIButton *blocksTestBtn;
@property (weak, nonatomic) IBOutlet UIButton *pucksTestBtn;
@property (weak, nonatomic) IBOutlet UIButton *generateTestBtn;
@property (weak, nonatomic) IBOutlet UISwitch *testModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;
@end
