//
//  XLayout+CodeGen.h
//  KxUI
//
//  Created by Zhongmin Yu

#import "KxLayout.h"

#define UNKNOWN_VALUE		-2.7

@interface KxLayout (CodeGen)

// Not Depends on Auto Query?
- (void)didQueryCode;
- (void)didQueryCode:(NSArray*)binds;
@end
