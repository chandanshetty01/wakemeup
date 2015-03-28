//
//  Utility.m
//  wakemeup
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chandan. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSData*)JSONdataForFileName:(NSString*)filename
{
    NSData *data = nil;
    data = [NSJSONSerialization dataWithJSONObject:[self loadJSON:filename] options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

+(NSDictionary *)loadJSON:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.json", documentsDirectory, filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
    }
    else{
        path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
        if (path == nil) {
            NSLog(@"Could not find level file: %@", filename);
            return nil;
        }
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", filename, error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
        return nil;
    }
    
    return dictionary;
}

+(NSInteger)saveJSON:(NSDictionary*)dictionary fileName:(NSString*)fileName
{
    NSDictionary *data = [[NSDictionary alloc] initWithDictionary:dictionary];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.json", documentsDirectory, fileName];
    
    NSInteger bytesWritten = 0;
    NSOutputStream *os = [[NSOutputStream alloc] initToFileAtPath:path append:NO];
    [os open];
    bytesWritten = [NSJSONSerialization writeJSONObject:data toStream:os options:0 error:nil];
    [os close];
    return bytesWritten;
}

+(CGSize)tileSize
{
    CGSize tileSize = CGSizeMake(36, 36);
    if (IS_IPAD){
        tileSize = CGSizeMake(80, 80);
    }
    else{
        if(IS_IPHONE_6 || IS_IPHONE_6P){
             tileSize = CGSizeMake(44, 44);
        }
    }
    return tileSize;
}

+(SKProduct*)productWithID:(NSString*)inID
{
    __block SKProduct *product = nil;
    NSMutableArray *products = [MKStoreManager sharedManager].purchasableObjects;
    [products enumerateObjectsUsingBlock:^(SKProduct *obj, NSUInteger idx, BOOL *stop) {
        if([obj.productIdentifier isEqualToString:inID]){
            product = obj;
            *stop = YES;
        }
    }];
    return product;
}

@end
