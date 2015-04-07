//
//  ErrorMessageView.m
//  KxUITest
//
//  Created by Zhongmin Yu on 6/29/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "ErrorMessageView.h"
#import "KxUI.h"
#import "KxLayout+Debug.h"

@interface ErrorMessageView()
@property (nonatomic, strong) NSString*     tappedButtonText;
@end 

@implementation ErrorMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutName = @"error-msg-view";
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)managedSubviewsReady:(BOOL)ready withLayout:(KxLayout *)layout
{
    // NOTICE !!!
    // If use button.content, button.click, the following code cam be removed.
    
    //UIButton* buttonForHidden = (UIButton*)[[layout boxById:@"hidden"] getProperty:@"view"];
    //[buttonForHidden setTitle:@"Hidden" forState:UIControlStateNormal];
    //[buttonForHidden addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIButton* buttonForCollapsed = (UIButton*)[[layout boxById:@"collapsed"] getProperty:@"view"];
    //[buttonForCollapsed setTitle:@"Collapsed" forState:UIControlStateNormal];
    //[buttonForCollapsed addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIButton* buttonForShown = (UIButton*)[[layout boxById:@"shown"] getProperty:@"view"];
    //[buttonForShown setTitle:@"Shown" forState:UIControlStateNormal];
    //[buttonForShown addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self bindText:@"Hi, Here's the prompt" withId:@"prompt"];
    [self bindText:@"This is the Error Message." withId:@"error"];
    
}

- (void)layout:(KxLayout*)layout willProcessAtStage:(KxLayoutStage)stage
{
    NSString* text = self.tappedButtonText;

    KxLayoutBox* errorBox = [layout boxById:@"error"];
    
    if ([text isEqualToString:@"Hidden"]) {
        errorBox.visibility = kHidden;
    } else if ([text isEqualToString:@"Collapsed"]) {
        errorBox.visibility = kCollapse;
    } else {
        errorBox.visibility = kVisible;
    }
}

- (void)didLayoutSubviews:(CGRect)rect withLayout:(KxLayout*)layout
{
    
}

- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout
{
    
    [layout debugPaintOutline];
}

- (void)onButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    self.tappedButtonText = [button titleForState:UIControlStateNormal];
        
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


@end
