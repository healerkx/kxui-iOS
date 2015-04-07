//
//  XLayoutUIView.h
//  XLayout
//
//  Created by Healer on 12-4-1.
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KxLayoutDelegate.h"

@class KxLayout;
@class KxUIBase;

@interface KxUIView : UIView<KxUIDelegate>

- (void)setLayoutName:(NSString*)layoutName;
- (void)setLayoutXml:(NSData*)layoutXml;
- (NSString*)layoutName;

- (KxBind*)bindText:(NSString*)text withId:(NSString*)identifier;
- (KxBind*)bindIcon:(UIImage*)icon withId:(NSString*)identifier;
- (KxBind*)bindView:(id)view withId:(NSString*)identifier;
- (void)setBoxVisibility:(NSInteger)visibility forId:(NSString*)identifier;

@end
