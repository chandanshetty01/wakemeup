//
//  GameOverControllerViewController.m
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 19/3/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import "GameOverViewController.h"

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
    [self.gameCenterBtn setTitle:NSLocalizedString(@"GameCenter", "Game Center") forState:UIControlStateNormal];
    [self.gameCenterBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.gameCenterBtn.tintColor = [UIColor whiteColor];
    
    [self.bestScoreTitleBtn setTitle:NSLocalizedString(@"BestScore", "Best Score") forState:UIControlStateNormal];
    [self.bestScoreTitleBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.bestScoreTitleBtn.tintColor = [UIColor whiteColor];

    [self.shareBtn setTitle:NSLocalizedString(@"Share", "Share") forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.shareBtn.tintColor = BLUE_COLOR;

    [self.playAgainBtn setTitle:NSLocalizedString(@"PlayAgain", "Play Again") forState:UIControlStateNormal];
    [self.playAgainBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.playAgainBtn.tintColor = BLUE_COLOR;

    [self.allLevelsBtn setTitle:NSLocalizedString(@"Back", "Back") forState:UIControlStateNormal];
    [self.allLevelsBtn setBackgroundImage:[image resizableImageWithCapInsets:edgeInset] forState:UIControlStateNormal];
    self.allLevelsBtn.tintColor = BLUE_COLOR;

    self.congratsMsgLabel.text = NSLocalizedString(@"CongratsMsg", "Great! All levels Completed");
    self.bestScore = 0;
}

-(void)setBestScore:(NSInteger)bestScore
{
    _bestScore = bestScore;
    self.bestScoreLabel.text = [NSString stringWithFormat:@"%d",bestScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameCenterbtnAction:(id)sender
{
    
}

- (IBAction)allLevelsBtnAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gameOverDidDismissWithBackButton)]){
        [self.delegate gameOverDidDismissWithBackButton];
    }
}

- (IBAction)shareBtnAction:(id)sender
{
    
}

- (IBAction)playAgainBtnAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gameOverDidDismissWithPlayAgain)]){
        [self.delegate gameOverDidDismissWithPlayAgain];
    }
}

@end
