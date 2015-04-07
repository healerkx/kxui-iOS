//
//  XLayoutBox.m
//  XLayout
//
//  Created by Zhongmin Yu
//  Copyright (c) 2013. All rights reserved.
//

#import "KxLayoutBox.h"
#import "KxLayoutBoxRoot.h"
#import "KxLayout.h"
#import "KxUIDef.h"

@interface KxLayoutBox()
{
    NSMutableArray*		_subBoxes;
}

@end


@implementation KxLayoutBox

@synthesize isProp			= _isProp;
@synthesize isVertical		= _isVertical;

@synthesize hasRef			= _hasRef;

@synthesize nameSet			= _nameSet;
@synthesize keepBorder		= _keepBorder;

@synthesize align			= _align;
@synthesize verticalAlign	= _verticalAlign;
@synthesize contentAlign	= _contentAlign;
@synthesize contentVerticalAlign	
							= _contentVerticalAlign;

@synthesize	sizeProperty	= _sizeProperty;
@synthesize	sizePropertyValue	
							= _sizePropertyValue;

@synthesize subBoxCount		= _subBoxCount;

@synthesize weight			= _weight;

@synthesize widthAttrSet	= _widthAttrSet;
@synthesize heightAttrSet	= _heightAttrSet;
@synthesize widthAttr		= _widthAttr;
@synthesize heightAttr		= _heightAttr;

@synthesize minWidth		= _minWidth;
@synthesize minHeight		= _minHeight;
@synthesize maxWidth		= _maxWidth;
@synthesize maxHeight		= _maxHeight;

@synthesize namespace		= _namespace;
@synthesize name			= _name;
@synthesize refSource		= _refSource;
@synthesize style			= _style;


- (KxLayoutBox*)init:(NSString*)name isVertical:(BOOL)vertical
{
    self = [super init];
    _nameSet = NO;
    if (name)
    {
        assert([name rangeOfString:@"."].location == NSNotFound);
        self.name = name;
        _nameSet = YES;
    }
    else
    {
        self.name = @"<EMPTY>";
    }
    self.keepBorder = NO;
    self.align = kXLAlignLeft;
    self.contentAlign = kXLAlignLeft;
    self.contentVerticalAlign = kXLAlignCenter;
    self.verticalAlign = kXLAlignTop;
    self.subBoxCount = 0;
    self.isVertical = vertical;
    self.sizeProperty = kXLSizePropertyNone;
    return self;
}

// get box id, if the box is referenced by other ui file, it's id would starts with namespace.
- (NSString*)identifier
{
    if ( nil != _namespace )
    {
        return [NSString stringWithFormat:@"%@.%@", _namespace, _name];
    }
    return _name;
}


- (void)duplicateSubBox:(KxLayoutBox*)box withZone:(NSZone *)zone
{
    int count = [box subBoxCount];
    for (int i = 0; i < count; ++i)
    {
        KxLayoutBox *subBox = [[box subBox:i] copy];
        [self addSubBox:subBox];
    }
}

- (void)duplicateMembers:(KxLayoutBox*)box withZone:(NSZone*)zone
{
    // nameSet would NOT be copy;
    self.isSpread		= box.isSpread;
    self.isVerticalSpread
                        = box.isVerticalSpread;
    self.visibility     = box.visibility;
    self.isProp			= box.isProp;
    self.weight			= box.weight;
    self.namespace		= box.namespace;
    self.keepBorder		= box.keepBorder;

    self.align			= box.align;
    self.verticalAlign	= box.verticalAlign;
    self.contentAlign	= box.contentAlign;
    self.contentVerticalAlign
                        = box.contentVerticalAlign;
    self.subBoxCount	= box.subBoxCount;
    self.style			= box.style;
    
    self.sizeProperty	= box.sizeProperty;
    self.sizePropertyValue = box.sizePropertyValue;
    
    self.refSource		= box.refSource;
    self.hasRef			= box.hasRef;

    self.minHeight		= box.minHeight;
    self.maxHeight		= box.maxHeight;
    self.minWidth		= box.minWidth;
    self.maxWidth		= box.maxWidth;

    self.marginTop		= box.marginTop;
    self.marginBottom	= box.marginBottom;
    self.marginLeft		= box.marginLeft;
    self.marginRight	= box.marginRight;
    
    self.paddingTop		= box.paddingTop;
    self.paddingBottom	= box.paddingBottom;
    self.paddingLeft	= box.paddingLeft;
    self.paddingRight	= box.paddingRight;
    [self duplicateSizeAttr:box];
}

