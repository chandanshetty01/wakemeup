//
//  WUNBase.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface WUNBase : NSObject
{
    
}
@property (strong, nonatomic) SKSpriteNode *sprite;

-(NSString *)spriteName;
-(SKColor*)spriteColor;

-(id)initWithDictionary:(NSDictionary*)data;
-(NSDictionary*)saveData;
-(NSString *)highlightedSpriteName;

@end

