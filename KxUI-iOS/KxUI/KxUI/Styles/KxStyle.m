//
//  XLayoutStyle.m
//  YContact
//
//  Created by Healer
//  Copyright (c) 2013. All rights reserved.
//

#import "KxStyle.h"

@implementation KxStyle

- (id)initWithName:(NSString*)name
{
    self = [super init];
    self.name = name;
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    KxStyle* style = [[KxStyle alloc] initWithName:self.name];
    style.fontSize = self.fontSize;
    style.color = self.color;
    style.isBold = self.isBold;
    style.highlightColor = self.highlightColor;
    return style;
}

- (UIFont*)font
{
    if (self.isBold)
    {
        return [UIFont boldSystemFontOfSize:self.fontSize];
    }
    else
    {
        return [UIFont systemFontOfSize:self.fontSize];
    }
}


@end
