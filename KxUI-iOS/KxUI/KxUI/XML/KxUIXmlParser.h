//
//  XLayoutParser.h
//  XLayout
//
//  Created by Healer on 12-3-24.
//  Copyright (c) 2012年. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KxLayoutBoxRoot;

@interface KxUIXmlParser : NSObject
+ (KxLayoutBoxRoot*)parse:(NSData*)content;
@end
