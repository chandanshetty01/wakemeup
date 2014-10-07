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

@interface LevelSelectionViewController ()
@property(nonatomic,retain)NSMutableArray *levelsArray;
@end

@implementation LevelSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.levelsArray = [NSMutableArray array];
    [self loadLevels];
}

-(void)loadLevels
{
    NSDictionary *dictionary = [Utility loadJSON:@"stage_1"];
    NSString *levelCount = dictionary[@"levelsCount"];
    NSInteger noOfLevels = levelCount.intValue;
    for(int i = 1; i <= noOfLevels ; i++){
        WUNLevelModel *level = [[WUNLevelModel alloc] init];
        level.levelID = i;
        [self.levelsArray addObject:level];
    }
}

- (void)didReceiveMemoryWarning {
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
