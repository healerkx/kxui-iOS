//
//  EditorView.m
//  KxUITest
//
//  Created by Zhongmin Yu on 6/14/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "EditorView.h"
#import "KxUIView.h"
#import "KxLayout+Debug.h"
#import <QuartzCore/QuartzCore.h>

@interface DemoView : KxUIView
@property (strong) KxLayout* layout;
@end

@implementation DemoView

- (id)init
{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    return  self;
}

- (void)updateLayout:(NSString*)layoutXml
{
    NSData* data = [layoutXml dataUsingEncoding:NSUTF8StringEncoding];
    
    [self setLayoutXml: data];
    
    [self performSelector:@selector(resetManagedSubviews)];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
}

- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout *)layout
{
    
    [layout debugPaintOutline];
}

@end


@interface EditorView()
@property (strong) DemoView*    demoPaneView;
@property (strong) UITextView*  uiXmlTextView;
@property (strong) UIButton*    updateButton;
@end

@implementation EditorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.layoutName = @"editor";
        
        self.demoPaneView = [[DemoView alloc] init];
        [self addSubview:self.demoPaneView];
        
        self.uiXmlTextView = [[UITextView alloc] init];
        self.uiXmlTextView.scrollEnabled = YES;
        self.uiXmlTextView.layer.borderWidth = 1.0f;
        self.uiXmlTextView.layer.borderColor = [[UIColor grayColor] CGColor];
        
        [self addSubview:self.uiXmlTextView];
        
        
        NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString* fileName = @"ui/yahoo-signin.ui";
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@", bundlePath, fileName];
        
        NSData* data = [NSData dataWithContentsOfFile:fullPath];

        //
        NSString* content = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        self.uiXmlTextView.text = content;
        
        
        self.updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.updateButton setTitle:@"Update" forState:UIControlStateNormal];
        [self.updateButton addTarget:self action:@selector(updateButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.updateButton];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)didLayoutSubviews:(CGRect)rect withLayout:(KxLayout*)layout
{
    self.demoPaneView.frame = [[layout boxById:@"pane"] toRect];
    self.uiXmlTextView.frame = [[layout boxById:@"text"] toRect];
    self.updateButton.frame = [[layout boxById:@"update"] toRect];
}

- (void)updateButtonTap:(id)sender
{
    NSString* text = self.uiXmlTextView.text;
    [self.demoPaneView updateLayout:text];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect r = self.frame;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    r.size.height -= MIN(kbSize.height, kbSize.width);
    self.frame = r;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect r = self.frame;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    r.size.height += MIN(kbSize.height, kbSize.width);
    self.frame = r;
}

@end
