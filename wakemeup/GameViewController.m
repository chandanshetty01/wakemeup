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

@interface GameViewController()
@property (nonatomic,assign) NSUInteger currentLevel;
@property (strong, nonatomic) WUNLevel *level;
@property (strong, nonatomic) GameScene *scene;
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
    NSString *level = [NSString stringWithFormat:@"Level_%lu",(unsigned long)self.currentLevel];
    self.level = [[WUNLevel alloc] initWithFile:level];
    self.scene.level = self.level;
    
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
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    self.currentLevel = 1;
    
    // Create and configure the scene.
    self.scene = [GameScene unarchiveFromFile:@"GameScene"];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:self.scene];
    
    [self loadLevel];
    
    // Let's start the game!
    [self.scene addTiles];
    [self handleGameCompletion];
}

-(void)loadNextLevel
{
    self.currentLevel++;
    [self loadLevel];
}

-(void)handleGameCompletion
{
    id block = ^(BOOL status) {
        if(status){
            //Game Won
        }
        else{
            //Game lost
            NSLog(@"game over");
            self.scene.level = nil;
            self.level = nil;
            [self performSelector:@selector(loadNextLevel) withObject:nil afterDelay:1];
        }
    };
    self.scene.gameCompletion = block;
}

- (void)beginGame {
    [self shuffle];
}

- (void)shuffle {
    NSSet *newObjects = [self.level shuffle];
    [self.scene addSpritesForObjects:newObjects];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
