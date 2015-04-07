//
//  XLayoutQuery.m
//  XLayout
//
//  Created by Healer on 12-3-27.
//  Copyright (c) 2012年. All rights reserved.
//

#import "KxUIQuery.h"
#import "KxLayoutBox.h"

@implementation KxUIQuery

@synthesize identifier			= _identifier;
@synthesize refSource			= _refSource;
@synthesize actionOnRefSource	= _actionOnRefSource;
@synthesize actionOnWidth		= _actionOnWidth;
@synthesize actionOnHeight		= _actionOnHeight;
@synthesize width				= _width;
@synthesize height				= _height;
@synthesize widthKnown			= _widthKnown;
@synthesize heightKnown			= _heightKnown;
@synthesize box					= _box;


- (KxUIQuery*)initWithBox:(KxLayoutBox*)box
{
    self = [super init];
    self.box = box;
    
    _actionOnWidth = ActionWidthNotSet;
    _actionOnHeight = ActionHeightNotSet;
    _actionOnRefSource = ActionRefSourceNotSet;
    
    if ( box.widthAttrSet )
    {
        _widthKnown = YES;
        self.width = box.widthAttr;
    }
    if ( box.heightAttrSet )
    {
        _heightKnown = YES;
        self.height = box.heightAttr;
    }
    return self;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
	_actionOnWidth = ActionWidthSet;
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    _actionOnHeight = ActionHeightSet;
}

+ (KxUIQuery*)fetch:(KxLayoutBox*)box
{
    KxUIQuery *query = [[KxUIQuery alloc] initWithBox:box];
    query.identifier = box.identifier;
    return query;
}


- (BOOL)widthNotSet
{
    return _actionOnWidth == ActionWidthNotSet;
}

- (BOOL)heightNotSet
{
    return _actionOnHeight == ActionHeightNotSet;
}

- (void)widthSetSpread
{
    _actionOnWidth = ActionWidthSpread;
}

- (void)setRefSource:(NSString *)refSource
{
    _refSource = refSource;
    _actionOnRefSource = ActionRefSourceSet;
}

@end
