//
//  XLayoutParser.m
//  XLayout
//
//  Created by Healer on 12-3-24.
//  Copyright (c) 2013. All rights reserved.
//

#import "KxUIXmlParser.h"

#import "KxLayout.h"
#import "KxUIDef.h"
#import "KxLayoutBox.h"
#import "KxLayoutBoxRoot.h"
#import "NSString+KxUI.h"
#import "UIColor+KxUI.h"
#import "RapidXml.h"


#define COMMA_SPLITTER			@"\\s*,\\s*"
#define UNKNOWN_REF_SOURCE		@"?"

static NSString* attribute( RapidXmlNode* xmlNode, const char* name )
{
	return [xmlNode attrValueByCName:name];
}

static CGFloat parsePercent(NSString* value)
{
    NSRange r = [value rangeOfString:@"%"];
    CGFloat percent = [[value substringToIndex:r.location] floatValue];
    return (percent / 100.0);
}

// #define xml_node_select(x)		RapidXmlNode* __RapidXmlNodeVar__ = x;
#define attr(n, x) 				attribute(n, x)
#define attr_float(n, x)		[attr(n, x) floatValue]
#define attr_percent(n, x)		parsePercent(attr(n, x))
#define attr_is_true(n, x)		[@"true" isEqualToString:attr(n, x)]

@implementation KxUIXmlParser

/*
+ (BOOL)isVertical:(NSString*)boxTag andInnerLayout:(NSString*)innerLayout
{
    if ( [@"box" isEqualToString:boxTag] && [@"vertical" isEqualToString:innerLayout] )
    {
		return YES;
    }
    else if ([@"hbox" isEqualToString:boxTag])
    {
		return NO;
    }
    else if ([@"vbox" isEqualToString:boxTag])
    {
		return YES;
    }
    return NO;
}
*/

+ (void)resolveProp:(NSString*)strProp
         withLayout:(KxLayoutBox*)layout
		 withParent:(KxLayoutBox*)parent
       siblingCount:(NSInteger)siblingCount
{
    if ( nil != parent )
    {
        if (parent.isProp)
        {
            if ( parent.isVertical )
            {
                layout.isProp = YES;
            }
            else
            {
                layout.isProp = [@"true" isEqualToString:strProp];
                if (1 == siblingCount)
                {
                    layout.isProp = YES;
                }
            }
        }
    }
    else
    {
		layout.isProp = YES;
    }
}

+ (void)parseStyles:(RapidXmlNode*)xmlNode
         withStyles:(NSMutableDictionary*)styles
 andGlobalStyleName:(NSString*)globalStyleName
{
    static UIColor *DefaultHighlightColor = nil;
    if ( !DefaultHighlightColor )
    {
        //DefaultHighlightColor = [UIColor fromString:kLayoutDefaultHighlightColor];
    }
    
    RapidXmlNode* styleNode = [xmlNode firstChild];
    
    while (styleNode)
    {
        NSString *strName = [styleNode name];
        assert(strName);
        if ( strName )
        {
            KxStyle* style = [[KxStyle alloc] init];
            NSString* name	= attr(styleNode, "name");
            NSString* strColor	= attr(styleNode, "font-color");
            NSString* strHighlight	= attr(styleNode, "font-highlight-color");
            NSString* strFontSize = attr(styleNode, "font-size");
            CGFloat fontSize = strFontSize ? [strFontSize floatValue] : 14;
            NSString* bold = attr(styleNode, "bold");
            
            style.fontSize = fontSize;
            style.isBold = [@"true" isEqualToString:bold];

            style.color = strColor ? [UIColor colorFromString:strColor] : [UIColor blackColor];
            style.highlightColor = strHighlight ? [UIColor colorFromString:strHighlight] : DefaultHighlightColor;
            
            [styles setObject:style forKey:name];
        }
        
        styleNode = [styleNode nextSibling];
    }
}

