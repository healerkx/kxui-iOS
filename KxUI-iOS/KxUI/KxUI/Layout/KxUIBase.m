//
//  XLayoutUIBase.m
//  KxUI
//
//  Created by Healer on 12-4-18.
//  Copyright (c) 2013. All rights reserved.
//

#import "KxUIBase.h"
#import "KxUI.h"

@interface KxUIBase()

@property (nonatomic, assign)   BOOL        managedSubviewsReady;
@property (nonatomic, strong)	KxLayout*   subviewsLayout;
@end

@implementation KxUIBase




- (id)initWithHostView:(UIView<KxUIDelegate>*)hostView
{
    self = [super init];
    self.managedSubviewsReady = NO;
    _hostView = hostView;
    _binds = [NSMutableArray array];
    return self;
}

- (NSArray*)binds
{
    return _binds;
}

- (void)clearBinds
{
    [_binds removeAllObjects];
    [_hiddenArray removeAllObjects];
    [_calcResults removeAllObjects];
}

//FixMe: Hidden => Collapse
- (void)_didHiddenBoxes:(KxLayout*)layout
{
    for (NSString *hiddenBoxId in _hiddenArray)
    {
        //[layout boxById:hiddenBoxId].hidden = YES;
    }
}

- (void)didProcessLayout:(KxLayout *)layout withQuery:(XLayoutQueryBlock)valuesSetCallback
{
    [layout executeRefQuery:valuesSetCallback];
    [self _didHiddenBoxes:layout];
    [self.hostView layout:layout willProcessAtStage:Unknow];
}

- (BOOL)autoCalculate:(KxUIQueryWithBind*)queryWithBind withLayout:(KxLayout*)layout
{
    BOOL calculated = NO;
    KxBind* bind = queryWithBind.bind;
    
    if (bind.type == EXBindText)
    {
        KxStyle* style = queryWithBind.style;
        
        UIFont* font = style.font ? style.font : DefaultFont;
        //assert(style != nil || style.font != nil);
        if (font)
        {
            KxLayoutBox *box = [layout boxById:bind.identifier];
            if (queryWithBind.widthKnown && !queryWithBind.heightKnown)
            {
                CGSize size = [bind.value sizeWithFont:font
                                     constrainedToSize:CGSizeMake(queryWithBind.width, CGFLOAT_MAX)];
                NSInteger maxHeight = box.maxHeight;
                queryWithBind.height = maxHeight > 0 ? MIN(size.height, maxHeight) : size.height;
                calculated = YES;
            }
            else if (!queryWithBind.widthKnown && queryWithBind.heightKnown)
            {
                CGSize size = [bind.value sizeWithFont:font];
                NSInteger maxWidth = box.maxWidth;
                queryWithBind.width = maxWidth > 0 ? MIN(size.width, maxWidth) : size.width;
                calculated = YES;
            }
        }
    }
    return calculated;
}

