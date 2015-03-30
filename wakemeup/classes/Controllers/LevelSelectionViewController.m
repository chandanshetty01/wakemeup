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
    
    // Do any additional setup after loading the view.
    [[GameCenterManager sharedManager] authenticateLocalPlayer:self];
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
    [[SoundManager sharedManager] playSound:@"tap" looping:NO];
}

- (IBAction)handleRateUsAction:(id)sender
{
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
