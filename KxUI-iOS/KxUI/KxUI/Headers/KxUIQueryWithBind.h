//
//  XLayoutQueryWithBind.h
//  XLayout
//
//  Created by Healer on 12-4-1.
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KxLayout;
@class KxLayoutBox;
@class KxUIQuery;
@class KxBind;
@class XBindProperty;
@class KxStyle;


@interface KxUIQueryWithBind : NSObject
{
    KxLayout*		_layout;
    KxUIQuery*      _query;
    //KxBind*			_bind;
    //XBindProperty*	_property;
    BOOL			_debug;
    
}

@property (nonatomic, strong)	KxLayout*			layout;
@property (nonatomic, strong)	KxUIQuery*          query;
@property (nonatomic, strong)	KxBind*				bind;
@property (nonatomic, strong)	XBindProperty*		property;

/* Use sameIdWith() to check identifier same...
//@property (nonatomic, readonly)	NSString		*identifier;
*/
@property (nonatomic, assign)	CGFloat			width;
@property (nonatomic, assign)	CGFloat			height;
@property (nonatomic, strong)	NSString		*refSource;

@property (nonatomic, readonly)	BOOL			widthKnown;
@property (nonatomic, readonly)	BOOL			heightKnown;
@property (nonatomic, assign)	BOOL			debug;
@property (weak, nonatomic, readonly)	KxLayoutBox		*box;

- (id)initWithLayout:(KxLayout*)layout;
- (KxStyle*)style;
- (BOOL)sameIdWith:(NSString*)idStr;
@end
