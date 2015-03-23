//
//  GameScene.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "GameScene.h"
#import "GameConfigManager.h"

static const uint32_t smilyCategory            =  0x1 << 0;
static const uint32_t wallCategory             =  0x1 << 1;
static const uint32_t holeCategory             =  0x1 << 2;
static const uint32_t obstacleCategory         =  0x1 << 3;

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
//    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:52/255.0f green:146/255.0f blue:233/255.0f alpha:1.0f] size:view.bounds.size];
//    [self addChild:background];
    
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
    self.isDevelopmentMode = NO;
    
    //To detect collision detection
    self.physicsWorld.contactDelegate = self;
}

#pragma mark - Collision Detection

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    if((firstBody.categoryBitMask & smilyCategory) == smilyCategory && (secondBody.categoryBitMask & obstacleCategory)== obstacleCategory)
    {
        if (self.gameCompletion != nil) {
            self.gameCompletion(eGameOver);
        }
    }
}


- (void)addTiles
{
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if ([self.level tileAtColumn:column row:row] != nil) {
                SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                tileNode.size = CGSizeMake(TileWidth+1, TileHeight+1);
                tileNode.position = [self pointForColumn:column row:row];
                [self.tilesLayer addChild:tileNode];
            }
        }
    }
}


-(void)addSpriteForObstacle:(WUNObstacle*)object
{
    if(!object.sprite){
        SKSpriteNode *sprite = nil;

        NSString *spriteName = [object spriteName];
        if(spriteName.length != 0){
            sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
            sprite.color = [object spriteColor];
        }
        sprite.size = object.size;
        sprite.position = object.position;
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:object.size];
        sprite.physicsBody.categoryBitMask = obstacleCategory;
        sprite.physicsBody.contactTestBitMask = smilyCategory;

        sprite.physicsBody.collisionBitMask = 0;
        sprite.physicsBody.affectedByGravity = NO;
        
        [self.smileysLayer addChild:sprite];
        object.sprite = sprite;
    }
}

-(void)addSpriteForObject:(WUNObject*)object
{
    if(!object.sprite){
        NSString *spriteName = [object spriteName];
        SKSpriteNode *sprite = nil;
        if(spriteName.length != 0){
            sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
        }
        else{
            sprite = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeZero];
        }
        
        sprite.size = CGSizeMake(TileWidth-1, TileHeight-1);
        sprite.position = [self pointForColumn:object.column row:object.row];
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.height/2.0];
        
        if(object.ObjectType == eObjectSmily){
            sprite.physicsBody.categoryBitMask = smilyCategory;
            sprite.physicsBody.contactTestBitMask = wallCategory;
        }
        else if(object.ObjectType == eObjectHole){
            sprite.physicsBody.categoryBitMask = holeCategory;
            sprite.physicsBody.contactTestBitMask = smilyCategory;
        }
        else if(object.ObjectType == eObjectWall){
            sprite.physicsBody.categoryBitMask = wallCategory;
            sprite.physicsBody.contactTestBitMask = smilyCategory;
        }
        
        sprite.physicsBody.collisionBitMask = 0;
        sprite.physicsBody.affectedByGravity = NO;
        
        [self.smileysLayer addChild:sprite];
        object.sprite = sprite;
        object.status = object.status;
    }
}

- (void)addSpritesForObjects:(NSMutableArray *)Objects
{
    [Objects enumerateObjectsUsingBlock:^(WUNObject *object, NSUInteger idx, BOOL *stop) {
        [self addSpriteForObject:object];
    }];
}

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row
{
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}

- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row
{
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.smileysLayer];
    
    NSInteger column, row;
    if ([self convertPoint:location toColumn:&column row:&row]) {
        NSMutableArray *objects = [self.level objectAtColumn:column row:row];
        WUNObject *object = [objects lastObject];
        
        if (object != nil && ((object.ObjectType == eObjectSmily && object.status == eObjectAlive) || self.isDevelopmentMode)) {
            self.swipeFromColumn = column;
            self.swipeFromRow = row;
            [self showSelectionIndicatorForObject:object];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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
        for(NSInteger i=self.swipeFromColumn+horzDelta ; (i>=0 && i<NumColumns) ; i = i+horzDelta){
            NSString *point = NSStringFromCGPoint(CGPointMake(i, self.swipeFromRow));
            [array addObject:point];
        }
    }

    if(vertDelta !=0){
        for(NSInteger i=self.swipeFromRow+vertDelta ; (i>=0 && i<NumRows) ; i = i+vertDelta){
            NSString *point = NSStringFromCGPoint(CGPointMake(self.swipeFromColumn,i));
            [array addObject:point];
        }
    }

    return array;
}

