//
//  MoreGamesViewController.m
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 6/4/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import "MoreGamesViewController.h"
#import "UIButton+Additions.h"
#import "SoundManager.h"

@interface MoreGamesViewController ()
@property (weak, nonatomic) IBOutlet UIView *holderView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *appIconButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation MoreGamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.downloadButton.layer.cornerRadius = CGRectGetHeight(self.downloadButton.frame)/2.0;
    [self.downloadButton setTitle:NSLocalizedString(@"FreeDownload", "Free to play") forState:UIControlStateNormal];
    self.appIconButton.layer.cornerRadius = 10;
    self.downloadButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.downloadButton.layer.borderWidth = 1;

    self.contentTextView.text = NSLocalizedString(@"MoreGameDesc", nil);
    self.contentTextView.textColor = [UIColor whiteColor];
    if(IS_IPAD){
        self.contentTextView.font = [UIFont systemFontOfSize:18];
    }
    else{
        self.contentTextView.font = [UIFont systemFontOfSize:10];
    }
}

- (IBAction)backButtonAction:(id)sender
{
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromParentViewController];
                         [self.view removeFromSuperview];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadButtonAction:(id)sender
{
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"898616807"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


@end
