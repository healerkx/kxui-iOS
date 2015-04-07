//
//  XLayoutStyle.m
//  YContact
//
//  Created by Healer (Zhongmin)
//  Copyright (c) 2013. All rights reserved.
//

#import "KxStyles.h"

@interface KxStyles()
{
    NSMutableDictionary*	_styles;
}
@end

@implementation KxStyles


- (KxStyles*)init
{
    self = [super init];
    if (self)
    {
        _styles = [NSMutableDictionary dictionary];
    }
    return self;
}

- (KxStyle*)styleByName:(NSString*)name
{
    return nil;
}
@end
