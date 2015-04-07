//
//  KxLayout.m
//  KxUI
//
//  Created by Zhongmin Yu
//  Email: zmyu@yahoo-inc.com

#import "KxLayout.h"
#import "KxLayoutResult.h"

#import "KxLayoutBoxRoot.h"
#import "KxLayoutBox.h"
#import "KxUIXmlParser.h"
#import "KxLayout+Debug.h"
#import "WidgetsFactory.h"

@implementation KxLayout
@synthesize result			= _result;
@synthesize root			= _root;



+ (NSData*)loadXml:(NSString*)name
{
	NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* fileName = [NSString stringWithFormat:@"%@.ui", name];
    NSString* fullPath = [NSString stringWithFormat:@"%@/%@/%@", bundlePath, @"ui", fileName];
        
    NSData* data = [NSData dataWithContentsOfFile:fullPath];
    return data;
}

+ (KxLayoutBoxRoot*)parse:(NSData*)layoutXml
{
    KxLayoutBoxRoot* root = [KxUIXmlParser parse:layoutXml];
    return root;
}

+ (KxLayout*)load:(NSString*)name
{
    if (!name)
        return nil;
    static NSMutableDictionary *dict = nil;
    if (!dict)
    {
    	dict = [NSMutableDictionary dictionary];
    }
    
    KxLayoutBoxRoot* rootTemplate = [dict objectForKey:name];
    
    if ( !rootTemplate )
    {
        NSData* layoutXml = [KxLayout loadXml:name];

       	rootTemplate = [KxLayout parse:layoutXml];
        [dict setValue:rootTemplate forKey:name];
    }

    KxLayoutBoxRoot *root = [rootTemplate copy];
    KxLayout *layout = [[KxLayout alloc] initWithBoxRoot:root];
    return layout;
}

- (KxLayout*)initWithBoxRoot:(KxLayoutBoxRoot*)root;
{
    self = [super init];
	_root = root;
    return self;
}

- (BOOL)hasId:(NSString*)idStr
{
    KxLayoutBox *box = [self boxById:idStr];
    return box != nil;
}

- (void)executeRefQuery:(XLayoutQueryBlock)valuesSetCallback
{
    [_root executeRefQuery:valuesSetCallback];
}

- (KxLayoutResult*)selectRect:(CGRect)rect afterValuesSet:(XLayoutQueryBlock)valuesSetCallback
{
    KxLayoutResult *result = nil;
    [_root executeQuery:valuesSetCallback withConstraintRect:rect];
    [_root selectRect:rect];
    return result;
}

- (void)applyResult:(KxLayoutResult*)result
{
    self.result = result;
}

- (KxLayoutBox*)boxById:(NSString*)identifier
{
	return [_root boxById:identifier withRecursion:YES];
}

- (CGFloat)calculateHeight:(XLayoutQueryBlock)valuesSetCallback withWidth:(CGFloat)width
{
    [_root executeQuery:valuesSetCallback withConstraintRect:CGRectMake(0, 0, width, MAXFLOAT)];
    
    [self _debugPrintSize];
    CGFloat height = [_root calculateHeight];
    return height;
}


- (CGFloat)calculatePropHeight:(XLayoutQueryBlock)valuesSetCallback
{
    assert(0);
    CGFloat height = [_root calculatePropHeight:valuesSetCallback];
    return height;
}

+ (NSString*)identifier:(NSString*)identifier withRefId:(NSString*)refId
{
    if (refId.length > 0)
    {
        return [NSString stringWithFormat:@"%@.%@", refId, identifier];
    }
    else
    {
        return identifier;
    }
}

+ (BOOL)registerWidgetType:(Class)clz forName:(NSString*)typeName
{
    BOOL r = [[WidgetsFactory sharedFactory] registerWidgetType:clz forName:typeName];
    return r;
}

+ (UIView*)viewByType:(NSString*)type withLayoutBox:(KxLayoutBox*)box withHostView:(UIView*)hostView
{
    return [[WidgetsFactory sharedFactory] viewByType:type withLayoutBox:box withHostView:hostView];
}

@end
