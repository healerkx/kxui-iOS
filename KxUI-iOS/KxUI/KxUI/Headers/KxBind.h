//
//  XBind.h
//  XLayout
//
//  Created by Zhongmin Yu on 12-4-2.
//  Copyright (c) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    EXBindNone = 0,
    EXBindText,
    EXBindIcon,
    EXBindIconNoHighlight,
    EXBindView
}
KxBindType;



@interface KxBind : NSObject
{
    NSString*			_identifier;
    id              	_userInfo;
	id					_value;
    id					__weak _target;
    SEL					_action;
    KxBindType			_type;
    
    void(^bindHandler)(KxBind *bind);
}

@property (nonatomic, strong) id				value;
@property (nonatomic, weak) id                  target;
@property (nonatomic, assign) SEL				action;
@property (nonatomic, assign) KxBindType		type;
@property (nonatomic, strong) id                userInfo;
@property (nonatomic, strong) NSString*			identifier;

- (id)initWithId:(NSString*)identifier;
- (void)addTarget:(id)target action:(SEL)action;
- (void)addTarget:(id)target action:(SEL)action userInfo:(id)userInfo;
- (void)addHandler:(void(^)(KxBind *bind))handler;
@end



////////////////////////////////////////////////////////////////////////////////

@interface XBindProperty : NSObject
{
    NSString			*_name;
	id					_value;
}
@property (nonatomic, strong) id				value;
@property (nonatomic, strong) NSString			*name;

- (id)initWithName:(NSString*)propertyName;
@end
