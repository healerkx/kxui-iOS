//
//  TextBindView.m
//  KxUITest
//
//  Created by Zhongmin Yu on 6/30/13.
//  Copyright (c) 2013 healer. All rights reserved.
//

#import "TextBindView.h"
#import "KxUI.h"
#import "KxLayout+Debug.h"

@implementation TextBindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.layoutName = @"text-binds";
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)managedSubviewsReady:(BOOL)ready withLayout:(KxLayout *)layout
{
    [self bindText:@"First Paragraph: Here goes the text...!" withId:@"t1"];
    
    [self bindText:@"Text within a fixed width 100px. And the text should word-wrap." withId:@"t2-l"];
    [self bindText:@"Text within a fixed width 100px. And the text should word-wrap." withId:@"t2-r"];
    
    [self bindText:@"私はルビーが好き" withId:@"t3"];
    
    [self bindText:@"君士坦丁堡是东方世界的地理中心。" withId:@"t4"];
    
    [self bindText:@"Height set, but width would be calculated by the text length" withId:@"t5"];
}

- (void)didDrawRect:(CGRect)rect withLayout:(KxLayout*)layout
{
    [layout debugPaintOutline];
    
}

@end
