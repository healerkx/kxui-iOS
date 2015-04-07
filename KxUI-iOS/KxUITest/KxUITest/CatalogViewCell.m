//
//  CatalogViewCell.m
//  KxUITest
//
//  Created by Zhongmin Yu on 5/31/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "CatalogViewCell.h"


@implementation CatalogViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.layoutName = @"catalog-cell";
        
        /*
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor grayColor];
        label.text = @"Hello";
        [self addSubview:label];

        */
    }
    return self;
}

@end
