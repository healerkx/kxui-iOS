//
//  RapidXml.mm
//  KxUI
//
//  Created by healer on 12-9-13.
//  Email: healer_kx@163.com
//

#import "RapidXml.h"

// using C++ rapidxml
#import "../XML/rapidxml/rapidxml.hpp"

@interface RapidXmlNode()
{
    rapidxml::xml_node<char>* 		_node;
}
@end


@implementation RapidXmlNode

- (id)initWithNode:(rapidxml::xml_node<char>*)node
{
    self = [super init];
    _node = node;
    return self;
}

- (NSString*)name
{
    char* name = _node->name();
    return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

- (NSString*)value
{
    char* value = _node->value();
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}


- (RapidXmlNode*)firstChild
{
    rapidxml::xml_node<char>* child = _node->first_node();
    if (child)
	    return [[RapidXmlNode alloc] initWithNode:child];
    return nil;
}

- (RapidXmlNode*)firstChildByName:(NSString*)name
{
    const char* cname = [name cStringUsingEncoding:NSUTF8StringEncoding];
    rapidxml::xml_node<char>* child = _node->first_node(cname);
    return [[RapidXmlNode alloc] initWithNode:child];
}

- (NSInteger)childCount
{
	NSInteger count = 0;
    rapidxml::xml_node<char>* child = _node->first_node();
    while (child)
    {
        child = child->next_sibling();
        count++;
    }
    return count;
}


- (RapidXmlNode*)nextSibling
{
    rapidxml::xml_node<char>* node = _node->next_sibling();
    if (node)
	    return [[RapidXmlNode alloc] initWithNode:node];
    return nil;
}

- (NSString*)attrValueByName:(NSString*)name
{
    const char* cname = [name cStringUsingEncoding:NSUTF8StringEncoding];
    rapidxml::xml_attribute<char>* attr = _node->first_attribute(cname);
    if (attr)
    {
        char* cvalue = attr->value();
	    return [NSString stringWithCString:cvalue encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString*)attrValueByCName:(const char*)cname
{
    rapidxml::xml_attribute<char>* attr = _node->first_attribute(cname);
    if (attr)
    {
        char* cvalue = attr->value();
	    return [NSString stringWithCString:cvalue encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSDictionary*)attributesWithPrefix:(NSString*)prefix
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:10];
    rapidxml::xml_attribute<char>* attr = _node->first_attribute();
    while (attr)
    {
        char* cname = attr->name();
        NSString* name = [NSString stringWithCString:cname encoding:NSUTF8StringEncoding];
        if ([name hasPrefix:prefix])
        {
            char* cvalue = attr->value();
            NSString* value = [NSString stringWithCString:cvalue encoding:NSUTF8StringEncoding];
            [dict setObject:value forKey:name];
        }
        
        attr = attr->next_attribute();
    }
    return dict;
}

@end


////////////////////////////////////////////////////////////////////////////////
@interface RapidXml()
{
    rapidxml::xml_document<char> 	_doc;
	RapidXmlNode*					_rootNode;
}
@end

@implementation RapidXml


- (id)initWithData:(NSData*)data
{
    self = [super init];
	NSString *result = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    const char* p = [result UTF8String];
	_doc.parse<0>( (char*)p );
    
    rapidxml::xml_node<char>* root = _doc.first_node();
    
    _rootNode = [[RapidXmlNode alloc] initWithNode:root];

    return self;
}

- (RapidXmlNode*)root
{
    return _rootNode;
}



@end