-(NSMutableDictionary*)getTilesDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    //New method
    NSMutableArray *rowArray = [NSMutableArray array];
    for (NSInteger row = NumRows-1; row >= 0; row--) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            NSMutableArray *objects = [_level objectAtColumn:column row:row];
            [objects enumerateObjectsUsingBlock:^(WUNObject *obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *data = [obj saveData];
                [rowArray addObject:data];
            }];
        }
    }
    
    [dictionary setObject:rowArray forKey:@"tiles"];
    return dictionary;
}

-(void)checkGameOver
{
    if(self.isDevelopmentMode){
        return;
    }
    
    if(self.updateUI){
        self.updateUI(self.level.levelModel.noOfMoves);
    }
    
    EGAMESTATUS status = [self.level isGameOver];
    if(status != eGameRunning){
        if (self.gameCompletion != nil) {
            self.gameCompletion(status);
        }
    }
}

- (void)trySwapHorizontal:(NSInteger)horzDelta vertical:(NSInteger)vertDelta
{
    NSMutableArray *adjacentPoints = [self adjacentPoints:horzDelta vertical:vertDelta];
    
    NSInteger toColumn = self.swipeFromColumn;
    NSInteger toRow = self.swipeFromRow;
    
    if (toColumn < 0 || toColumn >= NumColumns) return;
    if (toRow < 0 || toRow >= NumRows) return;
    
    NSMutableArray *objects = [self.level objectAtColumn:toColumn row:toRow];
    WUNObject *currentObject = [objects lastObject];
    if (currentObject == nil){
        return;
    }
    __block CGPoint toPoint = CGPointFromString([adjacentPoints lastObject]);
    if(adjacentPoints.count == 0){
        toPoint = CGPointMake(currentObject.column, currentObject.row);
    }
    __block EObjectStatus status = eObjectGone;

    if(self.isDevelopmentMode){
        toPoint = CGPointMake(toColumn+horzDelta, toRow+vertDelta);
        status = currentObject.status;
    }
    else{
        [adjacentPoints enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            CGPoint point = CGPointFromString(obj);
            EObjectType objectType = eObjectNone;
            
            NSMutableArray *objects = [self.level objectAtColumn:point.x row:point.y];
            __block WUNObject *nextObject = nil;
            if(objects.count == 1){
                nextObject = [objects objectAtIndex:0];
            }
            else{
                nextObject = [objects lastObject];
                [objects enumerateObjectsUsingBlock:^(WUNObject *obj, NSUInteger idx, BOOL *stop) {
                    if(obj.ObjectType == eObjectWall){
                        nextObject = obj;
                        *stop = YES;
                    }
                }];
            }
            
            if(nextObject && [nextObject isKindOfClass:[WUNObject class]]){
                objectType = nextObject.ObjectType;
            }
            
            switch (objectType) {
                case eObjectWall:{
                    toPoint = CGPointMake(point.x-horzDelta, point.y-vertDelta);
                    *stop = YES;
                    status = eObjectAlive;
                }
                    break;
                case eObjectSmily:{
                }
                    break;
                case eObjectHole:{
                    if(nextObject.status == eObjectAlive){
                        nextObject.status = eObjectDead;
                        status = eObjectDead;
                        toPoint = CGPointMake(point.x, point.y);
                        *stop = YES;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        if(status == eObjectGone){
            toPoint = CGPointMake(toPoint.x+horzDelta*4, toPoint.y+vertDelta*4);
        }
    }

    [self moveObjectToPoint:currentObject point:toPoint status:status];
}

-(void)moveObjectToPoint:(WUNObject*)object point:(CGPoint)inPoint status:(EObjectStatus)status
{
    NSInteger diff = abs((object.row-inPoint.x)+(object.column-inPoint.y));
    CGPoint point = [self pointForColumn:inPoint.x row:inPoint.y];
    SKAction *action = [SKAction moveTo:point duration:MAX(0.4, 0.1*diff)];
    [object.sprite runAction:action completion:^{
        object.status = status;
        object.column = inPoint.x;
        object.row = inPoint.y;
        self.level.levelModel.noOfMoves += 1;
        [self.level bringToFront:object];
        [self performSelector:@selector(checkGameOver) withObject:nil afterDelay:0.5];
    }];
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
