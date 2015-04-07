//
//  XBind.m
//  XLayout
//
//  Created by Zhongmin Yu on 12-4-2.
//  Copyright (c) 2013. All rights reserved.
//

#import "KxBind.h"

@implementation KxBind
@synthesize identifier 	= _identifier;
@synthesize value		= _value;
@synthesize target 		= _target;
@synthesize action      = _action;
@synthesize type		= _type;
@synthesize userInfo    = _userInfo;


- (id)initWithId:(NSString*)identifier
{
    self = [super init];
    self.identifier = identifier;
    bindHandler = nil;
    return self;
}

- (void)addHandler:(void(^)(KxBind *bind))handler
{
    bindHandler = [handler copy];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)addTarget:(id)target action:(SEL)action userInfo:(id)userInfo
{
    self.target = target;
    self.action = action;
    self.userInfo = userInfo;
}

@end



@implementation XBindProperty
@synthesize name	 	= _name;
@synthesize value		= _value;

- (id)initWithName:(NSString*)propertyName
{
    self = [super init];
    self.name = propertyName;
    return self;
}

@end
