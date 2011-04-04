//
//  MyMenuView.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MyMenuView.h"


@implementation MyMenuView

@synthesize menuScrollView;
@synthesize menuButtons;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) 
//    {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
	[menuScrollView release];
    [menuButtons release];
    [super dealloc];
}

#pragma mark - 스크롤뷰 델리게이트 메서드

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	// (padding)옵셋이 3보다 적을 때... 
	// 실전에서 좌우에 스크롤이 가능하다는 화살표(leftMenuImage/rightOffset)를 보여주는 용도로 사용함.
	if (scrollView.contentOffset.x <= 3) 
    {
		NSLog(@"Scroll is as far left as possible");
	}
	else if(scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 3) 
    {
		NSLog(@"Scroll is as far right as possible");
	}
	else 
    {
		// 스크롤이 왼쪽과 오른쪽 사이에 있을 경우. 좌우 모두 스크롤 가능함.
	}
}

#pragma mark - 커스텀 메서드

- (id)initWithFrameAndButtons:(CGRect)frame buttons:(NSMutableArray *)buttonArray 
{	
    self = [super initWithFrame:frame];
	if (self) 
    {
		// 현재 크기와 동일한 스크롤 뷰 초기화.
		self.menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		
		// 스크롤뷰 설정.
        self.menuScrollView.alpha = 0.7;
		self.menuScrollView.showsHorizontalScrollIndicator = FALSE;
		self.menuScrollView.showsVerticalScrollIndicator = FALSE;
		self.menuScrollView.scrollEnabled = YES;
		self.menuScrollView.bounces = FALSE;
		
		// 델리케이트 설정.
		self.menuScrollView.delegate = self;
		
		// 스클롤뷰에 추가할 버튼들.
		self.menuButtons = buttonArray;
		
		float totalButtonHeight = 0.0;
        float positionX = 10.0;
        float positionY = 0.0;
		
		for (int i = 0; i < [menuButtons count]; i++) 
        {
			UIButton *btn = [menuButtons objectAtIndex:i];
			
			// 버튼 위치 이동(가로로 x, 세로로 y).
			CGRect btnRect = btn.frame;
            btnRect.origin.x = positionX;
			btnRect.origin.y = positionY;
			[btn setFrame:btnRect];
            
			// 스크롤뷰에 버튼 추가.
			[self.menuScrollView addSubview:btn];
			
			// 버튼들 전체의 넓이.
			totalButtonHeight += btn.frame.size.height;
            
            positionX += 5;
            positionY += btn.frame.size.height + 10;
            
            Debug(@"Button frame: %@", NSStringFromCGRect(btnRect));
		}
		
		// 스크롤뷰의 content rect 업데이트.
		[self.menuScrollView setContentSize:CGSizeMake(self.frame.size.width, totalButtonHeight)];
		
		[self addSubview:self.menuScrollView];
		
	}
    
	return self;
}

@end
