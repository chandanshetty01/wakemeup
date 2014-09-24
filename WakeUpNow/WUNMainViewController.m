//
//  WUNMainViewController.m
//  WakeUpNow
//
//  Created by S P, Chandan Shetty (external - Project) on 2/5/14.
//  Copyright (c) 2014 S P, Chandan Shetty (external - Project). All rights reserved.
//

#import "WUNMainViewController.h"

const int kScreenOffset = 250;

@interface WUNMainViewController ()

@property(nonatomic,assign) BOOL testMode;
@property(nonatomic,assign) NSInteger levelNo;
@property(nonatomic,assign) NSInteger noOfMoves;
@property(nonatomic,strong) WUNGridView *gridView;
@property(nonatomic,strong) NSMutableDictionary *elementPositions;
@property(nonatomic,strong) NSMutableArray *elements;

@end

@implementation WUNMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _testMode = NO;
    [_testModeSwitch setOn:NO];
    
    self.view.backgroundColor = [UIColor blueberryColor];
    
    _elementPositions = [[NSMutableDictionary alloc] init];
    _elements = [[NSMutableArray alloc] init];

    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

     _gridView = [[WUNGridView alloc] initGridWithSize:appDelegate.configuration.gridSize andEachCellSize:appDelegate.configuration.cellSize];
    [self.view addSubview:_gridView];
    _gridView.frame = CGRectMake(self.view.frame.origin.x+(self.view.frame.size.height-_gridView.frame.size.width)/2.0,15+ self.view.frame.origin.y+(self.view.frame.size.width-_gridView.frame.size.height)/2.0, _gridView.frame.size.width, _gridView.frame.size.height);
    
    _levelNo = 1;
    _noOfMoves = 0;
    [self resetElementPositions];
    [self addElementsForLevel:_levelNo];
    
    [self.view bringSubviewToFront:_restartButton];
    [self.view bringSubviewToFront:_blocksTestBtn];
    [self.view bringSubviewToFront:_pucksTestBtn];

    [self updateMoves];
    [self updateTutorial];
    //[self hideLevelCreationItems];
}

-(void)hideLevelCreationItems
{
    _testModeSwitch.hidden = YES;
    _generateTestBtn.hidden = YES;
    _pucksTestBtn.hidden = YES;
    _blocksTestBtn.hidden = YES;
}

-(void)updateLevel : (BOOL)isRestart
{
    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(!isRestart)
        _levelNo++;
    
    if(_levelNo > appDelegate.configuration.noOfLevels)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Dude game is over" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self fadeInTutorial:NO];
        [self removeAllElements:^(BOOL finished) {
            [self resetElementPositions];
            [self addElementsForLevel:_levelNo];
            [self updateTutorial];
        }];
    }
}

-(void)fadeInTutorial:(BOOL)isFadeIn
{
    if(isFadeIn)
    {
        _tutorialLabel.alpha = 0;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _tutorialLabel.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else
    {
        _tutorialLabel.alpha = 1;
        [UIView animateWithDuration:0.75
                         animations:^{
                             _tutorialLabel.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                         }];
        
    }

}

-(void)updateTutorial
{
    [self fadeInTutorial:YES];
    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *tutorial = [appDelegate.configuration tutorialForLevel:_levelNo];
    _tutorialLabel.text = tutorial;
}

-(void)updateMoves
{
    _movesLabel.text = [NSString stringWithFormat:@"Moves: %d",_noOfMoves];
}

-(void)removeAllElements : (completionBlock)block
{
    [_elements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.75
                         animations:^{
                             CGRect frame = obj.frame;
                             frame.origin.x = 0-kScreenOffset;
                             obj.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             if(finished && idx == [_elements count]-1){
                                 [_elements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                                     [obj removeFromSuperview];
                                 }];
                                 [_elements removeAllObjects];
                                 block(finished);
                             }
                         }];
         }];
}

-(void)updateLevelNo : (NSInteger)levelNo
{
    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _levelNoLabel.text = [NSString stringWithFormat:@"%d/%d",levelNo,appDelegate.configuration.noOfLevels];
}

