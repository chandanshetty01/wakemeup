//
//  UIButton+Additions.m
//  WakeMeUp
//
//  Created by Chandan Shetty SP on 4/4/15.
//  Copyright (c) 2015 Chandan. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton (Additions)

-(void)bottomAlignText
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

@end
