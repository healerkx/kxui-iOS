//
//  
//  KxUI
//
//  Created by Zhongmin Yu on 7/4/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "UIColor+KxUI.h"


@implementation UIColor (KxUI)


// TODO: optimize
+ (UIColor*)colorFromString:(NSString*)colorString
{
    NSString* rs = [colorString substringWithRange:NSMakeRange(1, 2)];
    NSString* gs = [colorString substringWithRange:NSMakeRange(3, 2)];
    NSString* bs = [colorString substringWithRange:NSMakeRange(5, 2)];
    
    CGFloat r = (CGFloat)[rs hex] / 255.0;
    CGFloat g = (CGFloat)[gs hex] / 255.0;
    CGFloat b = (CGFloat)[bs hex] / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}
@end