-(void)resetElementPositions
{
    [_gridView.gridPoints enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL *stop) {
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_elementPositions setObject:[NSNumber numberWithInt:eElementEmpty] forKey:obj];
        }];
    }];
}

-(BOOL)isGameover
{
    __block BOOL status = YES;
    [_elements enumerateObjectsUsingBlock:^(WUNPuck *obj, NSUInteger idx, BOOL *stop) {
        if([obj isMemberOfClass:[WUNPuck class]] && (obj.status == ePuckGone || obj.status == ePuckAlive))
        {
            status = NO;
            *stop = YES;
        }
    }];
    return status;
}

-(UIView*)generateElementForString:(NSString*)inString andPosition:(CGPoint)inPosition
{
    Class objClass = NSClassFromString(inString);
    CGPoint position = inPosition;
    
    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIView *object =[[objClass alloc] initWithFrame:CGRectMake(position.x*appDelegate.configuration.cellSize.width, position.y*appDelegate.configuration.cellSize.height, appDelegate.configuration.cellSize.width, appDelegate.configuration.cellSize.height)];
    [_gridView addSubview:object];
    
    if([object isMemberOfClass:[WUNPuck class]])
    {
        WUNPuck *puck = (WUNPuck*)object;
        puck.delegate = self;
    }
    else if([object isMemberOfClass:[WUNHole class]])
    {
        if(_testMode)
        {
            WUNHole *hole = (WUNHole*)object;
            hole.delegate = self;
        }
        
        [_elementPositions setObject:[NSNumber numberWithInt:eElementHole] forKey:NSStringFromCGPoint(CGPointMake(object.frame.origin.x, object.frame.origin.y))];
    }
    else if([object isMemberOfClass:[WUNBlock class]])
    {
        if(_testMode)
        {
            WUNBlock *block = (WUNBlock*)object;
            block.delegate = self;
        }
        
        [_elementPositions setObject:[NSNumber numberWithInt:eElementBlock] forKey:NSStringFromCGPoint(CGPointMake(object.frame.origin.x, object.frame.origin.y))];
    }
    
    [_elements addObject:object];
    
    CGRect originalFrame = object.frame;
    CGRect tFrame = originalFrame;
    tFrame.origin.x = self.view.frame.size.width+kScreenOffset;
    object.frame = tFrame;
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         object.frame = originalFrame;
                     }
                     completion:^(BOOL finished) {
                     }];
    return object;
}


-(void)addElementsForLevel : (NSInteger)inLevelNo
{
    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *elements = [appDelegate.configuration elementsForLevel:inLevelNo];
    [self updateLevelNo:inLevelNo];
    [elements enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [self generateElementForString:[obj objectForKey:@"class"] andPosition:CGPointFromString([obj objectForKey:@"position"])];
    }];
}

-(void)moveToNextLevel
{
    [self updateLevel:NO];
}

-(void)animateObject:(WUNPuck*)inPuck fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    [UIView animateWithDuration:0.5f animations:^{
        inPuck.frame = CGRectMake(toPoint.x, toPoint.y, inPuck.frame.size.width, inPuck.frame.size.height);
    } completion:^(BOOL finished) {
        //In first level only one puck is there
        if([self isGameover] || [_elements count] == 1){
            [self moveToNextLevel];
        }
    }];
}

- (IBAction)restartButtonAction:(id)sender {
    
    [self updateLevel:YES];
}

