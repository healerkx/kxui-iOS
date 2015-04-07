//
//  XLayoutBoxRoot.m
//  XLayout
//
//  Created by Healer
//  Copyright (c) 2012年. All rights reserved.
//

#import "KxLayoutBoxRoot.h"
#import "KxUIDef.h"


@interface KxLayoutBoxRoot()
@property (strong) NSMutableDictionary* dataExDict;
@end

@implementation KxLayoutBoxRoot
@synthesize rect	= _rect;

- (KxLayoutBoxRoot*)init:(NSString*)name isVertical:(BOOL)vertical
{
    if (!name)
    {
        name = @"<ROOT>";
    }
	self = [super init:name isVertical:vertical];
    self.isSpread = YES;
    
    self.dataExDict = [NSMutableDictionary dictionary];
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    KxLayoutBoxRoot *root = [[KxLayoutBoxRoot alloc] init:self.name isVertical:self.isVertical];
    root.boxRoot = self;
    root.dataExDict = self.dataExDict;
    [root duplicateMembers:self withZone:zone];
	[root duplicateSubBox:self withZone:zone];
    return root;
}

- (void)executeQuery:(XLayoutQueryBlock)valuesSetCallback withConstraintRect:(CGRect)rect
{
    self.widthAttr = rect.size.width;
    if ( !float_eql(rect.size.height, MAXFLOAT) )
    {
        self.heightAttr = rect.size.height;
    }
    
	[self executeQuery:valuesSetCallback withParent:nil];
}

- (void)selectRect:(CGRect)rect
{
    _x = rect.origin.x;
    _y = rect.origin.y;
    _width = rect.size.width;
    _height = rect.size.height;
    [super selectRect:rect];
}

- (CGFloat)calculateHeight
{
    return [super calculateHeight];
}

- (CGFloat)calculatePropHeight:(XLayoutQueryBlock)valuesSetCallback
{
    return [super calculatePropHeight:valuesSetCallback];
}


- (void)setProperty:(id)property withKey:(NSString*)key
{
    [self.dataExDict setObject:property forKey:key];
}

- (id)getPropertyByKey:(NSString *)key
{
    return [self.dataExDict objectForKey:key];
}


@end
