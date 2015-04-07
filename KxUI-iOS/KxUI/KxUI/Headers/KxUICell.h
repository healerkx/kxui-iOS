//
//  XLayoutUICellCell.h
//  XLayout
//
//  Created by Healer on 12-4-1.
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KxLayoutDelegate.h"
#import "KxLayout.h"

#import "KxUIQueryWithBind.h"
#import "KxBind.h"
#import "KxStyle.h"
#import "KxLayoutUICellConfig.h"

#import "KxLayout+CodeGen.h"
#import "KxLayout+Debug.h"

#define kKxUICellClass [KxUICell class]

@class KxUIBase;

@interface KxUICell : KxLayoutUICellBase<KxUIDelegate>
@property (nonatomic, readonly)	KxUIBase*	base;


- (NSArray*)binds;
- (void)setLayoutName:(NSString*)layoutName;
- (NSString*)layoutName;
- (void)setLayoutXml:(NSData*)layoutXml;
- (void)drawContentView:(CGRect)rect;

- (void)bindAtIndexPath:(NSIndexPath*)indexPath withDelegate:(id<KxUIBindDataDelegate>)delegate whenCalculateHeight:(BOOL)whenCalculateHeight;
- (void)bindAtIndexPath:(NSIndexPath*)indexPath withDelegate:(id<KxUIBindDataDelegate>)delegate;


+ (CGFloat)calculateHeightAtIndexPath:(NSIndexPath*)indexPath
                            withWidth:(CGFloat)width 
                         withDelegate:(id<KxUIBindDataDelegate>)delegate;


- (KxBind*)bindText:(NSString*)text forId:(NSString*)identifier;
- (KxBind*)bindIcon:(UIImage*)icon forId:(NSString*)identifier;
- (KxBind*)bindView:(id)view forId:(NSString*)identifier;

- (void)setBoxVisibility:(NSInteger)visibility forId:(NSString*)identifier;

@end