+ (void)parseMarginAndPadding:(RapidXmlNode*)xmlNode
                   withLayout:(KxLayoutBox*)box
{
    // Margin
    NSString* marginStr = attr(xmlNode, "margin");
	if (marginStr != nil)
    {
        NSArray *array = [marginStr split:COMMA_SPLITTER];
        
        box.marginTop       = [[array objectAtIndex:0] floatValue];
        box.marginRight     = [[array objectAtIndex:1] floatValue];
        box.marginBottom    = [[array objectAtIndex:2] floatValue];
        box.marginLeft      = [[array objectAtIndex:3] floatValue];
    }
    else
    {
        box.marginLeft      = attr_float(xmlNode, "margin-left");
        box.marginRight     = attr_float(xmlNode, "margin-right");
        box.marginTop       = attr_float(xmlNode, "margin-top");
        box.marginBottom	= attr_float(xmlNode, "margin-bottom");
    }
    
    // Padding
    NSString* paddingStr = attr(xmlNode, "padding");
	if (paddingStr != nil)
    {
        NSArray *array = [paddingStr split:COMMA_SPLITTER];
        
        box.paddingTop      = [[array objectAtIndex:0] floatValue];
        box.paddingRight    = [[array objectAtIndex:1] floatValue];
        box.paddingBottom   = [[array objectAtIndex:2] floatValue];
        box.paddingLeft     = [[array objectAtIndex:3] floatValue];
    }
    else
    {
        box.paddingLeft     = attr_float(xmlNode, "padding-left");
        box.paddingRight    = attr_float(xmlNode, "padding-right");
        box.paddingTop      = attr_float(xmlNode, "padding-top");
        box.paddingBottom   = attr_float(xmlNode, "padding-bottom");
    }
}

+ (void)parseTypeAttribute:(RapidXmlNode*)xmlNode
                withLayout:(KxLayoutBox*)box
                withParent:(KxLayoutBox*)parent
                  withType:(NSString*)type
{
    NSString* prefix = [type stringByAppendingFormat:@"."];
    NSDictionary* dict = [xmlNode attributesWithPrefix:prefix];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [box setProperty:obj withName:key];
    }];
    
}

+ (void)parseVisibility:(RapidXmlNode*)xmlNode
             withLayout:(KxLayoutBox*)box
             withParent:(KxLayoutBox*)parent
{
    NSString* visibilityStr = attr(xmlNode, "visibility");
    box.visibility = kVisible;  // Default
    if ([@"hidden" isEqualToString:visibilityStr])
    {
        box.visibility = kHidden;
    }
    else if ([@"collapse" isEqualToString:visibilityStr])
    {
        box.visibility = kHidden;
    }
    else if ([@"visible" isEqualToString:visibilityStr])
    {
        box.visibility = kVisible;
    }
    
    if (parent.visibility == kHidden || parent.visibility == kCollapse)
    {
        // attribute inheritance
        box.visibility = parent.visibility;
    }
}

+ (void)parseTextStyle:(RapidXmlNode*)xmlNode
            withLayout:(KxLayoutBox*)box
            withParent:(KxLayoutBox*)parent // No use, text-style can NOT be inherited
            withStyles:(NSDictionary*)styles
{
    NSString* text = attr(xmlNode, "text");
    if (text)
    {
        [box setProperty:text withName:@"text"];
    }
    
    NSString* styleName = attr(xmlNode, "style");
    if (styleName.length > 0)
    {
        box.style = (KxStyle*)[styles objectForKey:styleName];
    }
    
    // Check if style attributes exist in this box ?
    BOOL styleExists = NO;
    CGFloat fontSize = attr_float(xmlNode, "font-size");
    NSString* isBold = attr(xmlNode, "bold");
    NSString* fontColor = attr(xmlNode, "font-color");
    NSString* fontHighlightColor = attr(xmlNode, "font-highlight-color");
    
    styleExists = (fontSize > 0) || (isBold != nil) || (fontColor != nil) || (fontHighlightColor != nil);

    if (styleExists)
    {
        if (!box.style)
        {
            box.style = [[KxStyle alloc] initWithName:@""];
        }
        
        if (fontSize > 0)
        { 
            box.style.fontSize = fontSize;
        }
        
        if (isBold)
        {
            box.style.isBold = [@"true" isEqualToString:isBold];
        }
        
        if (fontColor)
        {
            box.style.color = [UIColor colorFromString:fontColor];
        }
        
        if (fontHighlightColor)
        {
            box.style.highlightColor = [UIColor colorFromString:fontHighlightColor];
        }
    }
}

