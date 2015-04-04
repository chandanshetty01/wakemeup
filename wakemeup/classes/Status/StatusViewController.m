//
//  StatusViewController.m
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 3/4/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation StatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IPAD) {
        self.statusLabel.font = [UIFont boldSystemFontOfSize:40];
    }
    else{
        self.statusLabel.font = [UIFont boldSystemFontOfSize:30];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeController
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:1.0
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 0;
                     }completion:^(BOOL finished) {
                         [self removeFromParentViewController];
                         [self.view removeFromSuperview];
                     }];
}


-(void)show:(CGFloat)duration message:(NSString*)text inController:(UIViewController*)inController
{
    [inController addChildViewController:self];
    [inController.view addSubview:self.view];
    self.view.frame = inController.view.frame;
    self.statusLabel.text = text;

    self.view.alpha = 0;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:1.0
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 1;
                     }completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self removeController];
                         });
                     }];
}

- (void)dealloc
{
    NSLog(@"");
}

@end
