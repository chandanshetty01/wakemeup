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
#import "GameOverViewController.h"
#import "iAdViewController.h"
#import "GameCenterManager.h"
#import "MKStoreManager.h"

@interface GameViewController() <iAdViewControllerDelegates>

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

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *removeAds;
@property (weak, nonatomic) IBOutlet UIButton *noAdsButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;

@property(nonatomic,strong)GameOverViewController *gameOverController;
@property(nonatomic,strong)iAdViewController *adViewController;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file
{
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
    self.levelNumberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LevelNO", "Level %d"),(long)self.levelModel.levelID];
    [self beginGame];
    [self updateScore];
    
    [self showAdsViewController];
    [self updateTutorial];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.scene = [GameScene unarchiveFromFile:@"GameScene"];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.size = self.view.bounds.size;
    // Present the scene.
    [skView presentScene:self.scene];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", "Back") forState:UIControlStateNormal];
    [self.noAdsButton setTitle:NSLocalizedString(@"NoAds", "No Ads") forState:UIControlStateNormal];
    [self.restartButton setTitle:NSLocalizedString(@"Restart", "Restart") forState:UIControlStateNormal];

    [self loadLevel];
    
    // Let's start the game!
    [self.scene addTiles];
    [self handleGameCompletion];
    [self updateUIBlock];
    [self handleTestMode];
}

-(void)updateTutorial
{
    if(self.levelModel.levelID <= 6){
        NSString *text = [NSString stringWithFormat:@"Tutorial_%ld",(long)self.levelModel.levelID];
        self.tutorialLabel.text = NSLocalizedString(text, nil);
        self.tutorialLabel.hidden = NO;
    }
    else{
        self.tutorialLabel.hidden = YES;
    }
}

