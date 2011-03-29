//
//  ContentController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "ContentController.h"


@implementation ContentController

@synthesize contentList;

- (void)dealloc
{
    [contentList release];
    [super dealloc];
}

- (UIView *)view
{
    // 서브클래스는 자신의 뷰 프라퍼티를 위해 이 메서드를 오버라이드 해야한다.
    return nil;
}

@end
