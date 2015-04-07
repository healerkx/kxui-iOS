//
//  YahooSignInView.m
//  KxUITest
//
//  Created by Zhongmin Yu on 5/30/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "YahooSignInView.h"
#import "KxUIView.h"
#import "KxLayout+Debug.h"


@interface YahooSignInView()

@property (assign) BOOL             showGridLines;
@property (strong) UITextField*     usernameField;
@property (strong) UITextField*     passwordField;
@property (strong) UIButton*        submitButton;

@end

/*
 * This View demo How to build Yahoo SignIn View
 * And how to adapter to 3.5-inch and 4-inch screen.
 */
@implementation YahooSignInView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:249.0/255 alpha:1.0];

        self.layoutName = @"yahoo-signin";
        self.showGridLines = NO;
        
    }
    return self;
}

- (void)didLayoutSubviews:(CGRect)rect withLayout:(KxLayout*)layout
{
    UITextField* usernameField = (UITextField*)[[layout boxById:@"username"] getProperty:@"view"];
    usernameField.text = @"Healer";
    
    UITextField* passwordField = (UITextField*)[[layout boxById:@"password"] getProperty:@"view"];
    passwordField.text = @"123456";
}

- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout
{
    if (self.showGridLines)
    {
        [layout debugPaintOutline];
    }
}

- (void)onSignIn:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Sign In Clicked"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)onCreateAccount:(id)sender
{
    // switch the outline.
    self.showGridLines = !self.showGridLines;
    [self setNeedsDisplay];
}

// For Hide the keyboard only.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
