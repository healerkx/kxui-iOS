////////////////////////////////////////////////////////////////////////////////
//  RapidXml.h
//  KxUI
//
//  Created by healer on 12-9-13.
//  Email: healer_kx@163.com
//
//

#import <Foundation/Foundation.h>

@interface RapidXmlNode : NSObject
- (NSString*)name;
- (NSString*)value;


- (RapidXmlNode*)firstChild;
- (RapidXmlNode*)firstChildByName:(NSString*)name;
- (RapidXmlNode*)nextSibling;

- (NSString*)attrValueByName:(NSString*)name;
- (NSString*)attrValueByCName:(const char*)cname;
- (NSInteger)childCount;
- (NSDictionary*)attributesWithPrefix:(NSString*)prefix;
@end

@interface RapidXml : NSObject
- (id)initWithData:(NSData*)data;
- (RapidXmlNode*)root;
@end
