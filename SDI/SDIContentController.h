//
//  SDIContentController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentController.h"
#import "LPPageControl.h"

// 툴바 메뉴.
enum 
{
    Home = 0,
    MyMenu = 1,
    Help = 2,
    Finish = 3
};


@interface SDIContentController : ContentController <UIScrollViewDelegate> 
{   
    UIView *fullScreen;             // 레이아웃 설정용 전체 화면...
    UIScrollView *scrollView;
	LPPageControl *pageControl;
    UIImageView *ribbonImageView;
    
    NSMutableArray *viewControllers;
    
    // UIPageControl로 부터 originate로 스크롤할 때 사용.
    BOOL pageControlUsed;
    
    // 현재, 뷰에 추가한 하위 메뉴 뷰의 인덱스.
    int currentAddedSubviewIndex;
    // 현재, 뷰에 추가한 하위 메뉴 뷰의 태그: 뷰 삭제를 위해 사용, 화면번호를 사용해 설정함.
    NSInteger currentAddedSubviewTag;
}

@property (nonatomic, retain) IBOutlet UIView *fullScreen;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet LPPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIImageView *ribbonImageView;
@property (nonatomic, retain) IBOutlet UIView *tabBar;
@property (nonatomic, retain) IBOutlet UIImageView *tabBarBG;

@property (nonatomic, retain) NSMutableArray *viewControllers;

- (IBAction)changePage:(id)sender;
- (void)registerGestureForRibbon;
- (void)openDaily:(UISwipeGestureRecognizer *)recognizer;
- (void)removeFromSuperviweForAddedView;
- (void)bringRibbonImageViewToFront;
- (IBAction)openMenuForTabBar:(id)sender;
- (void)openMenuForTotalMenu:(id)sender;
- (IBAction)openMyMenu:(id)sender;
- (IBAction)openIRStock:(id)sender;
- (void)changeTabBarStyle:(BOOL)type;
- (void)notificationFromView:(NSNotification *)notification;

@end