-(void)showAdsViewController
{
    BOOL canShowAds = NO;
    if(self.levelModel.levelID > 6 && ![MKStoreManager isFeaturePurchased:REMOVEADS_PRODUCTID]){
        canShowAds = YES;
    }
    
    if(canShowAds){
        if(!self.adViewController){
            CGFloat adHeight = 50;
            if (IS_IPAD){
                adHeight = 66;
            }
            self.adViewController = [[iAdViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:self.adViewController.view];
            [self addChildViewController:self.adViewController];
            self.adViewController.delegate = self;
            CGRect frame = self.adViewController.view.frame;
            frame.size = CGSizeMake(self.view.frame.size.width, adHeight);
            frame.origin.x = (CGRectGetWidth(self.view.bounds)-CGRectGetWidth(frame))/2.0;
            frame.origin.y = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(frame);
            self.adViewController.view.frame = frame;
        }
    }
}

-(void)removeAdViewController
{
    if(self.adViewController){
        [self.adViewController.view removeFromSuperview];
        [self.adViewController removeFromParentViewController];
        self.adViewController = nil;
    }
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
    NSString *fileName = [NSString stringWithFormat:@"Saved_Level_%lu_%lu",(unsigned long)self.levelModel.levelID,(unsigned long)self.currentStage];
    
    // Attach an image to the email
    NSData *myData = [Utility JSONdataForFileName:fileName];
    
    NSString *attachmentMime = @"text/json";
    NSString *attachmentName = [NSString stringWithFormat:@"Saved_Level_%lu_%lu.json",(unsigned long)self.levelModel.levelID,(unsigned long)self.currentStage];
    
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
    if(dictionary){
        [[GameStateManager sharedManager] saveTilesForLevel:dictionary andLevelID:self.levelModel.levelID];
        NSDictionary *levelData = [self.levelModel levelData];
        [[GameStateManager sharedManager] setData:levelData level:self.levelModel.levelID];
        [[GameStateManager sharedManager] saveGameData];
    }
    else{
        assert(@"trying to save empty tiles");
    }
}

- (IBAction)handleTestSave:(id)sender
{
    [self saveLevelData];
}

-(void)addNewObstacle:(NSInteger)obstacleType
{
    NSDictionary *testData = [WUNObstacle testObjectData];
    WUNObstacle *obstacle = [self.level createObstacle:testData];
    [self.scene addSpriteForObstacle:obstacle];
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
    //[self addNewObstacle:0];;
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

#pragma mark - game over -

-(void)removeGameOverScreen
{
    [UIView animateWithDuration:0.4f
                     animations:^{
                         self.gameOverController.view.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [self.gameOverController removeFromParentViewController];
                         [self.gameOverController.view removeFromSuperview];
                         self.gameOverController = nil;
                     }];
}

-(void)showGameOverScreen
{
    NSInteger score = [[GameStateManager sharedManager] getTotalMovements];
    if(score > 20){
        [[GameCenterManager sharedManager] reportScore:score identifier:LEADERBOARD_ID];
    }
    
    NSString *nibName = @"GameOverViewController~iPhone";
    if (IS_IPAD){
      nibName = @"GameOverViewController~iPad";
    }
    self.gameOverController = [[GameOverViewController alloc] initWithNibName:nibName bundle:nil];
    [self.view addSubview:self.gameOverController.view];
    [self.view bringSubviewToFront:self.gameOverController.view];
    self.gameOverController.view.frame = self.view.frame;
    [self addChildViewController:self.gameOverController];
    self.gameOverController.bestScore = score;
    self.gameOverController.delegate = self;
    
    self.gameOverController.view.alpha = 0;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         self.gameOverController.view.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)gameOverDidDismissWithBackButton
{
    [self removeGameOverScreen];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)gameOverDidDismissWithPlayAgain
{
    [self removeGameOverScreen];
    [self loadLevel:1];
}

-(void)updateScore
{
    self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score", "Total Moves: %d"),self.scene.level.levelModel.noOfMoves];
}

-(void)updateUIBlock
{
    [self updateScore];
    id block = ^(void){
        [self updateScore];
    };
    self.scene.updateUI = block;
}

-(void)saveOldLevel:(EGAMESTATUS)status
{
    if(status == eGameWon){
        self.levelModel.isCompleted = YES;
    }
    
    if(status == eGameOver){
    }
    
    if(status == eGameWon || status == eGameOver){
        if(self.levelModel.noOfMoves < self.levelModel.bestNoOfMoves || self.levelModel.bestNoOfMoves == 0){
            self.levelModel.bestNoOfMoves = self.levelModel.noOfMoves;
        }
        [self resetLevelData];
    }
    
    NSDictionary *levelData = [self.levelModel levelData];
    [[GameStateManager sharedManager] setData:levelData level:self.levelModel.levelID];
    [[GameStateManager sharedManager] saveGameData];
}

-(void)resetLevelData
{
    self.levelModel.noOfMoves = 0;
    NSDictionary *levelData = [[GameConfigManager sharedManager] dictionaryForLevel:self.levelModel.levelID andStage:self.currentStage];
    [[GameStateManager sharedManager] saveTilesForLevel:levelData andLevelID:self.levelModel.levelID];
}

-(void)loadLevel:(NSInteger)levelNo
{
    self.currentLevel = levelNo;
    [[GameStateManager sharedManager] setCurrentLevel:levelNo];
    NSDictionary *levelData = [[GameStateManager sharedManager] getLevelData:levelNo];
    self.levelModel = [[WUNLevelModel alloc] initWithDictionary:levelData];
    self.levelModel.isUnlocked = YES;
    [self performSelector:@selector(loadLevel) withObject:nil afterDelay:1];
}

-(void)handleGameCompletion
{
    id block = ^(EGAMESTATUS status) {
        self.scene.level = nil;
        self.level = nil;
        [self saveOldLevel:status];
        if(status == eGameWon){
            //Game Won
            self.currentLevel = self.levelModel.levelID+1;
            NSInteger totalLevels = [[GameStateManager sharedManager] getAllLevelsInStage].count;
            if(self.currentLevel > totalLevels){
                [self performSelector:@selector(showGameOverScreen) withObject:nil afterDelay:0.1f];
            }
            else{
                [self loadLevel:self.currentLevel];
            }
        }
        else if(status == eGameOver){
            //Game lost
            self.levelModel.noOfMoves = 0;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleNoAdsBtnAction:(id)sender
{
    [self purchaseALert];
}

- (IBAction)handleRestartBtnAction:(id)sender
{
    self.scene.level = nil;
    self.level = nil;
    [self resetLevelData];
    self.levelModel.noOfMoves = 0;
    self.levelModel.isUnlocked = YES;
    [self performSelector:@selector(loadLevel) withObject:nil afterDelay:0.2];
}

-(void)purchaseALert
{
    NSString *money = @"0.99$";
    
    SKProduct *product = [Utility productWithID:REMOVEADS_PRODUCTID];
    if(product){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        money = [numberFormatter stringFromNumber:product.price];
    }
    
    NSString *title = NSLocalizedString(@"RemoveAds", "Remove Ads");
    NSString *desc = NSLocalizedString(@"RemoveAdsDesc", "Enjoy the distraction free experience by removing 'Ads' for %@");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[NSString stringWithFormat:desc,money]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"BUY", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"RESTORE", nil)];
    alert.tag = 1;
    [alert show];
}

-(void)provideInAppContent
{
    if([MKStoreManager isFeaturePurchased:REMOVEADS_PRODUCTID]){
        [self removeAdViewController];
    }
}

-(void)showAlertForError:(NSError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",nil)
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)purchase
{
    [[MKStoreManager sharedManager] buyFeature:REMOVEADS_PRODUCTID
                                    onComplete:^(NSString* purchasedFeature,
                                                 NSData* purchasedReceipt,
                                                 NSArray* availableDownloads)
     {
         [Flurry logEvent:@"InApp purchase"];
         [self provideInAppContent];
     }
                                   onCancelled:^
     {
         [Flurry logEvent:@"InApp cancelled"];
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0){
            [Flurry logEvent:[NSString stringWithFormat:@"InApp-Cancel-Stage%ld",(long)alertView.tag]];
            //Cancel
        }
        else if(buttonIndex == 2){
            [Flurry logEvent:[NSString stringWithFormat:@"InApp-Restore-Stage%ld",(long)alertView.tag]];
            
            //Restore
            [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
                [self provideInAppContent];
            } onError:^(NSError *error) {
                [self showAlertForError:error];
            }];
        }
        else{
            //Buy
            [self purchase];
        }
    }
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

-(void)pauseGame
{
    
}

-(void)resumeGame
{
    
}

#pragma mark - iAd delegates -

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [self pauseGame];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [self resumeGame];
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
