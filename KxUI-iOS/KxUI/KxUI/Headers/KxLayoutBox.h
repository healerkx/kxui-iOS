//
//  XLayoutBox.h
//  XLayout
//
//  Created by Zhongmin Yu on 12-3-24.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KxUIQuery.h"
#import "KxDataEx.h"
#import "KxStyle.h"


@class KxStyle;
@class KxLayoutBoxRoot;


@interface KxLayoutBox : NSObject
{
    NSString*		_namespace;
    NSString*		_name;
    NSString*		_refSource;
    
    
    NSInteger		_sizeProperty;
    id				_sizePropertyValue;
    
    BOOL			_nameSet;
    BOOL			_isProp;
    BOOL 			_isVertical;

    BOOL			_hasRef;
    BOOL			_widthAttrSet;
    BOOL			_heightAttrSet;

    BOOL 			_keepBorder;
    
    NSInteger		_subBoxCount;
    NSInteger		_align;
    NSInteger		_verticalAlign;
    NSInteger		_contentAlign;
    NSInteger		_contentVerticalAlign;

    
    CGFloat			_weight;

    CGFloat			_widthAttr;
    CGFloat			_heightAttr;
    
    CGFloat			_minHeight;
    CGFloat			_minWidth;
	CGFloat			_maxHeight;
	CGFloat			_maxWidth;
    
    
    KxStyle*		_style;
    KxDataEx*       _dataex;
    
    // No Property or Readonly
    CGFloat			_x;
    CGFloat			_y;
    CGFloat			_width;
    CGFloat			_height;

}

@property (nonatomic, assign)	BOOL		isProp;
@property (nonatomic, assign)	BOOL		isVertical;
@property (nonatomic, assign)	BOOL		isSpread;
@property (nonatomic, assign)   BOOL        isVerticalSpread;
@property (nonatomic, assign)   NSInteger   visibility;
@property (nonatomic, assign)	BOOL		hasRef;

@property (nonatomic, readonly)	BOOL		nameSet;
@property (nonatomic, assign)	BOOL		keepBorder;

@property (nonatomic, assign)	NSInteger	subBoxCount;
@property (nonatomic, assign)	NSInteger	align;
@property (nonatomic, assign)	NSInteger	verticalAlign;
@property (nonatomic, assign)	NSInteger	contentAlign;
@property (nonatomic, assign)	NSInteger	contentVerticalAlign;

@property (nonatomic, assign)	NSInteger	sizeProperty;
@property (nonatomic, strong)	id			sizePropertyValue;

@property (nonatomic, assign)	CGFloat		weight;

@property (nonatomic, readonly)	BOOL		widthAttrSet;
@property (nonatomic, readonly)	BOOL		heightAttrSet;
@property (nonatomic, assign)	CGFloat		widthAttr;
@property (nonatomic, assign)	CGFloat		heightAttr;


@property (nonatomic, assign)	CGFloat		minHeight;
@property (nonatomic, assign)	CGFloat		maxHeight;
@property (nonatomic, assign)	CGFloat		minWidth;
@property (nonatomic, assign)	CGFloat		maxWidth;

@property (nonatomic, assign)	CGFloat		marginLeft;
@property (nonatomic, assign)	CGFloat		marginRight;
@property (nonatomic, assign)	CGFloat		marginTop;
@property (nonatomic, assign)	CGFloat		marginBottom;

@property (nonatomic, assign)	CGFloat		paddingLeft;
@property (nonatomic, assign)	CGFloat		paddingRight;
@property (nonatomic, assign)	CGFloat		paddingTop;
@property (nonatomic, assign)	CGFloat		paddingBottom;


@property (nonatomic, strong)	NSString	*namespace;
@property (nonatomic, strong)	NSString	*name;

@property (nonatomic, strong)	NSString*   refSource;
@property (nonatomic, copy)     KxStyle*    style;

@property (nonatomic, strong)   KxLayoutBoxRoot*        boxRoot;


- (KxLayoutBox*)init:(NSString*)name isVertical:(BOOL)vertical;
- (NSString*)identifier;
- (void)duplicateSubBox:(KxLayoutBox*)box withZone:(NSZone *)zone;
- (void)duplicateMembers:(KxLayoutBox*)box withZone:(NSZone*)zone;
- (id)copyWithZone:(NSZone *)zone;

- (void)addSubBox:(KxLayoutBox*)box;
- (void)addNamespace:(NSString*)namespace;
- (int)subBoxCount;
- (KxLayoutBox*)subBox:(NSInteger)index;
- (KxLayoutBox*)boxById:(NSString*)identifier withRecursion:(BOOL)recursion;

- (CGRect)toLayoutRect;
- (CGRect)toRect;

- (CGRect)marginRect;
- (CGRect)layoutRect;
- (CGRect)paddingRect;


- (CGFloat)layoutHeight;
- (CGFloat)layoutWidth;

- (CGSize)executeQuery:(XLayoutQueryBlock)valuesSetCallback withParent:(KxLayoutBox*)parent;
- (void)executeRefQuery:(XLayoutQueryBlock)valuesSetCallback;

- (void)selectRect:(CGRect)rect;

- (CGFloat)calculateHeight;
- (CGFloat)calculatePropHeight:(XLayoutQueryBlock)valuesSetCallback;
- (UITextAlignment)textAlignment;

- (void)setProperty:(id)property withName:(NSString*)name;
- (id)getProperty:(NSString*)name;

@end
