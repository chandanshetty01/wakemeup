//
//  WUNLevelModel.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUNLevelModel : NSObject
{
    
}

-(id)initWithDictionary:(NSDictionary*)data;
-(NSDictionary*)levelData;

@property(nonatomic,assign) NSInteger levelID;
@property(nonatomic,assign) BOOL isCompleted;
@property(nonatomic,assign) BOOL isUnlocked;
@property(nonatomic,assign) NSInteger noOfMoves;
@property(nonatomic,assign) NSInteger bestNoOfMoves;
@property(nonatomic,strong) NSMutableArray *tiles;

@end
