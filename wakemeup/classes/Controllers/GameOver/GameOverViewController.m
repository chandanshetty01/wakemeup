//
//  GameOverControllerViewController.m
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 19/3/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import "GameOverViewController.h"
#import "CustomActivityProvider.h"
#import "GameCenterManager.h"

@interface GameOverViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gameCenterBtn;
@property (weak, nonatomic) IBOutlet UIButton *bestScoreTitleBtn;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratsMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *allLevelsBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *playAgainBtn;
@property (weak, nonatomic) IBOutlet UIImageView *crownImage;

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(15, 30, 15, 30);
    UIImage *image = [[UIImage imageNamed:@"btn_bg"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.gameCenterBtn setTitle:NSLocalizedString(@"GlobalScores", "Global Scores") forState:UIControlStateNormal];
    [self.gameCenterBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.gameCenterBtn.tintColor = [UIColor whiteColor];
    
    [self.bestScoreTitleBtn setTitle:NSLocalizedString(@"BestScore", "Best Score") forState:UIControlStateNormal];
    [self.bestScoreTitleBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.bestScoreTitleBtn.tintColor = [UIColor whiteColor];
    self.bestScoreTitleBtn.userInteractionEnabled = NO;

    [self.shareBtn setTitle:NSLocalizedString(@"Share", "Share") forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.shareBtn.tintColor = BLUE_COLOR;

    [self.playAgainBtn setTitle:NSLocalizedString(@"PlayAgain", "Play Again") forState:UIControlStateNormal];
    [self.playAgainBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.playAgainBtn.tintColor = BLUE_COLOR;

    [self.allLevelsBtn setTitle:NSLocalizedString(@"LevelsKey", "Levels") forState:UIControlStateNormal];
    [self.allLevelsBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.allLevelsBtn.tintColor = BLUE_COLOR;

    self.congratsMsgLabel.text = NSLocalizedString(@"CongratsMsg", "Great! All levels Completed");
    self.bestScore = 0;
    
    [Flurry logEvent:@"all_levels_completed"];
}

-(void)setBestScore:(NSInteger)bestScore
{
    _bestScore = bestScore;
    self.bestScoreLabel.text = [NSString stringWithFormat:@"%ld",(long)bestScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameCenterbtnAction:(id)sender
{
    [Flurry logEvent:@"gameover_gameCenter"];

    if([GameCenterManager sharedManager].gameCenterEnabled){
        [[GameCenterManager sharedManager] showLeaderboard:LEADERBOARD_ID inController:self];
    }
    else{
        [[GameCenterManager sharedManager] authenticateLocalPlayer:self];
    }
}

- (IBAction)allLevelsBtnAction:(id)sender
{
    [Flurry logEvent:@"gameover_allLevels"];

    if(self.delegate && [self.delegate respondsToSelector:@selector(gameOverDidDismissWithBackButton)]){
        [self.delegate gameOverDidDismissWithBackButton];
    }
}

- (IBAction)shareBtnAction:(UIView*)sender
{
    [Flurry logEvent:@"gameOver_share"];

    CustomActivityProvider *activityProvider = [[CustomActivityProvider alloc] init];
    activityProvider.totalMoves = self.bestScore;
    NSArray *items = @[activityProvider];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityView.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                           UIActivityTypeMessage,
                                           UIActivityTypePrint,
                                           UIActivityTypeCopyToPasteboard,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToFlickr,
                                           UIActivityTypePostToVimeo,
                                           UIActivityTypePostToTencentWeibo,
                                           UIActivityTypeAirDrop
                                           ];
    activityView.popoverPresentationController.sourceView = sender;
    activityView.popoverPresentationController.sourceRect = sender.bounds;
    [self presentViewController:activityView animated:YES completion:nil];
    activityView.completionWithItemsHandler = ^(NSString *act, BOOL done, NSArray *returnedItems, NSError *activityError) {
        NSString *ServiceMsg = nil;
        if ( [act isEqualToString:UIActivityTypeMail] ){
            ServiceMsg = NSLocalizedString(@"MailSentMsg", "Mail sent successfully");
        }
        else{
            ServiceMsg = NSLocalizedString(@"postSentMsg", "Successfully posted");
        }
        if ( done && !activityError){
            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [Alert show];
        }
    };
}

- (IBAction)playAgainBtnAction:(id)sender
{
    [Flurry logEvent:@"gameOver_PlayAgain"];

    if(self.delegate && [self.delegate respondsToSelector:@selector(gameOverDidDismissWithPlayAgain)]){
        [self.delegate gameOverDidDismissWithPlayAgain];
    }
}

@end