- (KxLayout*)selectRect:(CGRect)rect forDrawing:(BOOL)drawing
{
    KxLayout* layout = nil;
    if (self.layoutName)
    {
        layout = [KxLayout load:self.layoutName];
    }
    else
    {
        id root = [KxLayout parse:self.layoutXmlData];
        if (!root)
        {
            return nil;
        }
        layout = [[KxLayout alloc] performSelector:@selector(initWithBoxRoot:) withObject:root];
    }
    
	[self.hostView layout:layout willProcessAtStage:drawing ? Drawing : LayoutSubviews];
    KxUIQueryWithBind* queryWithBind = [[KxUIQueryWithBind alloc] initWithLayout:layout];
    
    [self didProcessLayout:layout withQuery:^(KxUIQuery *query){
        queryWithBind.query = query;
        [self.hostView didRefQuery:queryWithBind withLayout:layout];
    }];
    
    [layout selectRect:rect afterValuesSet:^(KxUIQuery *query)
     {
         NSString *identifier = query.identifier;
         queryWithBind.query = query;
         KxBind *bind = [self findBind:identifier];
         queryWithBind.bind = bind;
         
         XLayoutCalcResult *result = [self resultCalculatedBy:identifier];
         if ( nil != result )
         {
             if (result.actionOnWidthChanged)
             {
                 queryWithBind.width = result.size.width;
             }
             if (result.actionOnHeightChanged)
             {
                 queryWithBind.height = result.size.height;
             }
         }
         else
         {
             const ActionOnWidth actionOnWidth = query.actionOnWidth;
             const ActionOnHeight actionOnHeight = query.actionOnHeight;
             if ( ![self autoCalculate:queryWithBind withLayout:layout] )
             {
                 [self.hostView didQuery:queryWithBind withLayout:layout];
             }
             if ( actionOnWidth != query.actionOnWidth || 
                 actionOnHeight != query.actionOnHeight)
             {
                 [self addCalculatedResult:CGSizeMake(queryWithBind.width, queryWithBind.height)
                      actionOnWidthChanged:(actionOnWidth != query.actionOnWidth) 
                     actionOnHeightChanged:(actionOnHeight != query.actionOnHeight) 
                                    withId:identifier ];
                 
             }
         }
         
         
     }];
    return layout;
}


// Bind
- (KxBind*)findBind:(NSString*)identifier
{
    for (KxBind* bind in _binds)
    {
        if ([identifier isEqualToString:bind.identifier])
        {
            return bind;
        }
    }
    return nil;
}

- (KxBind*)findBind:(NSString*)identifier addIfNotExist:(BOOL)add
{
 	KxBind* bind = [self findBind:identifier];
    if ( (nil == bind) && add )
    {
        bind = [[KxBind alloc] initWithId:identifier];
        [_binds addObject:bind];
    }
    return bind;
}


// Cache
// Cached Calculated Results
- (void)addCalculatedResult:(CGSize)size 
       actionOnWidthChanged:(BOOL)actionOnWidthChanged 
      actionOnHeightChanged:(BOOL)actionOnHeightChanged 
                     withId:(NSString*)identifier
{
    if (!self.cacheResultCalculated) { return; }
    if (!_calcResults)
    {
        _calcResults = [[NSMutableArray alloc] initWithCapacity:2];
    }
	XLayoutCalcResult *result = [[XLayoutCalcResult alloc] initWith:identifier];
    result.size = size;
    result.actionOnWidthChanged = actionOnWidthChanged;
    result.actionOnHeightChanged = actionOnHeightChanged;
	[_calcResults addObject:result];
}

- (XLayoutCalcResult*)resultCalculatedBy:(NSString*)identifier
{
    if ( !self.cacheResultCalculated && !_calcResults )
    {
        return nil;
    }
    for (XLayoutCalcResult *result in _calcResults)
    {
        if ([identifier isEqualToString:result.identifier])
        {
            return result;
        }
    }
    return nil;
}

- (void)addSubviews:(KxLayout*)layout withBox:(KxLayoutBox*)box
{
    NSInteger c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox* subBox = [box subBox:i];
        NSString* type = [subBox getProperty:@"type"];
        if (type)
        {
            // TODO: Need a factory
            UIView* view = [KxLayout viewByType:type withLayoutBox:subBox withHostView:self.hostView];
            
            
            [self.hostView addSubview:view];
            
            [subBox setProperty:view withName:@"view"];
        }
        else
        {            
            // if A box has type, the box would be LEAF.
            [self addSubviews:layout withBox:subBox];    
        }
    }
}

- (void)addSubviews:(KxLayout*)layout
{
    KxLayoutBoxRoot* root = [layout root];
    [self addSubviews:layout withBox:root];
}

//////////////////////////////////////////////////////////////////
// Only for Debug model and Editor.
- (void)clearSubviews:(KxLayout*)layout withBox:(KxLayoutBox*)box
{
    NSInteger c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox* subBox = [box subBox:i];
        UIView* view = (UIView*)[subBox getProperty:@"view"];
        if (view)
        {
            [view removeFromSuperview];
        }
        
        [self clearSubviews:layout withBox:subBox];
    }
}

