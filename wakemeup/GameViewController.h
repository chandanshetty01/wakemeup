//
//  GameViewController.h
//  wakemeup
//

//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "WUNLevelModel.h"

@interface GameViewController : UIViewController
@property (nonatomic,assign) NSUInteger currentLevel;
@property (nonatomic,strong) WUNLevelModel *levelModel;
@end
