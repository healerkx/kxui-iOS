//
//  XLayout.h
//  XLayout
//
//  Created by Zhongmin Yu
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KxLayoutBox.h"
#import "KxLayoutBoxRoot.h"
#import "KxUIQuery.h"

@class KxLayoutBoxRoot;
@class KxLayoutBox;
@class KxLayoutResult;

@interface KxLayout : NSObject
{
    KxLayoutBoxRoot			*_root;
    KxLayoutResult			*_result;
        
}

@property (nonatomic, strong)	KxLayoutResult	*result;
@property (nonatomic, readonly)	KxLayoutBoxRoot	*root;

+ (NSData*)loadXml:(NSString*)name;
+ (KxLayoutBoxRoot*)parse:(NSData*)layoutXml;
+ (KxLayout*)load:(NSString*)name;

+ (NSString*)identifier:(NSString*)identifier withRefId:(NSString*)refIdentifier;

- (BOOL)hasId:(NSString*)idStr;

- (void)executeRefQuery:(XLayoutQueryBlock)valuesSetCallback;
- (KxLayoutResult*)selectRect:(CGRect)rect afterValuesSet:(XLayoutQueryBlock)valuesSetCallback;

- (void)applyResult:(KxLayoutResult*)result;
- (KxLayoutBox*)boxById:(NSString*)identifier;
- (CGFloat)calculateHeight:(XLayoutQueryBlock)valuesSetCallback withWidth:(CGFloat)width;
- (CGFloat)calculatePropHeight:(XLayoutQueryBlock)valuesSetCallback;


- (void)_debugPaintOutline;

+ (BOOL)registerWidgetType:(Class)clz forName:(NSString*)typeName;
+ (UIView*)viewByType:(NSString*)type withLayoutBox:(KxLayoutBox*)box withHostView:(UIView*)hostView;

@end



