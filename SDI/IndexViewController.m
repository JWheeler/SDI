//
//  IndexViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "IndexViewController.h"
#import "LPPieChart.h"
#import "LPHBarChart.h"
#import "LPLineChart.h"


@implementation IndexViewController

@synthesize ribbonImageView;
@synthesize beforeImageView;
@synthesize afterImageView;

@synthesize indexBg1;
@synthesize indexBg2;
@synthesize indexBg3;
@synthesize indexBg4;
@synthesize indexBg5;

@synthesize kIndex;
@synthesize kArrow;
@synthesize kFluctuation;
@synthesize kFluctuationRate;
@synthesize qIndex;
@synthesize qArrow;
@synthesize qFluctuation;
@synthesize qFluctuationRate;
@synthesize fIndex;
@synthesize fArrow;
@synthesize fFluctuation;
@synthesize fFluctuationRate;
@synthesize cIndex;
@synthesize cArrow;
@synthesize cFluctuation;
@synthesize cFluctuationRate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [ribbonImageView release];
    [beforeImageView release];
    [afterImageView release];
    [indexBg1 release];
    [indexBg2 release];
    [indexBg3 release];
    [indexBg4 release];
    [indexBg5 release];
    [kIndex release];
    [kArrow release];
    [kFluctuation release];
    [kFluctuationRate release];
    [qIndex release];
    [qArrow release];
    [qFluctuation release];
    [qFluctuationRate release];
    [fIndex release];
    [fArrow release];
    [fFluctuation release];
    [fFluctuationRate release];
    [cIndex release];
    [cArrow release];
    [cFluctuation release];
    [cFluctuationRate release];
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
    
    // 차트 테스트.
    [self drawHBarChartForKospi];
    [self drawHBarChartForKosdaq];
    [self drawPieChartForKospi];
    [self drawPieChartForKosdaq];
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
        
#if NS_BLOCKS_AVAILABLE 
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
#endif
	}
}

// 코스피 매매동향 가로 바차트.
- (void)drawHBarChartForKospi
{
    int height = 65.0;
    int width = 110.0;
    
    LPHBarChart *hBarChart = [[LPHBarChart alloc] initWithFrame:CGRectMake(98.0, 23.0, width, height)];
    [hBarChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [hBarChart setSameColorLabel:YES];
    hBarChart.barWidth = 11.0;
    [self.indexBg3 addSubview:hBarChart];
    [hBarChart release];
    
    hBarChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    
    // TODO: 실제 데이터 처리 로직 추가.
    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SampleHBarChartData.plist"];
    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [[sampleInfo objectForKey:@"data"] count]; i++)
    {
        NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        LPPieComponent *component = [LPPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
        [components addObject:component];
        
        // 상승/하락에 따른 컬러 설정.
        if ([[item objectForKey:@"value"] floatValue] > 0) 
        {
            [component setColour:RGB(255, 133, 156)];
        }
        else
        {
            [component setColour:RGB(125, 202, 241)];
        }
    }
    [hBarChart setComponents:components];
}

// 코스닥 매매동향 가로 바차트.
- (void)drawHBarChartForKosdaq
{
    int height = 65.0;
    int width = 110.0;
    
    LPHBarChart *hBarChart = [[LPHBarChart alloc] initWithFrame:CGRectMake(218.0, 23.0, width, height)];
    [hBarChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [hBarChart setSameColorLabel:YES];
    hBarChart.barWidth = 11.0;
    [self.indexBg3 addSubview:hBarChart];
    [hBarChart release];
    
    hBarChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    
    // TODO: 실제 데이터 처리 로직 추가.
    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SampleHBarChartData.plist"];
    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [[sampleInfo objectForKey:@"data"] count]; i++)
    {
        NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        LPPieComponent *component = [LPPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
        [components addObject:component];
        
        // 상승/하락에 따른 컬러 설정.
        if ([[item objectForKey:@"value"] floatValue] > 0) 
        {
            [component setColour:RGB(255, 133, 156)];
        }
        else
        {
            [component setColour:RGB(125, 202, 241)];
        }
    }
    [hBarChart setComponents:components];
}

// 코스티 등락종목 파이차트.
- (void)drawPieChartForKospi
{
    int height = 65.0;
    int width = 120.0;
    
    LPPieChart *pieChart = [[LPPieChart alloc] initWithFrame:CGRectMake(85.0, 25.0, width, height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setShowArrow:NO];
    [pieChart setDiameter:50.0];
    [pieChart setSameColorLabel:YES];
    
    [self.indexBg4 addSubview:pieChart];
    [pieChart release];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    
    // TODO: 실제 데이터 처리 로직 추가.
    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SamplePieChartData.plist"];
    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [[sampleInfo objectForKey:@"data"] count]; i++)
    {
        NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        LPPieComponent *component = [LPPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
        [components addObject:component];
        
        // 상승/하락/보합 컴포넌트 구분해야 함.
        if (i == 0)
        {
            [component setColour:RGB(255, 133, 156)];   // 상승.
        }
        else if ( i== 1)
        {
            [component setColour:RGB(125, 202, 241)];   // 하락.
        }
        else if (i == 2)
        {
            [component setColour:RGB(86, 183, 89)];     // 보합.
        }
    }
    [pieChart setComponents:components];
}

// 코스닥 등락종목 파이차트
- (void)drawPieChartForKosdaq
{
    int height = 65.0;
    int width = 120.0;
    
    LPPieChart *pieChart = [[LPPieChart alloc] initWithFrame:CGRectMake(205.0, 25.0, width, height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setShowArrow:NO];
    [pieChart setDiameter:50.0];
    [pieChart setSameColorLabel:YES];
    
    [self.indexBg4 addSubview:pieChart];
    [pieChart release];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    
    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SamplePieChartData.plist"];
    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [[sampleInfo objectForKey:@"data"] count]; i++)
    {
        NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        LPPieComponent *component = [LPPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
        [components addObject:component];
        
        // 상승/하락/보합 컴포넌트 구분해야 함.
        if (i == 0)
        {
            [component setColour:RGB(255, 133, 156)];   // 상승.
        }
        else if ( i== 1)
        {
            [component setColour:RGB(125, 202, 241)];   // 하락.
        }
        else if (i == 2)
        {
            [component setColour:RGB(86, 183, 89)];     // 보합.
        }
    }
    [pieChart setComponents:components];
}

@end
