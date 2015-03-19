//
//  GameOverControllerViewController.h
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 19/3/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverViewController : UIViewController
{
}
@property(nonatomic,assign)NSInteger bestScore;
@property(nonatomic,weak)id delegate;

@end

@protocol GameOverViewControllerDelegates <NSObject>

-(void)gameOverDidDismissWithBackButton;
-(void)gameOverDidDismissWithPlayAgain;

@end