-(void)handlePuckSwipe:(WUNPuck*)puck andDirection:(UISwipeGestureRecognizerDirection)direction
{
    [_gridView bringSubviewToFront:puck];
    
    _noOfMoves++;
    NSMutableArray *adjacentArray = [_gridView adjacentPointsForPoint:puck.frame.origin andDirection:direction];
    
    if(!_testMode)
    {
        __block CGPoint toPoint = CGPointFromString([adjacentArray lastObject]);
        puck.status = ePuckGone;
        
        [adjacentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            
            WUNGridCellStatus cellStatus = (WUNGridCellStatus)[[_elementPositions objectForKey:obj] integerValue];
            switch (cellStatus) {
                case eElementHole:
                {
                    [_elementPositions setObject:[NSNumber numberWithInt:eElementFilled] forKey:obj];
                    puck.status = ePuckDied;
                    toPoint = CGPointFromString(obj);
                    *stop = YES;
                }
                    break;
                    
                case eElementFilled:
                case eElementEmpty:
                {
                }
                    break;
                    
                case eElementBlock:
                {
                    puck.status = ePuckAlive;
                    *stop = YES;
                    if(idx > 0)
                        toPoint = CGPointFromString(adjacentArray[idx-1]);
                    else
                        toPoint = puck.frame.origin;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self updateMoves];
        [self animateObject:puck fromPoint:puck.frame.origin toPoint:toPoint];
    }
    else
    {
        __block CGPoint toPoint = CGPointFromString([adjacentArray firstObject]);
        
        if([puck isMemberOfClass:[WUNHole class]])
        {
            [_elementPositions setObject:[NSNumber numberWithInt:eElementEmpty] forKey:NSStringFromCGPoint(CGPointMake(puck.frame.origin.x, puck.frame.origin.y))];
            [_elementPositions setObject:[NSNumber numberWithInt:eElementHole] forKey:NSStringFromCGPoint(CGPointMake(toPoint.x, toPoint.y))];
        }
        if([puck isMemberOfClass:[WUNBlock class]])
        {
            [_elementPositions setObject:[NSNumber numberWithInt:eElementEmpty] forKey:NSStringFromCGPoint(CGPointMake(puck.frame.origin.x, puck.frame.origin.y))];
            [_elementPositions setObject:[NSNumber numberWithInt:eElementBlock] forKey:NSStringFromCGPoint(CGPointMake(toPoint.x, toPoint.y))];
        }

        [self animateObject:puck fromPoint:puck.frame.origin toPoint:toPoint];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(WUNFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)handlePucksTestButtonAction:(id)sender
{
    [self generateElementForString:@"WUNPuck" andPosition:CGPointMake(0, 0)];
    [self generateElementForString:@"WUNHole" andPosition:CGPointMake(0, 0)];
}

- (IBAction)handleBlocksTestBtnAction:(id)sender
{
    [self generateElementForString:@"WUNBlock" andPosition:CGPointMake(0, 0)];
}

- (IBAction)generateTestBtnAction:(id)sender
{
    WUNAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *array = [NSMutableArray array];
    
    [_elements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *element = [[NSMutableDictionary alloc] init];
        
        if([obj isMemberOfClass:[WUNHole class]])
        {
            [element setValue:@"WUNHole" forKey:@"class"];
        }
        else if([obj isMemberOfClass:[WUNBlock class]])
        {
            [element setValue:@"WUNBlock" forKey:@"class"];
        }
        else if([obj isMemberOfClass:[WUNPuck class]])
        {
            [element setValue:@"WUNPuck" forKey:@"class"];
        }
        [element setValue:NSStringFromCGPoint(CGPointMake(obj.frame.origin.x/appDelegate.configuration.cellSize.width, obj.frame.origin.y/appDelegate.configuration.cellSize.height)) forKey:@"position"];
        [array addObject:element];
    }];
    
    NSMutableDictionary *elements = [[NSMutableDictionary alloc] init];
    [elements setObject:array forKey:@"elements"];
    [elements writeToFile:@"/Users/c5184149/Desktop/LevelPlist/GeneratedLevelPlist.plist" atomically:NO];
}

- (IBAction)handleSwithBtnAction:(UISwitch*)sender
{
    if([sender isOn])
        _testMode = YES;
    else
        _testMode = NO;

    [_elements enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if([obj isMemberOfClass:[WUNHole class]])
        {
            WUNHole *hole = (WUNHole*)obj;
            if(_testMode)
                hole.delegate = self;
            else
                hole.delegate = nil;
        }
        else if([obj isMemberOfClass:[WUNBlock class]])
        {
            WUNBlock *block = (WUNBlock*)obj;
            if(_testMode)
                block.delegate = self;
            else
                block.delegate = nil;
        }
    }];
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
