//
//  CustomActivityProvider.m
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 24/3/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import "CustomActivityProvider.h"

@implementation CustomActivityProvider

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] ){
        return [NSString stringWithFormat:NSLocalizedString(@"TwitterMsg",nil),self.totalMoves];
    }
    else if ( [activityType isEqualToString:UIActivityTypePostToFacebook] ){
        return [NSString stringWithFormat:NSLocalizedString(@"TwitterMsg",nil),self.totalMoves];
    }
    else if ( [activityType isEqualToString:UIActivityTypeMail] ){
        return [NSString stringWithFormat:NSLocalizedString(@"TwitterMsg",nil),self.totalMoves];
    }
    return nil;
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

@end
