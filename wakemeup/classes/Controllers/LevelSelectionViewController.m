//
//  LevelSelectionViewController.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "LevelSelectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "WUNStageModel.h"
#import "Utility.h"
#import "WUNLevelModel.h"
#import "GameViewController.h"
#import "GameStateManager.h"
#import "GameCenterManager.h"
#import "SoundManager.h"
#import "MailComposerManager.h"
#import "UIButton+Additions.h"

@interface LevelSelectionViewController ()

@property(nonatomic,retain)NSMutableArray *levelsArray;
@property (weak, nonatomic) IBOutlet UIButton *tellAFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateUsBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameCenterBtn;
@property (weak, nonatomic) IBOutlet UIButton *soundOnOf;
@property (weak, nonatomic) IBOutlet UIButton *musicOnOff;
@property (weak, nonatomic) IBOutlet UILabel *levelsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LevelSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isOn = [Utility isSoundEnabled];
    self.soundOnOf.selected = isOn;
    
    isOn = [Utility isMusicEnabled];
    self.musicOnOff.selected = isOn;
    
    [self.tellAFriendBtn setTitle:NSLocalizedString(@"TellAFriend", "Tell A Friend") forState:UIControlStateNormal];
    [self.soundOnOf setTitle:NSLocalizedString(@"Sound", "Sound") forState:UIControlStateNormal];
    [self.musicOnOff setTitle:NSLocalizedString(@"Music", "Music") forState:UIControlStateNormal];
    [self.rateUsBtn setTitle:NSLocalizedString(@"RateApp", "Rate Me") forState:UIControlStateNormal];
    [self.gameCenterBtn setTitle:NSLocalizedString(@"GameCenter", "Game Center") forState:UIControlStateNormal];
    
    [self.tellAFriendBtn bottomAlignText];
    [self.soundOnOf bottomAlignText];
    [self.musicOnOff bottomAlignText];
    [self.rateUsBtn bottomAlignText];
    [self.gameCenterBtn bottomAlignText];

#ifndef DEBUG
    // Do any additional setup after loading the view.
    [[GameCenterManager sharedManager] authenticateLocalPlayer:self];
#endif
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(50, 50);
    if(IS_IPHONE){
        if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
            size = CGSizeMake(40, 40);
        }
        else if(IS_IPHONE_6P){
            size = CGSizeMake(60, 60);
        }
    }
    else{
        size = CGSizeMake(72, 76);
    }
    return size;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.levelsArray = [NSMutableArray array];
    NSString *text = NSLocalizedString(@"Levels", "Select a level to play");
    self.levelsLabel.text = text;
    [[GameStateManager sharedManager] loadGameData];
    [self loadLevels];
    [self.collectionView reloadData];
    
    [self playMusic];
}

-(void)loadLevels
{
    NSMutableArray *levels = [[GameStateManager sharedManager] getAllLevelsInStage];
    [levels enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        WUNLevelModel *level = [[WUNLevelModel alloc] initWithDictionary:obj];
        [self.levelsArray addObject:level];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.levelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)inCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"collectionViewCell";
    CustomCollectionViewCell *cell = [inCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.tag = [indexPath row];
    WUNLevelModel *level = [self.levelsArray objectAtIndex:[indexPath row]];
    cell.label.text = [NSString stringWithFormat:@"%ld",(long)level.levelID];
    
    if(level.isUnlocked){
        cell.label.textColor = [UIColor whiteColor];
    }
    else{
        cell.label.textColor = [UIColor colorWithWhite:1.0 alpha:.4];
    }
    
    return cell;
}

- (IBAction)handleTellAFriendAction:(id)sender
{
    [Flurry logEvent:@"tell_a_friend"];

    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:NSLocalizedString(@"TELL_A_FRIEND_MSG", nil),APP_URL];
    NSString *emailSub = NSLocalizedString(@"TELL_A_FRIEND_TITLE", nil);
    
    [[MailComposerManager sharedManager] displayMailComposerSheet:self
                                                       toRecipients:nil
                                                       ccRecipients:nil
                                                     attachmentData:nil
                                                 attachmentMimeType:nil
                                                 attachmentFileName:nil
                                                          emailBody:emailBody
                                                       emailSubject:emailSub
                                                         completion:^(NSInteger index) {
                                                             if(index == 1){
                                                                 //sent
                                                                 [Flurry logEvent:@"tellafriend_mailsent"];
                                                             }
                                                         }];
}

- (IBAction)handleRateUsAction:(id)sender
{
    [Flurry logEvent:@"rate_us_btn_tap"];
    
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",APPSTORE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
}

- (IBAction)handleGameCenterAction:(id)sender
{
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
    
    if([GameCenterManager sharedManager].gameCenterEnabled){
        [[GameCenterManager sharedManager] showLeaderboard:LEADERBOARD_ID inController:self];
    }
    else{
        [[GameCenterManager sharedManager] authenticateLocalPlayer:self];
    }
}

- (IBAction)handleSoundChangeAction:(UIButton*)sender
{
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
    sender.selected = !sender.selected;
    [Utility setSoundEnabled:sender.selected];
}

- (IBAction)handleMusicChangeAction:(UIButton*)sender
{
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];

    sender.selected = !sender.selected;
    [Utility setMusicEnabled:sender.selected];
    
    if(sender.selected)
        [self playMusic];
    else
        [self stopMusic];
}

-(void)playMusic
{
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
    [[SoundManager sharedManager] playMusic:@"1_whistle_music"];
}

-(void)stopMusic
{
    [[SoundManager sharedManager] stopMusic];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(UIView*)sender
{
    BOOL status = NO; 
    WUNLevelModel *level = [self.levelsArray objectAtIndex:sender.tag];
    if(level.isUnlocked){
        [[SoundManager sharedManager] playSound:@"tap" looping:NO];
        status = YES;
    }
    return status;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIView*)sender
{
    WUNLevelModel *level = [self.levelsArray objectAtIndex:sender.tag];
    GameViewController *nextVC = (GameViewController *)[segue destinationViewController];
    if(level){
        nextVC.levelModel = level;
    }
}

@end
