//
//  KxUIView.m
//  KxUIView
//
//  Created by Healer on 12-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import "KxUIView.h"
#import "KxLayout.h"
#import "KxUIQueryWithBind.h"
#import "KxBind.h"
#import "KxUIBase.h"
#import "KxUIDef.h"

@interface KxUIView()

@property (nonatomic, strong)	KxUIBase*   base;

@end


@implementation KxUIView

// Virtual {{
- (void)managedSubviewsReady:(BOOL)ready withLayout:(KxLayout*)layout{}

- (void)didBindData:(id)data{}
- (void)layout:(KxLayout*)layout willProcessAtStage:(KxLayoutStage)stage{}
- (void)didRefQuery:(KxUIQueryWithBind*)query withLayout:(KxLayout*)layout{}
- (void)didQuery:(KxUIQueryWithBind*)query withLayout:(KxLayout*)layout{}
- (void)didLayoutSubviews:(CGRect)rect withLayout:(KxLayout*)layout{}

- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout{}
// Virtual }}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		self.base = [[KxUIBase alloc] initWithHostView:self];
    }
    return self;
}

- (void)setLayoutName:(NSString*)layoutName
{
    self.base.layoutName = layoutName;
}

- (NSString*)layoutName
{
    return self.base.layoutName;
}

- (void)setLayoutXml:(NSData*)layoutXml
{
    self.base.layoutXmlData = layoutXml;
}

- (void)resetManagedSubviews
{
    [self.base performSelector:@selector(resetManagedSubviews)];
}

- (void)clearBinds
{
    [self.base clearBinds];
}

////////////////////////////////////////////////////////////////////////////////
// Draw Logic in View or Cell.
// <XLayoutDelegate>
- (void)didDrawBindText:(KxBind*)bind withLayout:(KxLayout*)layout
{
    NSString *text = (NSString*)bind.value;
    KxLayoutBox *box = [layout boxById:bind.identifier];

    if (box.style)
        [box.style.color set];
    else
        [[UIColor blackColor] set];
    
    UIFont* font = box.style.font ? box.style.font : DefaultFont;
    
    CGRect rect = [box toRect];
    CGSize size = [text sizeWithFont:font constrainedToSize:rect.size];
    // Text default align to the bottom-left corner.
    rect.origin.y += (CGRectGetHeight(rect) - size.height)/2;

    UITextAlignment align = [box textAlignment];
    [text drawInRect:rect withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:align];
}

// <XLayoutDelegate>
- (void)didDrawBindIcon:(KxBind*)bind withLayout:(KxLayout*)layout supportHighlight:(BOOL)supportHighlight
{
    UIImage *icon = (UIImage*)bind.value;
    KxLayoutBox *box = [layout boxById:bind.identifier];
    
    CGRect imageRect = [box toRect];
    
    imageRect.origin.y += (CGRectGetHeight(imageRect) - icon.size.height)/2;
    imageRect.origin.x += (CGRectGetWidth(imageRect) - icon.size.width)/2;
    
    imageRect.size = icon.size;
    
    [icon drawInRect:imageRect];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.base drawContentView:rect];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    [self.base layoutContentView:rect];
}


// Bind and Hide
- (KxBind*)bindText:(NSString*)text withId:(NSString*)identifier
{
    return [self.base bindText:text withId:identifier];
}

- (KxBind*)bindIcon:(UIImage*)icon withId:(NSString*)identifier
{
    return [self.base bindIcon:icon withId:identifier];
}

- (KxBind*)bindView:(id)view withId:(NSString*)identifier
{
	return [self.base bindView:view withId:identifier];
}

- (void)setBoxVisibility:(NSInteger)visibility forId:(NSString*)identifier
{
    // [self.base hideBox:hide withId:identifier];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.base touchesBegan:touches withEvent:event theView:self];
    [super touchesBegan:touches withEvent:event];
}

@end
