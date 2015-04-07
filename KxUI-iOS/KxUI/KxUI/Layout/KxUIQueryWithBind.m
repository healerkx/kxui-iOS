//
//  XLayoutQueryWithBind.m
//  XLayout
//
//  Created by Healer on 12-4-1.
//  Copyright (c) 2012年. All rights reserved.
//

#import "KxUIQueryWithBind.h"
#import "KxLayout.h"
#import "KxUIQuery.h"
#import "KxStyle.h"


@implementation KxUIQueryWithBind
@synthesize bind;//		= _bind;
@synthesize property;//	= _property;
@synthesize layout		= _layout;
@synthesize query		= _query;
@synthesize debug		= _debug;



- (id)initWithLayout:(KxLayout*)layout
{
    self = [super init];
    self.debug = NO;
    self.layout = layout;
    return self;
}

// use this method inner.
- (NSString*)identifier
{
    return self.query.identifier;
}


- (CGFloat)width
{
    return self.query.width;
}

- (void)setWidth:(CGFloat)width
{
    self.query.width = width;
}

- (CGFloat)height
{
    return self.query.height;
}

- (void)setHeight:(CGFloat)height
{
    self.query.height = height;
}

- (BOOL)widthKnown
{
    return self.query.widthKnown;
}

- (BOOL)heightKnown
{
    return self.query.heightKnown;
}

- (void)setRefSource:(NSString*)refSource
{
    self.query.refSource = refSource;
}

- (NSString*)refSource
{
    return self.query.refSource;
}

- (KxStyle*)style
{
    return self.query.box.style;
}

- (KxLayoutBox*)box
{
    return self.query.box;
}

- (BOOL)sameIdWith:(NSString*)idStr
{
    if (self.debug)
    {
        assert([self.layout hasId:idStr]);
    }
    return [idStr isEqualToString:self.identifier];
}


@end
