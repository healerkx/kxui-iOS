//
//  WidgetsFactory.m
//  KxUI
//
//  Created by Zhongmin Yu on 6/25/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "WidgetsFactory.h"
#import "KxLayoutBox.h"

@interface WidgetsFactory()

@property (strong) NSMutableDictionary* widgetTypeDict;
@end

@implementation WidgetsFactory

+ (WidgetsFactory*)sharedFactory
{
    static WidgetsFactory* factory = nil;
    if (!factory)
    {
        factory = [[WidgetsFactory alloc] init];
    }

    return factory;
}

- (BOOL)registerWidgetType:(Class)clz forName:(NSString*)typeName
{
    [self.widgetTypeDict setObject:clz forKey:typeName];
    return true;
}


- (UIView*)viewByType:(NSString*)type withLayoutBox:(KxLayoutBox*)box withHostView:(UIView*)hostView
{
    UIView* view = nil;
    if ([@"button" isEqualToString:type]) {
        view = [self buttonWithLayoutBox:box withHostView:hostView];
    } else if ([@"textbox" isEqualToString:type]) {
        view = [self fieldWithLayoutBox:box asPasswordField:NO];
    } else if ([@"password" isEqualToString:type]) {
        view = [self fieldWithLayoutBox:box asPasswordField:YES];
    }
    
    Class clz = [self.widgetTypeDict objectForKey:type];
    if (clz != nil)
    {
        id object = [clz alloc];
        view = (UIView*)[object performSelector:@selector(initWithLayoutBox:) withObject:box];

    }
    
    [hostView addSubview:view];
    return view;
}

// TODO: Need Refactor...
- (UIImage*)imageByPath:(NSString*)imageFileName
{
    NSString* imgPath = @"";
    if ([imageFileName hasSuffix:@".jpg"])
        imgPath = [[NSBundle mainBundle] pathForResource:imageFileName ofType:@"jpg"];
    else
        imgPath = [[NSBundle mainBundle] pathForResource:imageFileName ofType:@"png"];
    
    UIImage* image = [UIImage imageWithContentsOfFile:imgPath];
    return image;
}

- (UIButton*)buttonWithLayoutBox:(KxLayoutBox*)box withHostView:(UIView*)hostView
{
    UIButton* button = nil;
    NSString* imageName = [box getProperty:@"button.image"];
    if (imageName)
    {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage* normalImage = [self imageByPath:imageName];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    else
    {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    
    NSString* buttonText = [box getProperty:@"button.content"];
    [button setTitle:buttonText forState:UIControlStateNormal];

    NSString* buttonHandler = [box getProperty:@"button.click"];
    SEL handler = NSSelectorFromString(buttonHandler);
    [button addTarget:hostView action:handler forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = [box toRect];
    return button;
}

- (UITextField*)fieldWithLayoutBox:(KxLayoutBox*)box asPasswordField:(BOOL)isPassword
{
    UITextField* field = [[UITextField alloc] init];
    field.secureTextEntry = isPassword;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    // field using padding to layout the widget, and margin for the Text-field's background image.
    field.frame = [box paddingRect];
    return field;
}

@end
