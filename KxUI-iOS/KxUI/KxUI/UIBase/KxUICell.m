//
//  XLayoutUICellCell.m
//  XLayout
//
//  Created by Healer on 12-4-1.
//  Copyright (c) 2012年. All rights reserved.
//

#import "KxUICell.h"
#import "KxLayoutResult.h"
#import "KxUIBase.h"
#import "KxUIDef.h"

@interface KxUICell()

@end

@implementation KxUICell


// Virtual {{
- (void)managedSubviewsReady:(BOOL)ready withLayout:(KxLayout*)layout{}
- (void)didBindData:(id)data{}
- (void)didRefQuery:(KxUIQueryWithBind*)query withLayout:(KxLayout*)layout{}
- (void)didQuery:(KxUIQueryWithBind*)query withLayout:(KxLayout*)layout{}
- (void)layout:(KxLayout*)layout willProcessAtStage:(KxLayoutStage)stage{}
- (void)didLayoutSubviews:(CGRect)rect withLayout:(KxLayout*)layout{}
- (void)didDrawBackground:(CGRect)rect withLayout:(KxLayout*)layout{}
- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout{}
// Virtual }}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
		_base = [[KxUIBase alloc] initWithHostView:self];
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

- (NSArray*)binds
{
    return self.base.binds;
}

// Cell only
- (void)bindAtIndexPath:(NSIndexPath*)indexPath withDelegate:(id<KxUIBindDataDelegate>)delegate whenCalculateHeight:(BOOL)whenCalculateHeight
{
    [self clearBinds];
    [delegate bindLayoutCell:self atIndexPath:indexPath whenCalculateHeight:whenCalculateHeight];
}

- (void)bindAtIndexPath:(NSIndexPath*)indexPath withDelegate:(id<KxUIBindDataDelegate>)delegate
{
    [self bindAtIndexPath:indexPath withDelegate:delegate whenCalculateHeight:NO];
}


- (void)layoutSubviews
{
    [super layoutSubviews];

	CGRect rect = self.contentView.bounds;
    [self.base layoutContentView:rect];
    [self setNeedsDisplay];
}

- (void)didDrawBindText:(KxBind*)bind withLayout:(KxLayout*)layout
{
    NSString *text = (NSString*)bind.value;
    KxLayoutBox *box = [layout boxById:bind.identifier];
    UIFont* font = box.style.font ? box.style.font : DefaultFont;
    if (self.highlighted)
    {
        if (box.style.highlightColor)
            [box.style.highlightColor set];
        else
            [[UIColor whiteColor] set];
    }
    else
    {
        if (box.style.color)
            [box.style.color set];
        else
            [[UIColor blackColor] set];
    }
    CGRect rect = [box toRect];
    CGSize size = [text sizeWithFont:font constrainedToSize:rect.size];
    rect.origin.y += (CGRectGetHeight(rect) - size.height)/2;
    [text drawInRect:rect withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:[box textAlignment]];
}

- (void)didDrawBindIcon:(KxBind*)bind withLayout:(KxLayout*)layout supportHighlight:(BOOL)supportHighlight
{
    UIImage *icon = (UIImage*)bind.value;
    KxLayoutBox *box = [layout boxById:bind.identifier];

    CGRect imageRect = [box toRect];
    
    // imageRect.origin.y += (CGRectGetHeight(imageRect) - icon.size.height) / 2;
    // imageRect.origin.x += (CGRectGetWidth(imageRect) - icon.size.width) / 2;

    // imageRect.size = icon.size;
    
    if (self.highlighted && supportHighlight)
    {
        //[[icon imageWithColor:[UIColor whiteColor]] drawInRect:imageRect];
    }
    else
    {
        [icon drawInRect:imageRect];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawContentView:rect];
}

- (void)drawContentView:(CGRect)rect
{
    [self.base drawContentView:rect];
}

// 
// When calculate a cell's height, the cell instance has not been created.
+ (CGFloat)calculateHeightAtIndexPath:(NSIndexPath*)indexPath
                            withWidth:(CGFloat)width 
                         withDelegate:(id<KxUIBindDataDelegate>)delegate
{
    // Force Inheritance
    assert( [self class] != kKxUICellClass );
    
    // Virtual Cell and Virtual Cell's Cache.
    static NSMutableDictionary* virtualCellDict = nil;
    if ( nil == virtualCellDict)
    {
        virtualCellDict = [NSMutableDictionary dictionary];
    }
    
    Class recvClz = [self class];
    KxUICell *virtualCell = [virtualCellDict objectForKey:recvClz];
    if  ( !virtualCell )
    {
        virtualCell = [[recvClz alloc] init];
        [virtualCellDict setObject:virtualCell forKey:(id)recvClz];
    }
	// Height?
    CGFloat height = [virtualCell.base calculateHeightWithCell:virtualCell 
                                                   AtIndexPath:indexPath 
                                                     withWidth:width 
                                                  withDelegate:delegate];
    return height;
}


// Bind and Hide
- (KxBind*)bindText:(NSString*)text forId:(NSString*)identifier
{
    return [self.base bindText:text withId:identifier];
}

- (KxBind*)bindIcon:(UIImage*)icon forId:(NSString*)identifier
{
    return [self.base bindIcon:icon withId:identifier];
}

- (KxBind*)bindView:(id)view forId:(NSString*)identifier
{
	return [self.base bindView:view withId:identifier];
}

- (void)setBoxVisibility:(NSInteger)visibility forId:(NSString*)identifier
{
    [self.base setBoxVisibility:visibility forId:identifier];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.base touchesBegan:touches withEvent:event theView:self];
    [super touchesBegan:touches withEvent:event];
}


@end