- (void)duplicateSizeAttr:(KxLayoutBox*)box
{
    if (box.widthAttrSet)
    {
        self.widthAttr = box.widthAttr;
        _widthAttrSet = YES;
    }
    if (box.heightAttrSet)
    {
    	self.heightAttr = box.heightAttr;
        _heightAttrSet = YES;
    }
}

- (id)copyWithZone:(NSZone*)zone
{
    KxLayoutBox *box = [[KxLayoutBox alloc] init:self.name isVertical:self.isVertical];
    box.boxRoot = self.boxRoot;
    [box duplicateMembers:self withZone:zone];
    if ( nil != _subBoxes )
    {
        [box duplicateSubBox:self withZone:zone];
    }
    return box;
}

- (void)setWidthAttr:(CGFloat)widthAttr
{
    _widthAttrSet = YES;
    _widthAttr = widthAttr;
    if ( 0 == self.subBoxCount )
    {
        _widthAttr = MAX(_widthAttr, _minWidth);
    	_widthAttr = MIN(_widthAttr, _maxWidth);
    }
    if (_widthAttr == float_zero && !self.keepBorder)
    {
        self.marginLeft = 0.0f;
        self.marginRight = 0.0f;
    }
}

- (void)setHeightAttr:(CGFloat)heightAttr
{
    _heightAttrSet = YES;
    _heightAttr = heightAttr;
    if ( 0 == self.subBoxCount )
    {
        _heightAttr = MAX(_heightAttr, _minHeight);
    	_heightAttr = MIN(_heightAttr, _maxHeight);
    }
    if (_heightAttr == float_zero && !self.keepBorder)
    {
        self.marginTop = 0.0f;
        self.marginBottom = 0.0f;
    }
}

- (void)addSubBox:(KxLayoutBox*)box
{
    if ( nil == _subBoxes )
    {
        _subBoxes = [NSMutableArray array];
    }
	[_subBoxes addObject:box];
}

- (void)addNamespace:(NSString*)namespace
{
    assert( nil != namespace );
	if ( nil != self.namespace )
    {
        self.namespace = [NSString stringWithFormat:@"%@.%@", namespace, self.namespace];
    }
    else 
    {
    	self.namespace = namespace;
    }
    
    const int subBoxCount = self.subBoxCount;
    if ( subBoxCount > 0 )
    {
        for (int i = 0; i < subBoxCount; ++i)
        {
            KxLayoutBox *subBox = [self subBox:i];
            [subBox addNamespace:namespace];
        }
    }
}

- (int)subBoxCount
{
    return _subBoxCount;
}

- (KxLayoutBox*)subBox:(NSInteger)index
{
    return [_subBoxes objectAtIndex:index];
}

- (KxLayoutBox*)boxById:(NSString*)identifier withRecursion:(BOOL)recursion
{
    int count = [self subBoxCount];
    for (int i = 0; i < count; ++i)
    {
        KxLayoutBox *subBox = [self subBox:i];
        if ( !subBox.nameSet )
            continue;
        NSString *boxId = subBox.identifier;
        if ( [identifier isEqualToString:boxId] )
        {
            return subBox;
        }
		else
        {
        	if ( recursion && [subBox subBoxCount] > 0 )
            {
                KxLayoutBox *subBoxFound = [subBox boxById:identifier withRecursion:YES];
                if (subBoxFound != nil)
                    return subBoxFound;
            }
        }
    }
	return nil;
}


- (CGFloat)layoutHeight
{
    if (self.visibility == kCollapse)
        return float_zero;
    return _heightAttr + self.marginTop + self.marginBottom;
}

- (CGFloat)layoutWidth
{
    if (self.visibility == kCollapse)
        return float_zero;
    return _widthAttr + self.marginLeft + self.marginRight;
}

- (CGRect)toLayoutRect
{
    if (self.visibility == kCollapse)
        return CGRectZero;
    CGFloat layoutWidth = [self layoutWidth];
    CGFloat layoutHeight = [self layoutHeight];
    return CGRectMake(_x - _marginLeft, _y - self.marginTop, layoutWidth, layoutHeight);
}

