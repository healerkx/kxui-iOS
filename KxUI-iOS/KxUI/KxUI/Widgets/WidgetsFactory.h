//
//  WidgetsFactory.h
//  KxUI
//
//  Created by Zhongmin Yu on 6/25/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KxLayoutBox;

@interface WidgetsFactory : NSObject

+ (WidgetsFactory*)sharedFactory;
- (BOOL)registerWidgetType:(Class)clz forName:(NSString*)typeName;
- (UIView*)viewByType:(NSString*)type withLayoutBox:(KxLayoutBox*)box withHostView:(UIView*)hostView;

@end
