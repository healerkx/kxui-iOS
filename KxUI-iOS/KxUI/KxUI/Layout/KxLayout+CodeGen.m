//
//  XLayout+CodeGen.m
//  YContact
//
//  Created by Zhongmin Yu on 12-4-20.
//  Copyright (c) 2013. All rights reserved.
//

#import "KxLayout+CodeGen.h"
#import "KxBind.h"
#import "KxLayout+Debug.h"

#define NO_NEED_DID_QUERY	@"No need method: didQuery."
// Code Templates
#define CT_METHOD			@"- (void)didQuery:(XLayoutQueryWithBind*)query withLayout:(XLayout*)layout\n{\n"
#define CT_IF				@"if ( [query sameIdWith:@\"%@\"] )\n\t{\n\t\t"
#define CT_ELIF				@"else if ( [query sameIdWith:@\"%@\"] )\n\t{\n\t\t"
#define CT_COMMENT1			@"// TODO: Width need to calculated."
#define CT_COMMENT2			@"// TODO: Height need to calculated."
#define CT_COMMENT3			@"// TODO: Width and Height need to calculated."
#define CT_QUERY_WIDTH		@"query.width = UNKNOWN_VALUE;"
#define CT_QUERY_HEIGHT		@"query.height = UNKNOWN_VALUE;"
#define CT_BRANCH_END		@"\t}\n"
#define CT_METHOD_END		@"}"

@implementation KxLayout(CodeGen)

- (NSString*)_didQueryIfBranchCode:(KxLayoutBox*)box atIndex:(NSInteger)index andId:(NSString*)identifier
{
    NSMutableString *branch = nil;
    NSString *ifBranch = nil;
    if ( index > 0 )
    {
        ifBranch = [NSString stringWithFormat:CT_ELIF, identifier];
    }
    else
    {
        ifBranch = [NSString stringWithFormat:CT_IF, identifier];
    }
    branch = [NSMutableString stringWithFormat:@"\t%@\n", ifBranch];
    
    if (!box.widthAttrSet && !box.heightAttrSet)
    {
        [branch appendFormat:@"\t\t%@\n", CT_COMMENT3];
        [branch appendFormat:@"\t\t%@\n", CT_QUERY_WIDTH];
        [branch appendFormat:@"\t\t%@\n", CT_QUERY_HEIGHT];        
    }
    else if (!box.heightAttrSet)
    {
        [branch appendFormat:@"\t\t%@\n", CT_COMMENT2];
        [branch appendFormat:@"\t\t%@\n", CT_QUERY_HEIGHT];           
    }
    else if (!box.widthAttrSet)
    {
        [branch appendFormat:@"\t\t%@\n", CT_COMMENT1];
        [branch appendFormat:@"\t\t%@\n", CT_QUERY_WIDTH];        
    }
	[branch appendFormat:@"\t}\n"];
    
    
    
    return branch;
}

- (void)_didQueryCode:(NSArray*)binds
{
    // Class clz = [self class];
    // ?
    // Logger(@"Code For Class: %@\n", NSStringFromClass(clz));
    
    NSArray* array = [self _debugCheckSize];
    const int count = array.count;
    if ( count > 0 )
    {
        NSMutableString *code = [NSMutableString stringWithString:CT_METHOD];
        
        for (int i = 0; i < count; ++i)
        {
            KxLayoutBox *box = [array objectAtIndex:i];
            NSString *identifier = box.identifier;
            BOOL bindText = NO;
            for (KxBind *bind in binds)
            {
                if ([identifier isEqualToString:bind.identifier])
                {
                    if (bind.type == EXBindText)
                    {
                        bindText = YES;
                        break;
                    }
                }
            }
            if (bindText)
            {
                if (box.widthAttrSet || box.heightAttrSet)
                {
                    // autoQuery would calculate the width or height.
                    continue;
                }
            }
            [code appendFormat:@"%@", [self _didQueryIfBranchCode:box atIndex:i andId:identifier]];
        }
        
        [code appendString:CT_METHOD_END];
        // Logger(@"\n%@", code);
        
        
    }
    else
    {
    	//Logger(@"%@", NO_NEED_DID_QUERY);
    }
}

- (void)didQueryCode
{
    [self _didQueryCode:[NSArray array]];
}

- (void)didQueryCode:(NSArray*)binds
{
    [self _didQueryCode:binds];
}


@end
