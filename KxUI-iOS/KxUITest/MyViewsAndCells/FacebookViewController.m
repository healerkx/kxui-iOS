//
//  FacebookViewController.m
//  KxUITest
//
//  Created by Zhongmin Yu on 7/2/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "FacebookViewController.h"
#import "FacebookCell.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerClass:[FacebookCell class] forCellReuseIdentifier:CellIdentifier];
    FacebookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[FacebookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.row % 2 == 1)
        cell.showOutline = YES;
    [cell bindAtIndexPath:indexPath withDelegate:self];
    
    return cell;
}

- (void)bindLayoutCell:(KxUICell*)cell atIndexPath:(NSIndexPath*)indexPath whenCalculateHeight:(BOOL)whenCalculateHeight
{
    //
    [cell bindText:@"Attention China - registration NOW OPEN for The Color Run Beijing on August 10th! Sign up today: http://yahoo.com" forId:@"text"];
    //
    NSString* imgPath = [[NSBundle mainBundle] pathForResource:@"Assets/facebook_img" ofType:@"jpg"];
    UIImage* img = [UIImage imageWithContentsOfFile:imgPath];
    [cell bindIcon:img forId:@"image"];

    //
    [cell bindText:@"14 赞" forId:@"like-count"];
    [cell bindText:@"250 评论" forId:@"comments-count"];
    
    
    //
    NSString* avatarPath = [[NSBundle mainBundle] pathForResource:@"Assets/avatar" ofType:@"jpg"];
    UIImage* avatar = [UIImage imageWithContentsOfFile:avatarPath];
    [cell bindIcon:avatar forId:@"avatar"];
    
    
    [cell bindText:@"Zhongmin Yu" forId:@"title"];
    [cell bindText:@"A Foolish man" forId:@"sub-title"];
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FacebookCell calculateHeightAtIndexPath:indexPath withWidth:320.0 withDelegate:self];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
