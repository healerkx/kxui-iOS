//
//  XLayoutResult.m
//  XLayout
//
//  Created by Healer
//  Copyright (c) 2013. All rights reserved.
//

#import "KxLayoutResult.h"

struct box_data
{
	CGFloat		_x;
	CGFloat		_y;
	CGFloat		_width;
	CGFloat		_height;
};


@implementation XLayoutCalcResult

@synthesize identifier	= _identifier;
@synthesize size		= _size;
@synthesize actionOnWidthChanged	= _actionOnWidthChanged;    
@synthesize actionOnHeightChanged	= _actionOnHeightChanged;
- (id)initWith:(NSString*)identifier
{
    self = [super init];
    self.identifier = identifier;
    return self;
}


@end



@interface KxLayoutResult()
{
    struct box_data	*box_datas;
}
@end

@implementation KxLayoutResult

- (id)init:(int)length
{
    self = [super init];
    box_datas = (struct box_data*)malloc(length * sizeof(struct box_data));
    return self;
}

- (void)dealloc
{
    free(box_datas);
}

- (CGRect)rectByIndex:(NSInteger)index
{
    struct box_data* bd = &box_datas[index];
    return CGRectMake(bd->_x, bd->_y, bd->_width, bd->_height);
}


@end