- (CGRect)toRect
{
    if (self.visibility == kCollapse)
        return CGRectZero;
    return CGRectMake(_x, _y, _widthAttr, _heightAttr);
}

// Outer
// Background-image always render in the marginRect.
- (CGRect)marginRect
{
    if (self.visibility == kCollapse)
        return CGRectZero;
    CGFloat layoutWidth = [self layoutWidth];
    CGFloat layoutHeight = [self layoutHeight];
    return CGRectMake(_x - _marginLeft, _y - self.marginTop, layoutWidth, layoutHeight);
}
// Middle
- (CGRect)layoutRect
{
    if (self.visibility == kCollapse)
        return CGRectZero;
    return CGRectMake(_x, _y, _widthAttr, _heightAttr);
}
// Inner
- (CGRect)paddingRect
{
    if (self.visibility == kCollapse)
        return CGRectZero;
    // CGFloat layoutWidth = [self layoutWidth];
    // CGFloat layoutHeight = [self layoutHeight];
    return CGRectMake(_x + self.paddingLeft, _y + self.paddingTop,
                      _widthAttr - self.paddingRight, _heightAttr - self.paddingBottom);
}


- (BOOL)refSourceNotSet
{
    return (_subBoxCount == 0) && self.hasRef;
}

- (CGSize)_adjustSize:(CGRect)rect
          siblingRect:(CGRect)siblingRect 
           withParent:(KxLayoutBox*)parent 
{
    NSString *idFromSizeProperty = (NSString*)self.sizePropertyValue;
    // NOTICE: use name instead of identifier!
    KxLayoutBox *theBox = nil;
    if ( [parent.name isEqualToString:idFromSizeProperty] )
    {
        theBox = parent;
    }
    else
    {
        theBox = [parent boxById:idFromSizeProperty withRecursion:NO];
    }
    assert( nil != theBox );
    
    if (self.sizeProperty == kXLSizePropertySameWidth )
    {
        self.widthAttr = theBox.widthAttr;
    }
    else if (self.sizeProperty == kXLSizePropertySameHeight )
    {
        self.heightAttr = theBox.heightAttr;        
    }
    
    return CGSizeZero;
}
// Self?
- (CGRect)_analyze:(CGRect)rect 
       siblingRect:(CGRect)siblingRect 
        withParent:(KxLayoutBox*)parent 
{
    if (!parent)
        return [self toLayoutRect];
    
    if (self.visibility == kCollapse)
    {
        return [self toLayoutRect];
    }
    // Visible
    if ( parent.isVertical )
    {
        if ( kXLAlignTop == parent.verticalAlign )
        {
            _y = CGRectGetMaxY(siblingRect) + self.marginTop;
        }
        else if ( kXLAlignBottom == parent.verticalAlign)
        {
            _y = CGRectGetMinY(siblingRect) - self.marginBottom - _heightAttr;
        }
        else if ( kXLAlignCenter == parent.verticalAlign )
        {
            //
            assert(parent.subBoxCount <= 1);
            _y = CGRectGetMidY(rect) - _heightAttr / 2;
            
        }
        
        if ( kXLAlignLeft == parent.align )
        {
            _x = rect.origin.x + _marginLeft;
        }
        else if ( kXLAlignRight == parent.align )
        {
            _x = CGRectGetMaxX(rect) - _widthAttr - self.marginRight;
        }
        else if ( kXLAlignCenter == parent.align )
        {
            // Ignore margin-values
            _x = CGRectGetMidX(rect) - _widthAttr / 2;
        }
    }
    else 
    {
        if ( kXLAlignLeft == parent.align )
        {
            _x = CGRectGetMaxX(siblingRect) + _marginLeft;
        }
        else if ( kXLAlignRight == parent.align )
        {
            _x = CGRectGetMinX(siblingRect) - _widthAttr - self.marginRight;
        }
        else if ( kXLAlignCenter == parent.align )
        {
            assert(parent.subBoxCount <= 1);
            _x = CGRectGetMidX(rect) - _widthAttr / 2;
        }
        
        if ( kXLAlignTop == parent.verticalAlign )
        {
            _y = rect.origin.y + self.marginTop;
        }
        else if ( kXLAlignBottom == parent.verticalAlign )
        {
            _y = CGRectGetMaxY(rect) - self.marginBottom - _heightAttr;
        }
        else if ( kXLAlignCenter == parent.verticalAlign )
        {
            // Ignore border-values;
            _y = CGRectGetMidY(rect) - _heightAttr / 2;

        }
    }

    return [self toLayoutRect];
}