+ (void)parseLayout:(RapidXmlNode*)xmlNode
         withLayout:(KxLayoutBox*)box 
		 withParent:(KxLayoutBox*)parent
         withStyles:(NSDictionary*)styles
       siblingCount:(NSInteger)siblingCount
{
    
    if (parent == nil)
    {
        box.boxRoot = (KxLayoutBoxRoot*)box;
    }
    else
    {
        box.boxRoot = parent.boxRoot;
    }
    
    // spread and vertical-spread.
    // spread is a NOT inherited attribute.
    box.isSpread = attr_is_true(xmlNode, "spread");
    box.isVerticalSpread = attr_is_true(xmlNode, "vertical-spread");
    
    box.weight = attr_percent(xmlNode, "weight");
    
    // border-xxx='N' have more Priority than border='A,B,C,D'
    [self parseMarginAndPadding:xmlNode withLayout:box];
    
    
    // Visibility
    [self parseVisibility:xmlNode withLayout:box withParent:parent];
    
    NSString* strHAlign	= attr(xmlNode, "align");
    NSString* strVAlign	= attr(xmlNode, "vertical-align");

    // Maybe no use for calculate height.
    [KxUIXmlParser resolveProp:attr(xmlNode, "prop")
                    withLayout:box
                    withParent:parent
                  siblingCount:siblingCount];
    
    NSString* background = attr(xmlNode, "background-image");
    if (background)
    {
        [box setProperty:background withName:@"background-image"];   
    }
    
    NSString* type = attr(xmlNode, "type");
    if (type)
    {
        [box setProperty:type withName:@"type"];
        [self parseTypeAttribute:xmlNode withLayout:box withParent:parent withType:type];
    }
    
    // Text and Style
    [self parseTextStyle:xmlNode withLayout:box withParent:parent withStyles:styles];
        
    // TODO: Enhancement.
    if (parent.isVertical)
    {
        NSString* sameWidthId = attr(xmlNode, "same-width");
        if (sameWidthId)
        {
            box.sizeProperty = kXLSizePropertySameWidth;
            box.sizePropertyValue = sameWidthId;
        }
    }
    else
    {
        NSString* sameHeightId = attr(xmlNode, "same-height");
        if (sameHeightId)
        {
            box.sizeProperty = kXLSizePropertySameHeight;
            box.sizePropertyValue = sameHeightId;
        }
    }
    
    // TODO: keep-border='true', false is default.
    BOOL keepBorder = attr_is_true(xmlNode, "keep-border");
    box.keepBorder = keepBorder;

    
    if ( [@"left" isEqualToString:strHAlign] )
    {
        box.align = kXLAlignLeft;
    }
    else if ( [@"right" isEqualToString:strHAlign] )
    {
        box.align = kXLAlignRight;
    }
    else if ( [@"center" isEqualToString:strHAlign] )
    {
        box.align = kXLAlignCenter;
    }
    
    if ( [@"top" isEqualToString:strVAlign] )
    {
        box.verticalAlign = kXLAlignTop;
    }
    else if ( [@"bottom" isEqualToString:strVAlign] )
    {
        box.verticalAlign = kXLAlignBottom;
    }
    else if ( [@"center" isEqualToString:strVAlign] )
    {
        box.verticalAlign = kXLAlignCenter;
    }
    
    NSString *strWidth	= attr(xmlNode, "width");
    NSString *strHeight	= attr(xmlNode, "height");
    
    // children.
    NSString* refSource = attr(xmlNode, "ref-src");
    BOOL hasRef = [refSource length] > 0;
    box.hasRef = hasRef;
    if ( hasRef )
    {
        // TODO: assert no children.
        if ( refSource )
        {
            if ([UNKNOWN_REF_SOURCE isEqualToString:refSource])
            {
                return;
            }
            box.refSource = refSource;
            NSData* xmlData = [KxLayout loadXml:refSource];
            KxLayoutBoxRoot *root = [KxLayout parse:xmlData];
            box.subBoxCount = 1;
            [box addSubBox:root];
            // Ref Source Name is namespace.
            [root addNamespace:box.identifier];
            return;
        }
        assert(false);
    }
    else // No Referenced XLayout Xml.
    {
        NSInteger subBoxCount = [xmlNode childCount];
        box.subBoxCount = subBoxCount;
        if ( 0 == subBoxCount )
        {
            // Deal with attributes only for Leaf-box.
            // Min and Max Value
            box.minWidth	 = attr_float(xmlNode, "min-width");
            box.minHeight = attr_float(xmlNode, "min-height");
            
            NSString *strMaxWidth	= attr(xmlNode, "max-width");
            box.maxWidth = strMaxWidth ? [strMaxWidth floatValue] : MAXFLOAT;
            NSString *strMaxHeight	= attr(xmlNode, "max-height");
            box.maxHeight = strMaxHeight ? [strMaxHeight floatValue] : MAXFLOAT;
            
            // Width & Height
            if ( strWidth.length > 0 ) box.widthAttr = [strWidth floatValue];
            if ( strHeight.length > 0 ) box.heightAttr = [strHeight floatValue];
            
            NSString *contentAlign = attr(xmlNode, "content-align");
            NSString *contentVerticalAlign = attr(xmlNode, "content-vertical-align");
            if (contentAlign)
            {
            	if ([contentAlign isEqualToString:@"left"])
                {
                    box.contentAlign = kXLAlignLeft;
                }
                else if ([contentAlign isEqualToString:@"right"])
                {
                    box.contentAlign = kXLAlignRight;                    
                }
                else if ([contentAlign isEqualToString:@"center"])
                {
                    box.contentAlign = kXLAlignCenter;
                }
            }
            if (contentVerticalAlign)
            {
            	if ([contentVerticalAlign isEqualToString:@"top"])
                {
                    box.contentVerticalAlign = kXLAlignTop;
                }
                else if ([contentVerticalAlign isEqualToString:@"bottom"])
                {
                    box.contentVerticalAlign = kXLAlignBottom;
                }
                else if ([contentVerticalAlign isEqualToString:@"center"])
                {
                    box.contentVerticalAlign = kXLAlignCenter;
                }
            }  
            return;
        }
        else
        {
            // Width & Height
            if ( strWidth.length > 0 ) box.widthAttr = [strWidth floatValue];
            if ( strHeight.length > 0 ) box.heightAttr = [strHeight floatValue];
        }

        RapidXmlNode* childXmlNode = [xmlNode firstChild];
        while (nil != childXmlNode)
        {
            NSString* boxTag = [childXmlNode name];
            NSString* identifier = [childXmlNode attrValueByName:@"id"];
            
            // NSString* innerLayout = [xml findAttribFrom:childXmlElem attribname:@"inner-layout"];
        	// TODO:
            BOOL vertical = [@"vbox" isEqualToString:boxTag];
            
            KxLayoutBox *subBox = [[KxLayoutBox alloc] init:identifier 
                                                isVertical:vertical];
            [self parseLayout:childXmlNode 
                   withLayout:subBox 
                   withParent:box
                   withStyles:styles
                 siblingCount:subBoxCount];
            
            // When Parent's id is null, its name is as [ sub-bix-id, ...];
            if ( !box.nameSet )
            {
                NSString *boxName = nil;
                NSString *subBoxId = subBox.identifier ? subBox.identifier : @"<EMPTY>";
                if (subBoxCount > 1)
                {
                    boxName = [NSString stringWithFormat:@"[%@,<OTHER>]", subBoxId];
                }
                else
                {
                    boxName = [NSString stringWithFormat:@"[%@]", subBoxId];
                }
                box.name = boxName;
            }
            
            [box addSubBox:subBox];
            childXmlNode = [childXmlNode nextSibling];
        }
    }
}

