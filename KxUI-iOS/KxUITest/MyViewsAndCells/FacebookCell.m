//
//  FacebookCell.m
//  KxUITest
//
//  Created by Zhongmin Yu on 7/2/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "FacebookCell.h"

@implementation FacebookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.layoutName = @"facebook";
        self.showOutline = NO;
    }
    return self;
}


- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout
{
    if (self.showOutline)
    {
        [layout debugPaintOutline];
    }
    
}

@end
