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
    self.currentStage = 1;
    self.levelModel.tiles = [[GameStateManager sharedManager] getTilesForLevel:self.levelModel.levelID];
    self.level = [[WUNLevel alloc] initWithModel:self.levelModel];
    self.scene.level = self.level;
    self.levelNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.levelModel.levelID];
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
    self.isDevelopmentMode = NO;
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
    NSString *fileName = [NSString stringWithFormat:@"Level_%lu_%lu",(unsigned long)self.levelModel.levelID,(unsigned long)self.currentStage];
    
    // Attach an image to the email
    NSData *myData = [Utility JSONdataForFileName:fileName];
    
    NSString *attachmentMime = @"text/json";
    NSString *attachmentName = [NSString stringWithFormat:@"Level_%lu_%lu.json",(unsigned long)self.levelModel.levelID,(unsigned long)self.currentStage];
    
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
    NSMutableDictionary *dictionary = [self.scene getTilesDictionary];
    [[GameStateManager sharedManager] saveTilesForLevel:dictionary andLevelID:self.levelModel.levelID];
    NSDictionary *levelData = [self.levelModel levelData];
    [[GameStateManager sharedManager] setData:levelData level:self.levelModel.levelID];
    [[GameStateManager sharedManager] saveGameData];
}

- (IBAction)handleTestSave:(id)sender
{
    [self saveLevelData];
}

-(void)addNewObject:(NSInteger)objectType
{
    NSDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"row"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"column"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInt:(int)objectType] forKey:@"objectType"];
    WUNObject *object = [self.level createObject:dictionary];
    [self.scene addSpriteForObject:object];
}

- (IBAction)HandleSmilyButton:(id)sender
{
    [self addNewObject:1];
}

- (IBAction)handleTestHoleBtn:(id)sender
{
    [self addNewObject:3];
}

- (IBAction)handleObstacleButton:(id)sender
{
    [self addNewObject:2];
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
    NSMutableArray *newObjects = [self.level shuffle];
    [self.scene addSpritesForObjects:newObjects];
}

- (IBAction)handleBackButton:(id)sender
{
    [self saveLevelData];
    [self dismissViewControllerAnimated:YES completion:^{
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
