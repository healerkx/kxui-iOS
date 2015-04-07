//
//  XLayout+Debug.m
//  XLayout
//
//  Created by Zhongmin Yu.
//  Copyright (c) 2013. All rights reserved.
//

#import "KxLayout+Debug.h"
#import "KxUIDef.h"

static void drawBoxDashLine(CGContextRef context, CGRect rect, CGColorRef color)
{
    CGFloat lengths[] = { 5, 5 };
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(context, color);
    
    rect = CGRectInset(rect, 1.0, 1.0);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathStroke);
}

static void drawBoxRect(CGContextRef context, CGRect rect, CGColorRef color)
{
    CGContextSetFillColorWithColor(context, color);
    rect = CGRectInset(rect, 1.0, 1.0);
    CGContextFillRect(context, rect);
}

static void drawBoxOutline(CGContextRef context, CGRect layoutRect, CGRect boxRect)
{
    static CGColorRef LayoutColor = nil;
    if ( !LayoutColor )
        LayoutColor = [UIColor lightGrayColor].CGColor;
    static CGColorRef Gray = nil;
    if ( !Gray )
        Gray =[UIColor blueColor].CGColor;
    
    drawBoxDashLine(context, layoutRect, LayoutColor);
    drawBoxDashLine(context, boxRect, Gray);
}

@implementation KxLayout(Debug)
////////////////////////////////////////////////////////////////////////////////
- (void)_debugPrintSize:(KxLayoutBox*)box andDeep:(NSInteger)deep
{
    //NSString *ident = [spaces substringToIndex:deep];
   // Logger(@"%@%@:{ %.1f, %.1f }", ident, box.identifier, box.widthAttr, box.heightAttr);
    int c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox *subBox = [box subBox:i];
        [self _debugPrintSize:subBox andDeep:deep + 1];
        
    }
}

- (void)_debugPrintSize
{
    [self _debugPrintSize:_root andDeep:0];
}
////////////////////////////////////////////////////////////////////////////////
- (void)_debugPrintRect:(KxLayoutBox*)box andDeep:(NSInteger)deep
{
//    NSString *ident = [spaces substringToIndex:deep];
    //CGRect rect = [box toRect];
   // Logger(@"%@%@: %@", ident, box.identifier, NSStringFromCGRect(rect)  );
    int c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox *subBox = [box subBox:i];
        [self _debugPrintRect:subBox andDeep:deep + 1];
    }
}

- (void)_debugPrintRect
{
    [self _debugPrintRect:_root andDeep:0];
}
////////////////////////////////////////////////////////////////////////////////
- (void)_debugCheckSize:(NSMutableArray*)array withBox:(KxLayoutBox*)box
{
    if ( !box.widthAttrSet || !box.heightAttrSet )
    {
        if (box.visibility != kCollapse)
        {
            [array addObject:box];
        }
    }
    
    int c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox *subBox = [box subBox:i];
        // Logger(@"%@", subBox.identifier);
        [self _debugCheckSize:array withBox:subBox];
    }
}

- (NSMutableArray*)_debugCheckSize
{
    NSMutableArray *array = [NSMutableArray array];
    [self _debugCheckSize:array withBox:_root];
    return array;
}



////////////////////////////////////////////////////////////////////////////////
- (void)_debugPaintBox:(KxLayoutBox*)box withContext:(CGContextRef)context withDeep:(NSInteger)deep
{
    UIColor *colors[] =	{	
        [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1], 
        [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1],
        [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1],
        [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1],
        [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1],
        [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1],
        [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1],
        [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]
    };
    
    CGRect layoutRect = [box toLayoutRect];
    CGRect boxRect = [box toRect];
    
	CGColorRef color = colors[deep].CGColor;
    drawBoxDashLine(context, layoutRect, color);
    drawBoxRect(context, boxRect, color);
    
    [[UIColor redColor] set];
    CGFloat smallFontSize = [UIFont smallSystemFontSize];
    [box.identifier drawInRect:CGRectInset(boxRect, 3.0, 1.0) withFont:[UIFont systemFontOfSize:smallFontSize]];
}

- (void)_debugPaintRect:(KxLayoutBox*)box withContext:(CGContextRef)context withDeep:(NSInteger)deep
{
    [self _debugPaintBox:box withContext:context withDeep:deep];
    int c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox *subBox = [box subBox:i];
        if (subBox.visibility != kCollapse)
        {
            [self _debugPaintRect:subBox withContext:context withDeep:(deep + 1)];
        }
    }    
}

- (void)_debugPaintRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
	{
        [self _debugPaintRect:_root withContext:context withDeep:0];
    }
    CGContextRestoreGState(context);
}

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
- (void)_debugPaintOutline:(KxLayoutBox*)box withContext:(CGContextRef)context
{
    CGRect layoutRect = [box toLayoutRect];
    CGRect boxRect = [box toRect];
    drawBoxOutline(context, layoutRect, boxRect);
}

- (void)_debugPaintOutline:(KxLayoutBox*)box withContext:(CGContextRef)context withDeep:(NSInteger)deep
{
    [self _debugPaintOutline:box withContext:context];
    int c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox *subBox = [box subBox:i];
        if (subBox.visibility != kCollapse)
        {
            [self _debugPaintOutline:subBox withContext:context withDeep:(deep + 1)];
        }
    }    
}

- (void)debugPaintOutline
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
	{
        [self _debugPaintOutline:_root withContext:context withDeep:0];
    }
    CGContextRestoreGState(context);
}

@end
