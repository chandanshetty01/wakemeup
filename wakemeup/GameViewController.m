//
//  GameViewController.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "WUNLevel.h"
#import "Utility.h"
#import "MailComposerManager.h"
#import "GameConfigManager.h"
#import "GameStateManager.h"

@interface GameViewController()
@property (strong, nonatomic) WUNLevel *level;
@property (strong, nonatomic) GameScene *scene;
@property (weak, nonatomic) IBOutlet UIButton *testSmily;
@property (weak, nonatomic) IBOutlet UIButton *testObstacle;
@property (weak, nonatomic) IBOutlet UISwitch *testMode;
@property (weak, nonatomic) IBOutlet UIButton *testSave;
@property (weak, nonatomic) IBOutlet UIButton *testMail;
@property (weak, nonatomic) IBOutlet UIButton *testHoleBtn;
@property (weak, nonatomic) IBOutlet UILabel *levelNumberLabel;
@property (nonatomic,assign) BOOL isDevelopmentMode;
@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

-(void)loadLevel
{
    // Load the level.
    self.levelModel.tiles = [[GameStateManager sharedManager] getTilesForLevel:self.levelModel.levelID];
    self.level = [[WUNLevel alloc] initWithModel:self.levelModel];
    self.scene.level = self.level;
    self.levelNumberLabel.text = [NSString stringWithFormat:@"%d",self.levelModel.levelID];
    
    id block = ^(WUNSwap *swap) {
        [self.level performSwap:swap];
    };
    self.scene.swipeHandler = block;
    
    [self beginGame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.scene = [GameScene unarchiveFromFile:@"GameScene"];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.size = self.view.bounds.size;
    // Present the scene.
    [skView presentScene:self.scene];
    
    [self loadLevel];
    
    // Let's start the game!
    [self.scene addTiles];
    [self handleGameCompletion];
    [self handleTestMode];
}

-(void)setIsDevelopmentMode:(BOOL)isDevelopmentMode
{
    _isDevelopmentMode = isDevelopmentMode;
    self.scene.isDevelopmentMode = _isDevelopmentMode;
}

-(void)handleTestMode
{
#ifdef DELVELOPMENT
    self.isDevelopmentMode = YES;
    self.testSmily.hidden = NO;
    self.testObstacle.hidden = NO;
    self.testMode.hidden = NO;
    self.testSave.hidden = NO;
    self.testMail.hidden = NO;
    self.testHoleBtn.hidden = NO;
    [self.testMode setOn:self.isDevelopmentMode];
#else
    self.testSmily.hidden = YES;
    self.testObstacle.hidden = YES;
    self.testMode.hidden = YES;
    self.testSave.hidden = YES;
    self.testMail.hidden = YES;
    self.isDevelopmentMode = NO;
    self.testHoleBtn.hidden = YES;
#endif
}

- (IBAction)handleTestMail:(id)sender
{
    NSString *fileName = [NSString stringWithFormat:@"Level_%lu_%d",(unsigned long)self.levelModel.levelID,self.currentStage];
    
    // Attach an image to the email
    NSData *myData = [Utility JSONdataForFileName:fileName];
    
    NSString *attachmentMime = @"text/json";
    NSString *attachmentName = [NSString stringWithFormat:@"Level_%lu_%d.json",(unsigned long)self.levelModel.levelID,self.currentStage];
    
    // Fill out the email body text
    NSString *emailBody = @"Hi, \n\n Check out new level data! \n\n\nRegards, \nSwipe It Baby!";
    NSString *emailSub = [NSString stringWithFormat:@"Swipe It Baby: Level %ld stage %ld",(long)self.levelModel.levelID,(long)self.currentStage];
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"chandanshetty01@gmail.com"];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"26anil.kushwaha@gmail.com", @"ashishpra.pra@gmail.com", nil];
    [[MailComposerManager sharedManager] displayMailComposerSheet:self
                                                       toRecipients:toRecipients
                                                       ccRecipients:ccRecipients
                                                     attachmentData:myData
                                                 attachmentMimeType:attachmentMime
                                                 attachmentFileName:attachmentName
                                                          emailBody:emailBody
                                                       emailSubject:emailSub
                                                         completion:nil];
}

-(void)saveLevelData
{
    self.levelModel.tiles = [self.scene getTilesDictionary];
    [[GameStateManager sharedManager] saveTilesForLevel:self.levelModel.tiles andLevelID:self.levelModel.levelID];
    NSDictionary *levelData = [self.levelModel levelData];
    [[GameStateManager sharedManager] setData:levelData level:self.levelModel.levelID];
    [[GameStateManager sharedManager] saveGameData];
}

- (IBAction)handleTestSave:(id)sender
{
    [self saveLevelData];
}

- (IBAction)HandleSmilyButton:(id)sender
{
    NSMutableSet *set = [NSMutableSet set];
    NSMutableArray *Object = [self.level createObjectAtColumn:0 row:0 withType:1];
    [set addObject:Object];
    
    [self.scene addSpritesForObjects:set];
}

- (IBAction)handleTestHoleBtn:(id)sender
{
    NSMutableSet *set = [NSMutableSet set];
    NSMutableArray *Object = [self.level createObjectAtColumn:0 row:0 withType:3];
    [set addObject:Object];
    
    [self.scene addSpritesForObjects:set];
}

- (IBAction)handleObstacleButton:(id)sender
{
    NSMutableSet *set = [NSMutableSet set];
    NSMutableArray *Object = [self.level createObjectAtColumn:0 row:0 withType:2];
    [set addObject:Object];
    
    [self.scene addSpritesForObjects:set];
}

- (IBAction)handleTestModeButton:(UISwitch*)sender
{
    self.isDevelopmentMode = [sender isOn];
}

-(void)handleGameCompletion
{
    id block = ^(EGAMESTATUS status) {
        self.scene.level = nil;
        self.level = nil;
        if(status == eGameWon){
            //Game Won
            self.currentLevel = self.levelModel.levelID+1;
            [[GameStateManager sharedManager] setCurrentLevel:self.currentLevel];
            
            NSDictionary *levelData = [[GameStateManager sharedManager] getLevelData:self.currentLevel];
            self.levelModel = [[WUNLevelModel alloc] initWithDictionary:levelData];
            [self performSelector:@selector(loadLevel) withObject:nil afterDelay:1];
        }
        else if(status == eGameOver){
            //Game lost
            [self performSelector:@selector(loadLevel) withObject:nil afterDelay:1];
        }
    };
    self.scene.gameCompletion = block;
}

- (void)beginGame
{
    [self shuffle];
}

- (void)shuffle
{
    NSSet *newObjects = [self.level shuffle];
    [self.scene addSpritesForObjects:newObjects];
}

- (IBAction)handleBackButton:(id)sender
{
    [self saveLevelData];
    
    [self dismissViewControllerAnimated:YES completion:^{
//        self.scene.swipeHandler = nil;
//        self.scene.gameCompletion = nil;
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
