//
//  XLayoutResult.h
//  XLayout
//
//  Created by Healer
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLayoutCalcResult : NSObject
{
    NSString*		_identifier;
    CGSize			_size;
    BOOL			_actionOnWidthChanged;    
    BOOL			_actionOnHeightChanged;
}
@property (nonatomic, strong)	NSString*		identifier;
@property (nonatomic, assign)	CGSize			size;
@property (nonatomic, assign)	BOOL			actionOnWidthChanged;    
@property (nonatomic, assign)	BOOL			actionOnHeightChanged;

- (id)initWith:(NSString*)identifier;
@end


@interface KxLayoutResult : NSObject


- (CGRect)rectByIndex:(NSInteger)index;


@end
