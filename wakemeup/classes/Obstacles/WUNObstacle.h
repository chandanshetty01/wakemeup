//
//  WUNObstacle.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WUNBase.h"

typedef enum {
    eHorizontalObstacle,
    eVertivalObstacle
}EObstacletype;

@interface WUNObstacle : WUNBase
{
    
}

+(NSDictionary*)testObjectData;

@property(nonatomic,assign)EObstacletype obstacleType;
@property(nonatomic,assign)CGFloat duration;
@property(nonatomic,assign)CGFloat distance;
@property(nonatomic,assign)CGPoint position;
@property(nonatomic,assign)CGSize size;

@end
