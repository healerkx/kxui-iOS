//
//  WeiboCell.m
//  KxUITest
//
//  Created by Zhongmin Yu on 6/30/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "WeiboCell.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.layoutName = @"weibo";
    }
    return self;
}

- (void)layout:(KxLayout *)layout willProcessAtStage:(KxLayoutStage)stage
{
    
}


- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout
{
    [layout debugPaintOutline];
    
}


@end
