//
//  XLayoutDelegate.h
//  KxUI
//
//  Created by Healer
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KxLayout;
@class KxUIQueryWithBind;
@class KxBind;
@class KxUICell;

typedef enum
{
    Unknow = -1,
    CalculatHeight = 0,
    Drawing,
    LayoutSubviews,
} KxLayoutStage;

@protocol KxUIDelegate<NSObject>
@required
- (void)didRefQuery:(KxUIQueryWithBind*)query withLayout:(KxLayout*)layout;
- (void)didQuery:(KxUIQueryWithBind*)query withLayout:(KxLayout*)layout;
- (void)didDrawBindText:(KxBind*)bind withLayout:(KxLayout*)layout;
- (void)didDrawBindIcon:(KxBind*)bind withLayout:(KxLayout*)layout supportHighlight:(BOOL)supportHighlight;
@optional

- (void)managedSubviewsReady:(BOOL)ready withLayout:(KxLayout*)layout;
- (void)layout:(KxLayout*)layout willProcessAtStage:(KxLayoutStage)stage;
- (void)didLayoutSubviews:(CGRect)rect withLayout:(KxLayout*)layout;
- (void)didDrawBackground:(CGRect)rect withLayout:(KxLayout*)layout;
- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout;
@end


@protocol KxUIBindDataDelegate<NSObject>
@required
- (void)bindLayoutCell:(KxUICell*)cell atIndexPath:(NSIndexPath*)indexPath whenCalculateHeight:(BOOL)whenCalculateHeight;
@end