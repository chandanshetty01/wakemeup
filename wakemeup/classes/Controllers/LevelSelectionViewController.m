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

@interface LevelSelectionViewController ()

@property(nonatomic,retain)NSMutableArray *levelsArray;
@property (weak, nonatomic) IBOutlet UIButton *tellAFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateUsBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameCenterBtn;
@property (weak, nonatomic) IBOutlet UIButton *soundOnOf;
@property (weak, nonatomic) IBOutlet UIButton *musicOnOff;
@property (weak, nonatomic) IBOutlet UILabel *levelsLabel;

@end

@implementation LevelSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.levelsArray = [NSMutableArray array];
    
    NSString *text = NSLocalizedString(@"Levels", "Select a level to play");
    self.levelsLabel.text = text;
    
    [[GameStateManager sharedManager] loadGameData];
    [self loadLevels];
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
    return cell;
}

- (IBAction)handleTellAFriendAction:(id)sender
{
    
}

- (IBAction)handleRateUsAction:(id)sender
{
    
}

- (IBAction)handleGameCenterAction:(id)sender
{
    
}

- (IBAction)handleSoundChangeAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)handleMusicChangeAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
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
