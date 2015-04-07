//
//  XLayoutBoxRoot.h
//  XLayout
//
//  Created by Healer
//  Copyright (c) 2012年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KxLayoutBox.h"

@interface KxLayoutBoxRoot : KxLayoutBox
{
	CGRect			_rect;
}
@property (nonatomic, assign)	CGRect		rect;

- (KxLayoutBoxRoot*)init:(NSString*)name isVertical:(BOOL)vertical;

- (void)executeQuery:(XLayoutQueryBlock)valuesSetCallback withConstraintRect:(CGRect)rect;

- (void)selectRect:(CGRect)rect;

- (CGFloat)calculateHeight;
- (CGFloat)calculatePropHeight:(XLayoutQueryBlock)valuesSetCallback;

- (void)setProperty:(id)property withKey:(NSString*)name;
- (id)getPropertyByKey:(NSString*)name;

@end