- (CGRect)subSiblingRect:(CGRect)rect
{
    CGFloat x = float_zero;
    CGFloat y = float_zero;
    // X
    if ( kXLAlignRight == self.align )
    {
        x = CGRectGetMaxX(rect);
    }
    else if ( kXLAlignLeft == self.align || 
             kXLAlignCenter == self.align)
    {
        x = CGRectGetMinX(rect);  
    }
    // Y
    if ( kXLAlignBottom == self.verticalAlign )
    {
        y = CGRectGetMaxY(rect);
    }
    else if ( kXLAlignTop == self.verticalAlign || 
             kXLAlignCenter == self.verticalAlign)
    {
        y = CGRectGetMinY(rect);
    }
    return CGRectMake(x, y, float_zero, float_zero);
}

- (CGRect)_selectRect:(CGRect)rect
          siblingRect:(CGRect)siblingRect
           withParent:(KxLayoutBox*)parent 
{
	
    const int count = [self subBoxCount];
    int adjust = 0;
    if ( (!self.isVertical && kXLAlignRight == self.align) ||
        (self.isVertical && kXLAlignBottom == self.verticalAlign) )
    {
        adjust = count - 1;
    }
    
    if ( self.sizeProperty != kXLSizePropertyNone )
    {
        [self _adjustSize:rect siblingRect:siblingRect withParent:parent];
    }
    
    CGRect layoutRect = [self _analyze:rect siblingRect:siblingRect withParent:parent];
    CGRect boxRect = [self toRect];
    CGRect subSiblingRect = [self subSiblingRect:boxRect];
    
    for (int i = 0; i < count; ++i)
    {
        int index = ABS( adjust - i );
        KxLayoutBox *subBox = [self subBox:index];
        if (subBox.visibility == kCollapse)
        {
            continue;
        }
        subSiblingRect = [subBox _selectRect:boxRect
                                 siblingRect:subSiblingRect 
                                  withParent:self];        
    }

    return layoutRect;
}

// Entry
- (void)selectRect:(CGRect)rect
{    
    [self _selectRect:rect siblingRect:CGRectZero withParent:nil];
}

