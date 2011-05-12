//
//  IndexViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "IndexViewController.h"


@implementation IndexViewController

@synthesize ribbonImageView;
@synthesize beforeImageView;
@synthesize afterImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [ribbonImageView release];
    [beforeImageView release];
    [afterImageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 리본 용 제스처 등록.
    [self registerGestureForRibbon];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 커스텀 메서드

// 리본을 위한 제스처 등록.
- (void)registerGestureForRibbon
{
    UISwipeGestureRecognizer *recognizerLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeDaily:)] autorelease];
	// 스와이프 제스처를 인식하기위한 탭 수.
	recognizerLeft.numberOfTouchesRequired = 1;
	// 스와이프의 방향: 좌.
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.ribbonImageView addGestureRecognizer:recognizerLeft];
}

// 데일리 뷰 닫기.
- (void)closeDaily:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
    {
		Debug(@"UISwipeGestureRecognizerDirectionLeft!");
        
        // iOS4-
//        UIView *modalView = self.view;
//        
//        CGSize offSize = [UIScreen mainScreen].bounds.size;
//        // Y축 10포인트 보정.
//        CGPoint offScreenCenter = CGPointMake(offSize.width * -2.0, offSize.height / 2.0 + 10);
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        modalView.center = offScreenCenter;
//        [UIView commitAnimations];
        
        // iOS4+: Blocks 사용.
        [UIView animateWithDuration:0.5
                              delay:0.2
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             // 데일리 뷰 슬라이드(우 -> 좌).
                             UIView *modalView = self.view;
                             CGSize offSize = [UIScreen mainScreen].bounds.size;
                             // Y축 10포인트 보정.
                             CGPoint offScreenCenter = CGPointMake(offSize.width * -2.0, (offSize.height / 2.0) + 10);
                             modalView.center = offScreenCenter;
                         } 
                         completion:^(BOOL finished){
                             Debug(@"Animation done!");
                         }];
	}
}

@end
