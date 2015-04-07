//
//  XLayoutUIBase.h
//  KxUI
//
//  Created by Healer on 12-4-18.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KxLayoutDelegate.h"

@class KxLayout;


@interface KxUIBase : NSObject
{
@private
    BOOL					_cacheCalcResult;
    NSString*				_layoutName;
    KxLayout*				_layout;
    NSMutableArray*			_binds;
    NSMutableArray*			_properties;
    NSMutableArray*			_hiddenArray;
    NSMutableArray*			_calcResults;
    UIView<KxUIDelegate>*	__weak _hostView;
@public
    
}
// Default ON, Cache can be closed in derived class.
@property (nonatomic, assign)	BOOL		cacheResultCalculated;
@property (nonatomic, strong) 	NSString*   layoutName;
@property (nonatomic, strong)   NSData*     layoutXmlData;
@property (nonatomic, strong)	KxLayout*   layout;

@property (weak, nonatomic, readonly)	NSArray 	*binds;

@property (weak, nonatomic, readonly)	UIView<KxUIDelegate>	*hostView;



// Method
- (id)initWithHostView:(UIView<KxUIDelegate>*)hostView;

- (void)clearBinds;

//- (KxLayout*)selectRect:(CGRect)rect;

- (void)drawContentView:(CGRect)rect;
- (void)layoutContentView:(CGRect)rect;


- (KxBind *)bindText:(NSString*)text withId:(NSString*)identifier;
- (KxBind *)bindIcon:(UIImage*)icon withId:(NSString*)identifier;
- (KxBind *)bindView:(id)view withId:(NSString*)identifier;

- (void)setBoxVisibility:(NSInteger)visibility forId:(NSString*)identifier;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event theView:(UIView*)view;

- (CGFloat)calculateHeightWithCell:(KxUICell*)cell
                       AtIndexPath:(NSIndexPath*)indexPath
                         withWidth:(CGFloat)width 
                      withDelegate:(id<KxUIBindDataDelegate>)delegate;
@end
