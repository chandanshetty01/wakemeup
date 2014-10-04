//
//  GameScene.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "GameScene.h"
#import "WUNGameConfigManager.h"

static const CGFloat TileWidth = 60.0f;
static const CGFloat TileHeight = 60.0f;

@interface GameScene ()
@property (strong, nonatomic) SKNode *gameLayer;
@property (strong, nonatomic) SKNode *smileysLayer;
@property (strong, nonatomic) SKNode *tilesLayer;
@property (assign, nonatomic) NSInteger swipeFromColumn;
@property (assign, nonatomic) NSInteger swipeFromRow;
@property (strong, nonatomic) SKSpriteNode *selectionSprite;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    [self addChild:background];
    
    self.gameLayer = [SKNode node];
    [self addChild:self.gameLayer];
    
    CGPoint layerPosition = CGPointMake(-TileWidth*NumColumns/2, -TileHeight*NumRows/2);
    
    self.tilesLayer = [SKNode node];
    self.tilesLayer.position = layerPosition;
    [self.gameLayer addChild:self.tilesLayer];
    
    self.smileysLayer = [SKNode node];
    self.smileysLayer.position = layerPosition;
    [self.gameLayer addChild:self.smileysLayer];
    
    self.swipeFromColumn = self.swipeFromRow = NSNotFound;
    self.selectionSprite = [SKSpriteNode node];
}

- (void)addTiles
{
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if ([self.level tileAtColumn:column row:row] != nil) {
                SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                tileNode.size = CGSizeMake(TileWidth, TileHeight);
                tileNode.position = [self pointForColumn:column row:row];
                [self.tilesLayer addChild:tileNode];
            }
        }
    }
}

- (void)addSpritesForObjects:(NSSet *)Objects {
    for (WUNObject *Object in Objects) {
        NSString *spriteName = [Object spriteName];
        SKSpriteNode *sprite = nil;
        if(spriteName.length != 0){
             sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
        }
        else{
            sprite = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeZero];
        }
        sprite.size = CGSizeMake(TileWidth, TileHeight);
        sprite.position = [self pointForColumn:Object.column row:Object.row];
        [self.smileysLayer addChild:sprite];
        Object.sprite = sprite;
    }
}

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}

- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row {
    NSParameterAssert(column);
    NSParameterAssert(row);
    
    // Is this a valid location within the Objects layer? If yes,
    // calculate the corresponding row and column numbers.
    if (point.x >= 0 && point.x < NumColumns*TileWidth &&
        point.y >= 0 && point.y < NumRows*TileHeight) {
        
        *column = point.x / TileWidth;
        *row = point.y / TileHeight;
        return YES;
        
    } else {
        *column = NSNotFound;  // invalid location
        *row = NSNotFound;
        return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.smileysLayer];
    
    NSInteger column, row;
    if ([self convertPoint:location toColumn:&column row:&row]) {
        
        WUNObject *Object = [self.level objectAtColumn:column row:row];
        if (Object != nil) {
            self.swipeFromColumn = column;
            self.swipeFromRow = row;
            
            [self showSelectionIndicatorForObject:Object];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.swipeFromColumn == NSNotFound) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.smileysLayer];
    
    NSInteger column, row;
    if ([self convertPoint:location toColumn:&column row:&row]) {
        
        NSInteger horzDelta = 0, vertDelta = 0;
        if (column < self.swipeFromColumn) {          // swipe left
            horzDelta = -1;
        } else if (column > self.swipeFromColumn) {   // swipe right
            horzDelta = 1;
        } else if (row < self.swipeFromRow) {         // swipe down
            vertDelta = -1;
        } else if (row > self.swipeFromRow) {         // swipe up
            vertDelta = 1;
        }
        
        if (horzDelta != 0 || vertDelta != 0) {
            [self trySwapHorizontal:horzDelta vertical:vertDelta];
            [self hideSelectionIndicator];
            self.swipeFromColumn = NSNotFound;
        }
    }
}

-(NSMutableArray*)adjacentPoints:(NSInteger)horzDelta vertical:(NSInteger)vertDelta
{
    NSMutableArray *array = [NSMutableArray array];
    
    if(horzDelta != 0){
        for(NSInteger i=self.swipeFromColumn ; (i>=0 && i<NumColumns) ; i = i+horzDelta){
            NSString *point = NSStringFromCGPoint(CGPointMake(i, self.swipeFromRow));
            [array addObject:point];
        }
    }

    if(vertDelta !=0){
        for(NSInteger i=self.swipeFromRow ; (i>=0 && i<NumRows) ; i = i+vertDelta){
            NSString *point = NSStringFromCGPoint(CGPointMake(self.swipeFromColumn,i));
            [array addObject:point];
        }
    }

    return array;
}

- (void)trySwapHorizontal:(NSInteger)horzDelta vertical:(NSInteger)vertDelta
{
    NSMutableArray *adjacentPoints = [self adjacentPoints:horzDelta vertical:vertDelta];
    
    NSInteger toColumn = self.swipeFromColumn;
    NSInteger toRow = self.swipeFromRow;
    
    if (toColumn < 0 || toColumn >= NumColumns) return;
    if (toRow < 0 || toRow >= NumRows) return;
    
    WUNObject *currentObject = [self.level objectAtColumn:toColumn row:toRow];
    if (currentObject == nil) return;
    
    __block CGPoint toPoint = CGPointFromString([adjacentPoints lastObject]);
    currentObject.status = eObjectGone;

    [adjacentPoints enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        CGPoint point = CGPointFromString(obj);
        EObjectStatus nextCellStatus = eObjectGone;
        WUNObject *nextObject = [self.level objectAtColumn:point.x row:point.y];
        if(nextObject && [nextObject isKindOfClass:[WUNObject class]]){
            nextCellStatus = nextObject.status;
        }
        switch (nextCellStatus) {
            case eObjectAlive:{
                
            }
                break;
            case eObjectDead:{
                
            }
                break;
            case eObjectGone:{
                
            }
                break;
                
            default:
                break;
        }
    }];
    

    [self moveObjectToPoint:currentObject point:toPoint];
}

-(void)moveObjectToPoint:(WUNObject*)object point:(CGPoint)point
{
    SKAction *action = [SKAction moveTo:[self pointForColumn:point.x row:point.y] duration:1.0f];
    [object.sprite runAction:action];
    
    if (self.swipeHandler != nil) {
        WUNSwap *swap = [[WUNSwap alloc] init];
        swap.ObjectA = object;
        swap.point = point;
        self.swipeHandler(swap);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.selectionSprite.parent != nil && self.swipeFromColumn != NSNotFound) {
        [self hideSelectionIndicator];
    }
    
    self.swipeFromColumn = self.swipeFromRow = NSNotFound;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)showSelectionIndicatorForObject:(WUNObject *)Object {
    
    // If the selection indicator is still visible, then first remove it.
    if (self.selectionSprite.parent != nil) {
        [self.selectionSprite removeFromParent];
    }
    
    SKTexture *texture = [SKTexture textureWithImageNamed:[Object highlightedSpriteName]];
    self.selectionSprite.size = texture.size;
    [self.selectionSprite runAction:[SKAction setTexture:texture]];
    
    [Object.sprite addChild:self.selectionSprite];
    self.selectionSprite.alpha = 1.0;
}

- (void)hideSelectionIndicator {
    [self.selectionSprite runAction:[SKAction sequence:@[
                                                         [SKAction fadeOutWithDuration:0.3],
                                                         [SKAction removeFromParent]]]];
}

@end
