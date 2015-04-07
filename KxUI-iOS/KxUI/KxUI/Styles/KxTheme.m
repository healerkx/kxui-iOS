//
//  KxTheme.m
//  KxUI
//
//  Created by Zhongmin Yu on 8/13/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "KxTheme.h"

@implementation KxTheme


+ (UIImage*)imageByName:(NSString*)name withTheme:(NSString*)theme
{
    NSString* avatarPath = [[NSBundle mainBundle] pathForResource:@"Assets/avatar" ofType:@"jpg"];
    UIImage* avatar = [UIImage imageWithContentsOfFile:avatarPath];
    return nil;
}

@end
