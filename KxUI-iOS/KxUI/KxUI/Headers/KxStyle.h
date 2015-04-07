//
//  KxStyle.h
//
//
//  Created by Healer
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KxStyle : NSObject


@property (nonatomic, strong) NSString*     name;
@property (nonatomic, assign) CGFloat       fontSize;
@property (nonatomic, assign) BOOL          isBold;
@property (nonatomic, strong) UIColor*      color;
@property (nonatomic, strong) UIColor*      highlightColor;

- (id)initWithName:(NSString*)name;
- (UIFont*)font;
//- (id)copyWithZone:(NSZone*)zone;
@end
