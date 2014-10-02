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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    self.scene = [GameScene unarchiveFromFile:@"GameScene"];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the level.
    self.level = [[WUNLevel alloc] initWithFile:@"Level_1"];
    self.scene.level = self.level;
    
    id block = ^(WUNSwap *swap) {
    };
    self.scene.swipeHandler = block;
    
    // Present the scene.
    [skView presentScene:self.scene];
    
    // Let's start the game!
    [self.scene addTiles];
    [self beginGame];
}

- (void)beginGame {
    [self shuffle];
}

- (void)shuffle {
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
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
