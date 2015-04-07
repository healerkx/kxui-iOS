//
//  XLayout+Debug.h
//  XLayout
//
//  Created by Zhongmin Yu on 12-3-31.
//  Copyright (c) 2013. All rights reserved.
//

#import "KxLayout.h"
#define spaces	@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"
@interface KxLayout(Debug)

- (void)_debugPrintSize;
- (void)_debugPrintRect;
- (void)_debugPaintRect;

- (void)debugPaintOutline;

- (NSMutableArray*)_debugCheckSize;

@end