- (CGSize)_executeQuery:(XLayoutQueryBlock)valuesSetCallback
{
    CGFloat widthSetSum = 0.0;
    CGFloat heightSetSum = 0.0;
    int spreadBoxCount = 0;
    int verticalSpreadBoxCount = 0;
    int weightBoxCount = 0;
    const int subBoxCount = [self subBoxCount];

    CGFloat weightSum = 0.0;
    if ( subBoxCount > 0 )
    {
        for (int i = 0; i < subBoxCount; ++i)
        {
            KxLayoutBox *subBox = [self subBox:i];
            if (subBox.visibility == kCollapse)
            {
                continue;
            }
            if (self.isVertical)
            {
                // If a box in a vbox, spread means its width = parent box with (exclude margin).
                if ( subBox.isSpread )
                {
                    subBox.widthAttr = self.widthAttr - subBox.marginLeft - subBox.marginRight;
                }
                
                
                // vertical-spread
                if ( subBox.isVerticalSpread )
                {
                    verticalSpreadBoxCount++;
                    // TODO: weight in vertical.
                }
                else
                {
                    CGSize size = [subBox executeQuery:valuesSetCallback withParent:self];
                    heightSetSum += size.height;
                    widthSetSum = MAX(widthSetSum, size.width);
                }
            }
            else // Not vertical
            {
                if ( subBox.isVerticalSpread )
                {
                    subBox.heightAttr = self.heightAttr - subBox.marginTop - subBox.marginBottom;
                }
                
                if ( subBox.isSpread )
                {
                    spreadBoxCount++;
                    if (subBox.weight > 0.0 )
                    {
                        weightSum += subBox.weight;
                        weightBoxCount++;
                    }

                }
                else
                {
                    CGSize size = [subBox executeQuery:valuesSetCallback withParent:self];
                    widthSetSum += size.width;
                    heightSetSum = MAX(heightSetSum, size.height);
                }
            }
            
        }
        
        // The box size is calculated by the inner boxes.
    }
    
    if (self.isVertical)
    {
        // TODO:!!!
        if ( verticalSpreadBoxCount > 0 )
        {
            if ( self.heightAttrSet )
            {
                const CGFloat heightRemain = (self.heightAttr - heightSetSum);
                // Objective C... DIV 0...No Error?
                const CGFloat eachWeight = (1.0 - weightSum) / (verticalSpreadBoxCount - weightBoxCount);
                for (int i = 0; i < subBoxCount; ++i)
                {
                    KxLayoutBox *subBox = [self subBox:i];
                    if (subBox.visibility == kCollapse)
                    {
                        continue;
                    }
                    if ( subBox.isVerticalSpread )
                    {
                        if (subBox.weight > 0.0)
                        {
                            subBox.heightAttr = heightRemain * subBox.weight - subBox.marginTop - subBox.marginBottom;
                        }
                        else
                        {
                            subBox.heightAttr = heightRemain * eachWeight - subBox.marginTop - subBox.marginBottom;
                        }
                        
                        CGSize size = [subBox executeQuery:valuesSetCallback withParent:self];
                        
                        widthSetSum = MAX(widthSetSum, size.width);
                    }
                }
            }
        }
        

    }
    else
    {
        if ( spreadBoxCount > 0 )
        {
            if ( self.widthAttrSet )
            {
                const CGFloat widthRemain = (self.widthAttr - widthSetSum);
                // Objective C... DIV 0...No Error?
                const CGFloat eachWeight = (1.0 - weightSum) / (spreadBoxCount - weightBoxCount);
                for (int i = 0; i < subBoxCount; ++i)
                {
                    KxLayoutBox *subBox = [self subBox:i];
                    if (subBox.visibility == kCollapse)
                    {
                        continue;
                    }
                    if ( subBox.isSpread )
                    {
                        if (subBox.weight > 0.0)
                        {
                            subBox.widthAttr = widthRemain * subBox.weight - subBox.marginLeft - subBox.marginRight;
                        }
                        else
                        {
                            subBox.widthAttr = widthRemain * eachWeight - subBox.marginLeft - subBox.marginRight;
                        }
                        
                        CGSize size = [subBox executeQuery:valuesSetCallback withParent:self];
                        
                        heightSetSum = MAX(heightSetSum, size.height);
                    }
                }
            }
        }

        
    }
    
    return CGSizeMake(widthSetSum, heightSetSum);
}



- (CGSize)executeQuery:(XLayoutQueryBlock)valuesSetCallback withParent:(KxLayoutBox*)parent
{
    if (self.visibility == kCollapse)
        return CGSizeZero;
    
	KxUIQuery *query = [KxUIQuery fetch:self];
    if ( (!_widthAttrSet && !self.isSpread) || 
          !_heightAttrSet )
    {
        valuesSetCallback(query);
        
        if ( query.actionOnWidth == ActionWidthSet )
            self.widthAttr = query.width;
        
        if ( query.actionOnHeight == ActionHeightSet )
            self.heightAttr = query.height;
    }
    
    if ( self.subBoxCount > 0 )
    {
        CGSize size = [self _executeQuery:valuesSetCallback];
        
    	if ( query.actionOnWidth == ActionWidthNotSet && !self.widthAttrSet)
    	{
        	self.widthAttr = size.width; //- self.borderLeft - self.borderRight;
    	}
        
    	if ( query.actionOnHeight == ActionHeightNotSet && !self.heightAttrSet)
    	{
        	self.heightAttr = size.height; // - self.borderTop - self.borderBottom;
    	}
    }
    return CGSizeMake([self layoutWidth], [self layoutHeight]);
}

- (void)executeRefQuery:(XLayoutQueryBlock)valuesSetCallback
{
    KxUIQuery *query = [KxUIQuery fetch:self];
    
    if ( self.hasRef && nil == self.refSource )
    {
        valuesSetCallback(query);
        
        if ( query.actionOnRefSource == ActionRefSourceSet )
        {
            self.refSource = query.refSource;
        }
        else
        {
            error(@"<ref src='?'> MUST be set!");
        }
        KxLayout *layout = [KxLayout load:self.refSource];
        KxLayoutBox *root = layout.root;
        [self addSubBox:root];
        [root addNamespace:self.identifier];
        self.subBoxCount = 1;
    }
    
    if ( self.subBoxCount > 0 )
    {
        for (int i = 0; i < self.subBoxCount; ++i)
        {
            KxLayoutBox* subBox = [self subBox:i];
            [subBox executeRefQuery:valuesSetCallback];
        }
    }
}

