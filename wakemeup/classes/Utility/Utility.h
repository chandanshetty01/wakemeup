//
//  Utility.h
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKStoreManager.h"

@interface Utility : NSObject

+(NSDictionary *)loadJSON:(NSString *)filename;
+(NSInteger)saveJSON:(NSDictionary*)dictionary fileName:(NSString*)fileName;
+(NSData*)JSONdataForFileName:(NSString*)filename;
+(CGSize)tileSize;
+(SKProduct*)productWithID:(NSString*)inID;

@end
