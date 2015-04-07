//
//  ViewController.m
//  KxUITest
//
//  Created by healer on 12-11-3.
//  Copyright (c) 2012年 healer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong) UIView *subView;
@property (strong) Class  clz;
@end

@implementation ViewController



- (id)initWithViewClass:(Class)clz
{
    self = [super init];
    if (self != nil)
    {
        self.clz = clz;
        return self;
    }
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)loadView
{
    [super loadView];
    
    CGRect rect = self.view.bounds;
    rect.size.height -= self.navigationController.navigationBar.bounds.size.height;
    
    self.subView = [[self.clz alloc] initWithFrame:rect];
    [self.view addSubview:self.subView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
