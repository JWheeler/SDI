//
//  SDIContentController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SDIContentController.h"
#import "SDIAppDelegate.h"
#import "MainViewController.h"
#import "SecondViewController.h"
#import "IndexViewController.h"
#import "MyMenuViewController.h"

static NSUInteger kNumberOfPages = 2;

@interface ContentController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end


@implementation SDIContentController

@synthesize scrollView;
@synthesize pageControl; 
@synthesize ribbonImageView;
@synthesize viewControllers;

- (void)dealloc
{
    [scrollView release];
    [pageControl release];
    [ribbonImageView release];
    [viewControllers release];
    [super dealloc];
}

- (void)awakeFromNib
{    
    // 뷰 컨트롤러들은 지연 생성한다. 그 사이에, 배열 로드.
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // 스크롤 뷰의 넙이는 페이지 뷰의 넓이 * 페이지 수.
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    pageControl.selectedColor = [UIColor blackColor];
    pageControl.deselectedColor = [UIColor lightGrayColor];
    
    // 페이지는 요구 시 생성.
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    // 리본 제스처 등록.
    [self registerGestureForRibbon];
}

#pragma mark - 스크롤 및 페이지 컨트롤 관련

- (UIView *)view
{
    return self.scrollView;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    if (page ==0) 
    {
        // 필요할 경우 플레이스홀더 교체.
        MainViewController *controller = [viewControllers objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[SecondViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
            [controller release];
        }
        
        // 스크롤 뷰에 컨트롤러의 뷰를 추가.
        if (controller.view.superview == nil)
        {
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [scrollView addSubview:controller.view];
        }
    }
    else if (page == 1)
    {
        // 필요할 경우 플레이스홀더 교체.
        SecondViewController *controller = [viewControllers objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
            [controller release];
        }
        
        // 스크롤 뷰에 컨트롤러의 뷰를 추가.
        if (controller.view.superview == nil)
        {
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [scrollView addSubview:controller.view];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // 이전과 다음 페이지의 보이는 비율이 50%를 넘을 때 인디게이터 변경.
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // 보여줄 양쪽 페이지 로드(플래시 효과 제거를 위해...).
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // 접근하려는 페이지로 스크롤 뷰 업데이트.
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

#pragma mark - 커스텀 메서드

// 리본을 위한 제스처 등록.
- (void)registerGestureForRibbon
{
    UISwipeGestureRecognizer *recognizerRight = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDaily:)] autorelease];
	// 스와이프 제스처를 인식하기위한 탭 수.
	recognizerRight.numberOfTouchesRequired = 1;
	// 스와이프의 방향: 좌.
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
	[self.ribbonImageView addGestureRecognizer:recognizerRight];
}

// 데일리 뷰 열기.
- (void)openDaily:(UISwipeGestureRecognizer *)recognizer
{
	if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) 
    {
        Debug(@"UISwipeGestureRecognizerDirectionRight!");
		IndexViewController *indexViewController = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
        [self.view.superview addSubview:indexViewController.view];
        [indexViewController.view release];
        
        // TODO: iOS 버전 별로 애니메이션 코드 분기 처리할 것!
        // iOS4-
//        UIView *modalView = indexViewController.view;
//        
//        // Y축 20 포인트 보정.
//        CGPoint middleCenter = CGPointMake(modalView.center.x, modalView.center.y + 20);
//        CGSize offSize = [UIScreen mainScreen].bounds.size;
//        // Y축 10 포인트 보정.
//        CGPoint offScreenCenter = CGPointMake(offSize.width * -2.0, (offSize.height / 2.0) + 10);
//        modalView.center = offScreenCenter;
        
//        Debug(@"ModalView center: %@", NSStringFromCGPoint(modalView.center));
//        Debug(@"middleCenter center: %@", NSStringFromCGPoint(middleCenter));
//        Debug(@"ModalView frame: %@", NSStringFromCGRect(modalView.frame));
//        Debug(@"RibbonView frame: %@", NSStringFromCGRect(self.ribbonImageView.frame));
        
        // iOS3.
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        modalView.center = middleCenter;
//        [UIView commitAnimations];
        
        // iOS4+: Blocks 사용.
        [UIView animateWithDuration:0.5
                              delay:0.2
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             // 데일리 뷰 슬라이드(좌 -> 우).
                             UIView *slideView = indexViewController.view;
                             // Y축 20 포인트 보정.
                             CGPoint middleCenter = CGPointMake(slideView.center.x, slideView.center.y + 20);
                             CGSize offSize = [UIScreen mainScreen].bounds.size;
                             // Y축 10 포인트 보정.
                             CGPoint offScreenCenter = CGPointMake(offSize.width * -2.0, (offSize.height / 2.0) + 10);
                             slideView.center = offScreenCenter;
                             slideView.center = middleCenter;
                         } 
                         completion:^(BOOL finished) {
                             Debug(@"Animation done!");
                         }];
	}
    
    
}

// 마이메뉴 열기.
- (IBAction)openMyMenu:(id)sender
{
    MyMenuViewController *myMenuViewController = [[MyMenuViewController alloc] initWithNibName:@"MyMenuViewController" bundle:nil];    
    [self.view.superview addSubview:myMenuViewController.view];
    [myMenuViewController.view release];
    
    
    // 전체메뉴를 모달로 띄움.
    UIView *modalView = myMenuViewController.view;
    modalView.frame = [UIScreen mainScreen].bounds;
    
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 2.0);
    modalView.center = offScreenCenter;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    modalView.center = middleCenter;
    [UIView commitAnimations];
    
    Debug(@"MyMenu frame: %@", NSStringFromCGRect(modalView.frame));
    Debug(@"MyMenu frame: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
}

@end
