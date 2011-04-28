//
//  UINavigation+CustomBar.m
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 10. 1..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import "UINavigationBar+CustomBar.h"


@implementation UINavigationBar (CustomBar)

// MPMoviePlayerViewController의 컨트롤을 가리기 때문에 주석 처리함!
//- (id)initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//    }
//    return self;
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
	// 컬러 설정: 백버튼 컬러 설정을 위해...
    [self setTintColor:RGB(41, 41, 41)];
    
    // 네비게이션바에 배경 이미지 추가.
	UIImage *image = [[UIImage imageNamed:@"navi_bg.png"] retain];
	[image drawInRect:rect];
	[image release];
}


- (void)dealloc {
    [super dealloc];
}

@end