// For Global style
+ (KxStyle*)parseStyle:(NSData*)content
{
	assert(content);
	KxStyle* style = nil;
    
    return style;
}

+ (KxLayoutBoxRoot*)parse:(NSData*)content
{
    if (content == nil)
        return nil;
    
    RapidXml* xml = [[RapidXml alloc] initWithData:content];
    if (nil == xml)
        return nil;
    
    RapidXmlNode* xmlRoot = [xml root];
    // Assert Root MUST be <ui>
    if ([@"ui" compare:[xmlRoot name]] == 0)
    {
	    KxLayoutBoxRoot* root = nil;
		NSMutableDictionary* styles = [NSMutableDictionary dictionary];
        
        RapidXmlNode* node = [xmlRoot firstChild];

        if ([@"styles" compare:[node name]] == 0)
        {
			NSString* globalStyleName = [node attrValueByName:@"use"];
        	[KxUIXmlParser parseStyles:node withStyles:styles andGlobalStyleName:globalStyleName];
            
            // Next Sibling for Layout tag.
        	node = [node nextSibling];
        }
        

		// NSString* name = [node name];
        if ([@"layout" compare:[node name]] == 0)
        {
	        RapidXmlNode* boxNode = [node firstChild];
            NSString* boxTag = [boxNode name];
        	NSString* identifier = attr(boxNode, "id");
            
     		// TODO:!
            BOOL vertical = [@"vbox" isEqualToString:boxTag];
			
           	root = [[KxLayoutBoxRoot alloc] init:identifier
                                      isVertical:vertical];
            [KxUIXmlParser parseLayout:boxNode
                            withLayout:root
                            withParent:nil
                            withStyles:styles
                          siblingCount:1];
            return root;
        }

    }
    return nil;
}

@end