- (void)clearSubviews:(KxLayout*)layout
{
    KxLayoutBoxRoot* root = [layout root];
    [self clearSubviews:layout withBox:root];
}
//////////////////////////////////////////////////////////////////

- (void)drawBackgroundBox:(KxLayoutBox*)box
{
    NSInteger c = [box subBoxCount];
    for (int i = 0; i < c; ++i)
    {
        KxLayoutBox* subBox = [box subBox:i];
        CGRect subRect =[subBox layoutRect];
        NSString* backgroundImage = [subBox getProperty:@"background-image"];
        if (backgroundImage)
        {
            NSString* path = [[NSBundle mainBundle] pathForResource:backgroundImage ofType:@"png"];
            UIImage* img = [UIImage imageWithContentsOfFile:path];
            
            [img drawInRect:subRect];
        }
        [self drawBackgroundBox:subBox];
        
        NSString* text = [subBox getProperty:@"text"];
        if (text)
        {
            // UIColor* color = subBox.style.color;
            [subBox.style.color set];
            
            UIFont* font = subBox.style.font ? subBox.style.font : DefaultFont;
            [text drawInRect:subRect
                    withFont:font
               lineBreakMode:NSLineBreakByWordWrapping
                   alignment:[subBox textAlignment]];
        }
    }
}

- (void)drawContentView:(CGRect)rect
{
    self.layout = [self selectRect:rect forDrawing:YES];
    
    if ( [self.hostView respondsToSelector:@selector(didDrawBackground:withLayout:)] )
    {
        [self.hostView didDrawBackground:rect withLayout:self.layout];
    }
    KxLayoutBoxRoot* root = [self.layout root];
    [self drawBackgroundBox:root];
    
    for (KxBind* bind in _binds)
    {
        // TODO:...
        KxLayoutBox* box = [self.layout boxById:bind.identifier];
        NSInteger visibility = box.visibility;
        if (visibility == kCollapse || visibility == kHidden)
        {
            continue;
        }
        switch (bind.type)
        {
            case EXBindText:
                [self.hostView didDrawBindText:bind withLayout:self.layout];
                break;
            case EXBindIcon:
                [self.hostView didDrawBindIcon:bind withLayout:self.layout supportHighlight:YES];
                break;
            case EXBindIconNoHighlight:
                [self.hostView didDrawBindIcon:bind withLayout:self.layout supportHighlight:NO];
                break;
            default:
                break;
        }
    }
    if ( [self.hostView respondsToSelector:@selector(didDrawRect:withLayout:)] )
    {
        [self.hostView didDrawRect:rect withLayout:self.layout];
    }
}

- (void)resetManagedSubviews
{
    self.managedSubviewsReady = NO;
    if (self.subviewsLayout)
    {
        [self clearSubviews:self.subviewsLayout];
    }
}

- (void)layoutContentView:(CGRect)rect
{
    self.layout = [self selectRect:rect forDrawing:NO];
    // Cache.
    self.subviewsLayout = self.layout;
    for (KxBind* bind in _binds)
    {
        if ( EXBindView == bind.type )
        {
            KxLayoutBox *box = [self.layout boxById:bind.identifier];
            
			UIView *view = (UIView*)bind.value;
            view.frame = [box toRect];
        }
    }
        
    if (!self.managedSubviewsReady)
    {
        self.managedSubviewsReady = YES;
        [self addSubviews:self.layout];
        
        if ( [self.hostView respondsToSelector:@selector(managedSubviewsReady:withLayout:)] )
        {
            [self.hostView managedSubviewsReady:YES withLayout:self.layout];
        }
    }
    [self.hostView didLayoutSubviews:rect withLayout:self.layout];
}

