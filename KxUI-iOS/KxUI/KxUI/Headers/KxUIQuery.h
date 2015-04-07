//
//  XLayoutQuery.h
//  XLayout
//
//  Created by Healer on 12-3-27.
//  Copyright (c) 2012年. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    ActionWidthNotSet = 0,
    ActionWidthSet,
    ActionWidthSpread
}
ActionOnWidth;

typedef enum
{
    ActionHeightNotSet = 0,
    ActionHeightSet,
}
ActionOnHeight;

typedef enum
{
    ActionRefSourceNotSet = 0,
    ActionRefSourceSet    
}
ActionOnRefSource;


@class KxLayoutBox;
@class KxStyle;

@interface KxUIQuery : NSObject
{
    NSString			*_identifier;
    NSString			*_refSource;
    ActionOnWidth		_actionOnWidth;
    ActionOnHeight		_actionOnHeight;
    ActionOnRefSource	_actionOnRefSource;
	BOOL				_widthKnown;
	BOOL				_heightKnown;    
    CGFloat				_width;
    CGFloat				_height;
    
    KxLayoutBox			*_box;
}

@property (nonatomic, strong)	NSString			*identifier;
@property (nonatomic, strong)	NSString			*refSource;
@property (nonatomic, assign)	ActionOnWidth		actionOnWidth;
@property (nonatomic, assign)	ActionOnHeight		actionOnHeight;
@property (nonatomic, assign)	ActionOnRefSource	actionOnRefSource;
@property (nonatomic, assign)	CGFloat				width;
@property (nonatomic, assign)	CGFloat				height;
@property (nonatomic, readonly) BOOL				widthKnown;
@property (nonatomic, readonly) BOOL				heightKnown;
@property (nonatomic, strong)	KxLayoutBox			*box;

+ (KxUIQuery*)fetch:(KxLayoutBox*)box;

@end



typedef void(^XLayoutQueryBlock)(KxUIQuery*);




