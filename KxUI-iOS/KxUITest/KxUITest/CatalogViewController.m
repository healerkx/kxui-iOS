//
//  CatalogViewController.m
//  KxUITest
//
//  Created by Zhongmin Yu on 5/31/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "CatalogViewController.h"
#import "CatalogViewCell.h"

#import "ViewController.h"

#import "YahooSignInView.h"
#import "ErrorMessageView.h"
#import "TextBindView.h"
#import "EditorView.h"
#import "FacebookViewController.h"
#import "WeiboViewController.h"

@interface CatalogItem : NSObject
@property (strong) NSString*    title;
@property (strong) NSString*    description;
@property (copy)   void(^controller)();

+ (CatalogItem*)itemFromTitle:(NSString*)title
              withDescription:(NSString*)description
               withController:(void(^)())controller;
@end

@implementation CatalogItem
+ (CatalogItem*)itemFromTitle:(NSString*)title
              withDescription:(NSString*)description
               withController:(void(^)())controller
{
    CatalogItem* item = [[CatalogItem alloc] init];
    item.title = title;
    item.description = description;
    item.controller = controller;
    return item;
}
@end


@interface CatalogViewController ()
@property (strong, nonatomic) NSMutableArray* dataSource;
@end

@implementation CatalogViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        NSMutableArray *catalogArray = [NSMutableArray array];
        
        // Yahoo SignIn Page
        [catalogArray addObject:[CatalogItem itemFromTitle:@"Yahoo SignIn Page"
                                           withDescription:@"This demo shows how to deal with different screen size."
                                            withController:^(){
                                                [self pushViewControllerWithClass:[YahooSignInView class]];
                                            }]];

        // 
        [catalogArray addObject:[CatalogItem itemFromTitle:@"Visibility is 'Hidden' or 'Collapsed'"
                                           withDescription:@"Demo shows the difference between 'Hidden' and 'Collapsed'"
                                            withController:^(){
                                                [self pushViewControllerWithClass:[ErrorMessageView class]];
                                            }]];
        
        [catalogArray addObject:[CatalogItem itemFromTitle:@"Text binds demo"
                                           withDescription:@"This demo shows how to bind text"
                                            withController:^(){
                                                [self pushViewControllerWithClass:[TextBindView class]];
                                            }]];

        [catalogArray addObject:[CatalogItem itemFromTitle:@"Facebook Cell Demo"
                                           withDescription:@"How to layout a facebook cell."
                                            withController:^(){
                                                FacebookViewController *vc = [[FacebookViewController alloc] initWithStyle:UITableViewStylePlain];
                                                [self.navigationController pushViewController:vc animated:YES];
                                            }]];
        
        [catalogArray addObject:[CatalogItem itemFromTitle:@"Weibo Cell Demo"
                                           withDescription:@"How to layout a weibo cell. This demos how to include other layout file"
                                            withController:^(){
                                                WeiboViewController *vc = [[WeiboViewController alloc] initWithStyle:UITableViewStylePlain];
                                                [self.navigationController pushViewController:vc animated:YES];
                                            }]];
        
        
        [catalogArray addObject:[CatalogItem itemFromTitle:@"Layout editor"
                                           withDescription:@"Batter show it in iPad."
                                            withController:^(){
                                                ViewController *vc = [[ViewController alloc] initWithViewClass:[EditorView class]];
                                                [self.navigationController pushViewController:vc animated:YES];
                                            }]];
        
        

        
    

        self.dataSource = catalogArray;
        
    }
    return self;
}

- (void)pushViewControllerWithClass:(Class)class
{
    ViewController *vc = [[ViewController alloc] initWithViewClass:class];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerClass:[CatalogViewCell class] forCellReuseIdentifier:CellIdentifier];

    CatalogViewCell *cell = (CatalogViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[CatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell bindAtIndexPath:indexPath withDelegate:self];
    
    return cell;
}


// Notice Here !!!
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CatalogViewCell calculateHeightAtIndexPath:indexPath withWidth:320.0 withDelegate:self];
}

- (void)bindLayoutCell:(KxUICell*)cell atIndexPath:(NSIndexPath*)indexPath whenCalculateHeight:(BOOL)whenCalculateHeight
{
    CatalogItem *item = [self.dataSource objectAtIndex:indexPath.row];
    
    NSString* title = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1,  item.title];
    [cell bindText:title forId:@"title"];
    [cell bindText:item.description forId:@"description"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CatalogItem *item = [self.dataSource objectAtIndex:indexPath.row];
    item.controller();
    
}



@end