////////////////////////////////////////////////////////////////////////////////
// Hidden
- (void)insertHiddenArray:(NSString*)identifier
{
    if (!_hiddenArray)
    {
        _hiddenArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    if (![_hiddenArray containsObject:identifier]) 
    {
        [_hiddenArray addObject:identifier];
    }
}

- (BOOL)removeFromHiddenArray:(NSString*)identifier
{
    if (_hiddenArray)
    {
        const int count =  _hiddenArray.count;
        for (int i = 0; i < count; ++i)
        {
            NSString *hiddenId = [_hiddenArray objectAtIndex:i];
            if ([identifier isEqualToString:hiddenId])
            {
                [_hiddenArray removeObjectAtIndex:i];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)hiddenById:(NSString*)identifier
{
    if (_hiddenArray)
    {
        const int count = _hiddenArray.count;
        for (int i = 0; i < count; ++i)
        {
            NSString *hiddenId = [_hiddenArray objectAtIndex:i];
            if ([identifier isEqualToString:hiddenId])
            {
                return YES;
            }
        }
    }
    return NO;  
}

- (void)setBoxVisibility:(NSInteger)visibility forId:(NSString*)identifier
{
    [self.layout boxById:identifier].visibility = visibility;
}

////////////////////////////////////////////////////////////////////////////////
// Bind
- (KxBind*)bindText:(NSString*)text withId:(NSString*)identifier
{
    KxBind *bind = [self findBind:identifier addIfNotExist:YES];
    bind.value		= text;
    bind.type		= EXBindText;
    return bind;
}

- (KxBind*)bindIcon:(UIImage*)icon withId:(NSString*)identifier
{
    KxBind *bind = [self findBind:identifier addIfNotExist:YES];
    bind.value 		= icon;
    bind.type		= EXBindIcon;
    return bind;
}

// View
- (KxBind*)bindView:(id)view withId:(NSString*)identifier
{
    if (!view)
    {
        return nil;
    }
    KxBind *bind = [self findBind:identifier addIfNotExist:YES];
    bind.value 		= view;
    bind.type		= EXBindView;
    return bind;
}

////////////////////////////////////////////////////////////////////////////////
// Calculate Height
- (CGFloat)calculateHeightWithCell:(KxUICell*)cell
                       AtIndexPath:(NSIndexPath*)indexPath
                         withWidth:(CGFloat)width 
                      withDelegate:(id<KxUIBindDataDelegate>)delegate
{
	KxUIBase *base = cell.base;
    
    KxLayout *layout = [KxLayout load:base.layoutName];
    [cell bindAtIndexPath:indexPath withDelegate:delegate whenCalculateHeight:YES];
    
    KxUIQueryWithBind *queryWithBind = [[KxUIQueryWithBind alloc] initWithLayout:layout];
    
    [base didProcessLayout:layout withQuery:^(KxUIQuery *query){
        queryWithBind.query = query;
        [cell didRefQuery:queryWithBind withLayout:layout];
    }];
    
    CGFloat height = [layout calculateHeight:^(KxUIQuery *query)
                      {
                          queryWithBind.query = query;
                          KxBind *bind = [base findBind:query.identifier];
                          queryWithBind.bind = bind;
                          
                          
                          if ( ![base autoCalculate:queryWithBind withLayout:layout] )
                          {
                              [cell didQuery:queryWithBind withLayout:layout];
                          }
                      }
                                   withWidth:width];
    return height;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event theView:(UIView*)view
{
    CGPoint point = [[touches anyObject] locationInView:view];
    for (KxBind* bind in _binds)
    {
        if (bind.target && bind.action)
        {
            KxLayoutBox *box = [self.layout boxById:bind.identifier];
            if (CGRectContainsPoint([box toRect], point)) 
            {
                if ([NSStringFromSelector(bind.action) hasSuffix:@":"])
                {
                    [bind.target performSelector:bind.action withObject:bind.userInfo];
                }
                else
                {
                    [bind.target performSelector:bind.action];
                }
                return;
            }
        }
    }
}

@end
