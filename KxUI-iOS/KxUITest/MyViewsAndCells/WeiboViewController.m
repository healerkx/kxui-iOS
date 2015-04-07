//
//  WeiboViewController.m
//  KxUITest
//
//  Created by Zhongmin Yu on 7/11/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "WeiboViewController.h"
#import "WeiboCell.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerClass:[WeiboCell class] forCellReuseIdentifier:CellIdentifier];
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /*
    if (indexPath.row % 2 == 1)
        cell.showOutline = YES;
     */
    [cell bindAtIndexPath:indexPath withDelegate:self];
    
    return cell;
}

- (void)bindLayoutCell:(KxUICell*)cell atIndexPath:(NSIndexPath*)indexPath whenCalculateHeight:(BOOL)whenCalculateHeight
{
    //
    [cell bindText:@"甘草-Healer" forId:@"name"];
    
    [cell bindText:@"10分钟前" forId:@"post-time"];
    [cell bindText:@"来自iPhone客户端" forId:@"post-from"];
    [cell bindText:@"2" forId:@"like-count"];

    
    
    if (indexPath.row % 2 == 0)
        [cell setBoxVisibility:kCollapse forId:@"image"];
    else
    {
        
        [cell setBoxVisibility:kCollapse forId:@"repost"];
        NSString* imgPath = [[NSBundle mainBundle] pathForResource:@"Assets/facebook_img" ofType:@"jpg"];
        UIImage* img = [UIImage imageWithContentsOfFile:imgPath];
        [cell bindIcon:img forId:@"image"];
    }

    
    NSString* avatarPath = [[NSBundle mainBundle] pathForResource:@"Assets/avatar" ofType:@"jpg"];
    UIImage* avatar = [UIImage imageWithContentsOfFile:avatarPath];
    [cell bindIcon:avatar forId:@"avatar"];    
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WeiboCell calculateHeightAtIndexPath:indexPath withWidth:320.0 withDelegate:self];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