- (CGFloat)calculateHeight
{
    if ( !self.isProp )
    {
        return 0.0;
    }
    if (self.visibility == kCollapse)
        return 0.0;
    
    if ( _heightAttrSet )
    {
        return [self layoutHeight];
    }
    else
    {
        // TODO: check its children boxes...
        int subBoxCount = [self subBoxCount];
        if ( subBoxCount == 0 )
        {
            error(@"The box hight NOT be set yet.");
            helps(@"A box without sub-boxes must have the hight value set.");
            return 0.0;
        }
        
        if ( self.isVertical )
        {
            CGFloat height = 0.0;
            for ( int i = 0; i < subBoxCount; ++i )
            {
                KxLayoutBox *subBox = [self subBox:i];
                height += [subBox calculateHeight];
            }
            return height;
        }
        else
        {
            BOOL hasPropBox = NO;
            
            for ( int i = 0; i < subBoxCount; ++i )
            {
                KxLayoutBox *subBox = [self subBox:i];
                if (subBox.isProp)
                {
                    hasPropBox = YES;
                    return [subBox calculateHeight];
                }
            }
            
            if ( NO == hasPropBox )
            {
                error(@"Lack of Key Prop-box in the Prop-Path.");
                helps(@"You MUST choose a Prop-box in a horizontal box.");
            }
        }
    }

    error(@"Lack of Key Prop-box in the Prop-Path.");
    helps(@"Maybe a box should be a Prop-box, but no attribute prop='true' in XML file.");
    return 0.0;
}


- (CGFloat)calculatePropHeight:(XLayoutQueryBlock)valuesSetCallback
{
    if ( self.isProp )
    {
        /* if hidden */
        
        if ( _heightAttrSet )
        {
            return [self layoutHeight];
        }
        else
        {
        	KxUIQuery *query = [KxUIQuery fetch:self];
            valuesSetCallback(query);
            if ( ActionHeightNotSet == query.actionOnHeight )
            {
                // TODO: check its children boxes...
                int subBoxCount = [self subBoxCount];
                if ( subBoxCount > 0 )
                {
                    if ( self.isVertical )
                    {
                        CGFloat height = 0.0;
                        for ( int i = 0; i < subBoxCount; ++i )
                        {
                            KxLayoutBox *subBox = [self subBox:i];
                            height += [subBox calculatePropHeight:valuesSetCallback];
                        }
                        return height;
                    }
                    else
                    {
                        BOOL hasPropBox = NO;

                        for ( int i = 0; i < subBoxCount; ++i )
                        {
                            KxLayoutBox *subBox = [self subBox:i];
                            if (subBox.isProp)
                            {
                                hasPropBox = YES;
                                return [subBox calculatePropHeight:valuesSetCallback];
                            }
                        }

                        if ( NO == hasPropBox )
                        {
                            error(@"Lack of Key Prop-box in the Prop-Path.");
                        	helps(@"You MUST choose a Prop-box in a horizontal box.");
                        }
                    }
                }
                else
                {
                    error(@"Key Prop-box's Height Attribute NOT set!");
                    helps(@"Maybe you did NOT assign the Height value in the query-block.");
                }
                
            }
            else if ( ActionHeightSet == query.actionOnHeight )
            {
                self.heightAttr = query.height;
                return [self layoutHeight];
            }

            
        }
        
    }
    error(@"Lack of Key Prop-box in the Prop-Path.");
    helps(@"Maybe a box should be a Prop-box, but no attribute prop='true' in XML file.");
    return 0.0;
}

- (UITextAlignment)textAlignment
{
    switch (self.contentAlign)
    {
        case kXLAlignLeft:
            return UITextAlignmentLeft;
        case kXLAlignRight:
            return UITextAlignmentRight;
        default:
            return UITextAlignmentCenter;
    }
}

- (void)setProperty:(id)property withName:(NSString*)name
{
    NSString* key = [NSString stringWithFormat:@"%@/%@", _name, name];
    [self.boxRoot setProperty:property withKey:key];
}

- (id)getProperty:(NSString*)name
{
    NSString* key = [NSString stringWithFormat:@"%@/%@", _name, name];
    return [self.boxRoot getPropertyByKey:key];
}

@end
