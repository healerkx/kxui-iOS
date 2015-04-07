//
//  NSString+XLayout.m
//  XLayout
//
//  Created by Healer on 12-4-13.
//  Copyright (c) 2013. All rights reserved.
//

#import "NSString+KxUI.h"

@implementation NSString (KxUI)

- (NSRange)nextPattern:(NSString*)pattern from:(NSInteger)from
{
    NSInteger len = [self length];
    NSRange range = NSMakeRange(from, len - from);
    return [self rangeOfString:pattern options:NSRegularExpressionSearch range:range];
}

- (NSArray*)split:(NSString*)pattern
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger from = 0;
    
    while (from != NSNotFound)
    {
        NSRange range = [self nextPattern:pattern from:from];
        if (range.location != NSNotFound)
        {
            NSString *part = [self substringWithRange:NSMakeRange(from, range.location - from)];
            [array addObject:part];
            from = range.location + range.length;
        }
        else
        {
            NSString *part = [self substringWithRange:NSMakeRange(from, self.length - from)];
            [array addObject:part];    
        	break;    
        }
    }
    return array;
}

- (int)hex
{
    const char* s = [[NSString stringWithFormat:@"0x%@", self] cStringUsingEncoding:NSASCIIStringEncoding];
    int ret = 0;
    sscanf(s,"%x",&ret);
    return ret;
}
@end
