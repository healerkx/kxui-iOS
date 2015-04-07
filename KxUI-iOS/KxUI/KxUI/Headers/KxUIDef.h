//
//  XLayoutDef.h
//  XLayout
//
//  Created by Healer on 12-3-24.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>


#define error(x)				assert(0);
#define helps(x)		
#define float_eql(x, y)			(ABS((x) - (y)) < 0.001)

#define float_zero				0.0

#ifdef DEBUG
#	define KxLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#	define KxLog(format, ...)
#endif

#define kXLAlignCenter					0
#define kXLAlignLeft					1	
#define kXLAlignRight					2
#define kXLAlignTop						3
#define kXLAlignBottom					4



#define kXLQueryHeight					1
#define kXLQueryWidth					2
#define kXLQuerySize					3

#define kXLSizePropertyNone				0
#define kXLSizePropertySameHeight		1
#define kXLSizePropertySameWidth		2

#define kVisible                        0
#define kHidden                         1
#define kCollapse                       2

#define DefaultFont                     [UIFont systemFontOfSize:14.0]

////////////////////////////////////////////////////////////////////////////////
/*
 * Each box is shrink
 *
 */
