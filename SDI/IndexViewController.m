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
#import "LPVBarChart.h"
#import "LPLineChart.h"
#import "HTTPHandler.h"


@implementation IndexViewController

@synthesize ribbonImageView;
@synthesize beforeImageView;
@synthesize afterImageView;

@synthesize indexBg11;
@synthesize indexBg21;
@synthesize indexBg31;
@synthesize indexBg41;
@synthesize indexBg51;

@synthesize indexBg12;
@synthesize indexBg1;
@synthesize indexBg2;
@synthesize indexBg3;
@synthesize indexBg4;
@synthesize indexBg5;

// 실시간지수: 코스피.
@synthesize kIndex;
@synthesize kArrow;
@synthesize kFluctuation;
@synthesize kFluctuationRate;

// 실시간지수: 코스닥.
@synthesize qIndex;
@synthesize qArrow;
@synthesize qFluctuation;
@synthesize qFluctuationRate;

// 실시간지수: 선물.
@synthesize fIndex;
@synthesize fArrow;
@synthesize fFluctuation;
@synthesize fFluctuationRate;

// 실시간지수: 원/달러.
@synthesize cIndex;
@synthesize cArrow;
@synthesize cFluctuation;
@synthesize cFluctuationRate;

@synthesize val1;
@synthesize val2;
@synthesize val3;
@synthesize val4;
@synthesize val5;
@synthesize title1;
@synthesize title2;
@synthesize title3;
@synthesize title4;
@synthesize title5;

@synthesize hBarChartData;
@synthesize pieChartDataForKospi;
@synthesize pieChartDataForKosdaq;
@synthesize vBarChartDataForTheme;

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
    [indexBg11 release];
    [indexBg21 release];
    [indexBg31 release];
    [indexBg41 release];
    [indexBg51 release];
    [indexBg12 release];
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
    [val1 release];
    [val2 release];
    [val3 release];
    [val4 release];
    [val5 release];
    [title1 release];
    [title2 release];
    [title3 release];
    [title4 release];
    [title5 release];
    [hBarChartData release];
    [pieChartDataForKospi release];
    [pieChartDataForKosdaq release];
    [vBarChartDataForTheme release];
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
    
    // 장 전후(NO), 중(YES) 구분.
    // !!!: 테스트 또는 개발 시에는 토글 하여 사용하면 된다.
    if ([self isViewChangeTime]) 
    {
        // 장 전, 후...
        self.beforeImageView.hidden = NO;
        self.indexBg11.hidden = NO;
        self.indexBg21.hidden = NO;
        self.indexBg31.hidden = NO;
        self.indexBg41.hidden = NO;
        self.indexBg51.hidden = NO;
        
        self.afterImageView.hidden = YES;
        self.indexBg1.hidden = YES;
        self.indexBg2.hidden = YES;
        self.indexBg3.hidden = YES;
        self.indexBg4.hidden = YES;
        self.indexBg5.hidden = YES;
    }
    else
    {
        // 장 중...
        self.beforeImageView.hidden = YES;
        self.indexBg11.hidden = YES;
        self.indexBg21.hidden = YES;
        self.indexBg31.hidden = YES;
        self.indexBg41.hidden = YES;
        self.indexBg51.hidden = YES;
        
        self.afterImageView.hidden = NO;
        self.indexBg1.hidden = NO;
        self.indexBg2.hidden = NO;
        self.indexBg3.hidden = NO;
        self.indexBg4.hidden = NO;
        self.indexBg5.hidden = NO;
        
        // 실시간지수.
        [self settingRealForKospi];
        
        // 차트용 데이터 로드.
        self.hBarChartData = [NSDictionary dictionaryWithDictionary:[self fetchData:TRCD_SVC10313]];
        self.pieChartDataForKospi = [NSDictionary dictionaryWithDictionary:[self fetchData:TRCD_DL01BASE]];
        self.pieChartDataForKosdaq = [NSDictionary dictionaryWithDictionary:[self fetchData:TRCD_OUTDBASE]];
        self.vBarChartDataForTheme = [NSDictionary dictionaryWithDictionary:[self fetchData:TRCD_POWR5011]];
        
        // 차트.
        [self drawHBarChartForKospi];
        [self drawHBarChartForKosdaq];
        [self drawPieChartForKospi];
        [self drawPieChartForKosdaq];
        [self drawVBarChartForTheme];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.hBarChartData = [NSDictionary dictionaryWithDictionary:[self fetchData:TRCD_SVC10313]];
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

// 장 전, 후 여부에 따라 뷰를 변경.
- (BOOL)isViewChangeTime
{
    // 현재 날짜와 시간.
	NSDate *now = [[NSDate alloc] init];
	
	// 날짜 포맷.
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    // 날짜, 시간 포맷.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	// 비교할 시작 시간 생성.
	NSString *startDate = [dateFormat stringFromDate:now];
	NSString *startTime = @"09:00:00";
	NSString *stringStartDate = @"";
	stringStartDate = [stringStartDate stringByAppendingString:startDate];
	stringStartDate = [stringStartDate stringByAppendingString:@" "];
	stringStartDate = [stringStartDate stringByAppendingString:startTime];
	NSDate *compareStartDate = [formatter dateFromString:stringStartDate];
    
    // 비교할 종료 시간 생성.
	NSString *endDate = [dateFormat stringFromDate:now];
	NSString *endTime = @"15:00:00";
	NSString *stringEndDate = @"";
	stringEndDate = [stringEndDate stringByAppendingString:endDate];
	stringEndDate = [stringEndDate stringByAppendingString:@" "];
	stringEndDate = [stringStartDate stringByAppendingString:endTime];
	NSDate *compareEndDate = [formatter dateFromString:stringEndDate];
    
    // 시간(날짜) 비교.
	if ([now compare:compareStartDate] == NSOrderedDescending 
        && [now compare:compareEndDate] == NSOrderedAscending) 
    {
        // 장 중.
        return YES;
    }
  
	[now release];
	[dateFormat release];
	[formatter release];
    
    return NO;
}

// 차트를 그리기 위한 데이터 가져오기.
- (NSDictionary *)fetchData:(NSString *)trCode
{
    HTTPHandler *httpHandler = [[HTTPHandler alloc] init];
    [httpHandler req:trCode];
    
    if (httpHandler.reponseDict != nil) 
    {
        Debug(@"%@", httpHandler.reponseDict);
        return httpHandler.reponseDict;
    }
    
    [httpHandler release];
    
    return nil;
}

// 매매동향 코스피 가로 바차트 용 데이터 생성.
- (NSMutableArray *)genDataForHBarChartKospi:(NSDictionary *)data
{
    // 외국인(krx14), 개인(krx11), 기관(krx10), 국가/지자체(krx8).
    int krx14 = 0;
    int krx11 = 0;
    int krx10 = 0;
    int krx8 = 0;
    int sum = 0;
    for (NSString *key in [data allKeys])
    {
        if ([LPUtils matchString:key withString:@"krx"]) 
        {
            sum += [[data valueForKey:key] intValue];
        }
        
        if ([key isEqualToString:@"krx14"]) 
        {
            krx14 = [[data valueForKey:@"krx14"] intValue];
        }
        
        if ([key isEqualToString:@"krx11"]) 
        {
            krx11 = [[data valueForKey:@"krx11"] intValue];
        }
        
        if ([key isEqualToString:@"krx10"]) 
        {
            krx10 = [[data valueForKey:@"krx10"] intValue];
        }
        
        if ([key isEqualToString:@"krx8"]) 
        {
            krx8 = [[data valueForKey:@"krx8"] intValue];
        }
    }
    
    krx14 = (krx14 * 100) / sum;
    krx11 = (krx11 * 100) / sum;
    krx10 = (krx10 * 100) / sum;
    krx8 = (krx8 * 100) / sum;
    
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableDictionary *dict0 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict0 setValue:[NSString stringWithFormat:@"%d%%", krx14] forKey:@"title"];
    [dict0 setValue:[NSNumber numberWithFloat:krx14] forKey:@"value"];
    [components addObject:dict0];
    [dict0 release];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict1 setValue:[NSString stringWithFormat:@"%d%%", krx11] forKey:@"title"];
    [dict1 setValue:[NSNumber numberWithFloat:krx11] forKey:@"value"];
    [components addObject:dict1];
    [dict1 release];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict2 setValue:[NSString stringWithFormat:@"%d%%", krx10] forKey:@"title"];
    [dict2 setValue:[NSNumber numberWithFloat:krx10] forKey:@"value"];
    [components addObject:dict2];
    [dict2 release];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict3 setValue:[NSString stringWithFormat:@"%d%%", krx8] forKey:@"title"];
    [dict3 setValue:[NSNumber numberWithFloat:krx8] forKey:@"value"];
    [components addObject:dict3];
    [dict3 release];
    
    // 디버그.
//    for (NSDictionary *dict in components) 
//    {
//        Debug(@">>>>>>>>>>>>>>>>%@", dict);
//    }
    
    return components;
}

// 매매동향 코스닥 가로 바차트 용 데이터 생성.
- (NSMutableArray *)genDataForHBarChartKosdaq:(NSDictionary *)data
{
    // 외국인(krx14), 개인(krx11), 기관(krx10), 국가/지자체(krx8).
    int ksdq14 = 0;
    int ksdq11 = 0;
    int ksdq10 = 0;
    int ksdq8 = 0;
    int sum = 0;
    for (NSString *key in [data allKeys])
    {
        if ([LPUtils matchString:key withString:@"ksdq"]) 
        {
            sum += [[data valueForKey:key] intValue];
        }
        
        if ([key isEqualToString:@"ksdq14"]) 
        {
            ksdq14 = [[data valueForKey:@"ksdq14"] intValue];
        }
        
        if ([key isEqualToString:@"ksdq11"]) 
        {
            ksdq11 = [[data valueForKey:@"ksdq11"] intValue];
        }
        
        if ([key isEqualToString:@"ksdq10"]) 
        {
            ksdq10 = [[data valueForKey:@"ksdq10"] intValue];
        }
        
        if ([key isEqualToString:@"ksdq8"]) 
        {
            ksdq8 = [[data valueForKey:@"ksdq8"] intValue];
        }
    }
    
    ksdq14 = (ksdq14 * 100) / sum;
    ksdq11 = (ksdq11 * 100) / sum;
    ksdq10 = (ksdq10 * 100) / sum;
    ksdq8 = (ksdq8 * 100) / sum;
    
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableDictionary *dict0 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict0 setValue:[NSString stringWithFormat:@"%d%%", ksdq14] forKey:@"title"];
    [dict0 setValue:[NSNumber numberWithFloat:ksdq14] forKey:@"value"];
    [components addObject:dict0];
    [dict0 release];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict1 setValue:[NSString stringWithFormat:@"%d%%", ksdq11] forKey:@"title"];
    [dict1 setValue:[NSNumber numberWithFloat:ksdq11] forKey:@"value"];
    [components addObject:dict1];
    [dict1 release];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict2 setValue:[NSString stringWithFormat:@"%d%%", ksdq10] forKey:@"title"];
    [dict2 setValue:[NSNumber numberWithFloat:ksdq10] forKey:@"value"];
    [components addObject:dict2];
    [dict2 release];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict3 setValue:[NSString stringWithFormat:@"%d%%", ksdq8] forKey:@"title"];
    [dict3 setValue:[NSNumber numberWithFloat:ksdq8] forKey:@"value"];
    [components addObject:dict3];
    [dict3 release];
    
    // 디버그.
//    for (NSDictionary *dict in components) 
//    {
//        Debug(@">>>>>>>>>>>>>>>>%@", dict);
//    }
    
    return components;
}

// 등락종목 코스피 파이 차트 용 데이터 생성.
- (NSMutableArray *)genDataForPieChartKospi:(NSDictionary *)data
{
    // 전체종목수(tltIsC), 상증종목수(upC, 상한 포함), 하락종목수(downC, 하한 포함), 보합종목수(unchngIsC).
    float tltIsC = 0;
    float upC = 0;
    float downC = 0;
    float unchngIsC = 0;
    
    for (NSString *key in [data allKeys])
    {
        if ([key isEqualToString:@"tltIsC"]) 
        {
            tltIsC = [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
        
        if ([key isEqualToString:@"upIsC"] || [key isEqualToString:@"uLmtIsC"]) 
        {
            upC += [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
        
        if ([key isEqualToString:@"dwnIsC"] || [key isEqualToString:@"lLmtIsC"]) 
        {
            downC += [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
        
        if ([key isEqualToString:@"unchngIsC"]) 
        {
            unchngIsC = [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
    }
    
    upC = (upC * 100) / tltIsC;
    downC = (downC * 100) / tltIsC;
    unchngIsC = (unchngIsC * 100) / tltIsC;
    
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableDictionary *dict0 = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[dict0 setValue:[NSString stringWithFormat:@"%d", upC] forKey:@"title"];
    [dict0 setValue:@"" forKey:@"title"];
    [dict0 setValue:[NSNumber numberWithFloat:upC] forKey:@"value"];
    [components addObject:dict0];
    [dict0 release];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[dict1 setValue:[NSString stringWithFormat:@"%d", upC] forKey:@"title"];
    [dict1 setValue:@"" forKey:@"title"];
    [dict1 setValue:[NSNumber numberWithFloat:downC] forKey:@"value"];
    [components addObject:dict1];
    [dict1 release];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[dict1 setValue:[NSString stringWithFormat:@"%d", upC] forKey:@"title"];
    [dict1 setValue:@"" forKey:@"title"];
    [dict2 setValue:[NSNumber numberWithFloat:unchngIsC] forKey:@"value"];
    [components addObject:dict2];
    [dict2 release];
    
    // 디버그.
//    for (NSDictionary *dict in components) 
//    {
//        Debug(@">>>>>>>>>>>>>>>>%@", dict);
//    }
    
    return components;
}

// 등락종목 코스닥 파이 차트 용 데이터 생성.
- (NSMutableArray *)genDataForPieChartKosdaq:(NSDictionary *)data
{
    // 전체종목수(tltIsC), 상증종목수(upC, 상한 포함), 하락종목수(downC, 하한 포함), 보합종목수(unchngIsC).
    float tltIsC = 0;
    float upC = 0;
    float downC = 0;
    float unchngIsC = 0;
    
    for (NSString *key in [data allKeys])
    {
        if ([key isEqualToString:@"tltIsC"]) 
        {
            tltIsC = [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
        
        if ([key isEqualToString:@"upIsC"] || [key isEqualToString:@"uLmtIsC"]) 
        {
            upC += [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
        
        if ([key isEqualToString:@"dwnIsC"] || [key isEqualToString:@"lLmtIsC"]) 
        {
            downC += [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
        
        if ([key isEqualToString:@"unchngIsC"]) 
        {
            unchngIsC = [LPUtils convertStringToNumber:[data valueForKey:key]];
        }
    }
    
    upC = (upC * 100.0) / tltIsC;
    downC = (downC * 100.0) / tltIsC;
    unchngIsC = (unchngIsC * 100.0) / tltIsC;
    
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableDictionary *dict0 = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[dict0 setValue:[NSString stringWithFormat:@"%d", upC] forKey:@"title"];
    [dict0 setValue:@"" forKey:@"title"];
    [dict0 setValue:[NSNumber numberWithFloat:upC] forKey:@"value"];
    [components addObject:dict0];
    [dict0 release];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[dict1 setValue:[NSString stringWithFormat:@"%d", upC] forKey:@"title"];
    [dict1 setValue:@"" forKey:@"title"];
    [dict1 setValue:[NSNumber numberWithFloat:downC] forKey:@"value"];
    [components addObject:dict1];
    [dict1 release];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[dict2 setValue:[NSString stringWithFormat:@"%d", upC] forKey:@"title"];
    [dict2 setValue:@"" forKey:@"title"];
    [dict2 setValue:[NSNumber numberWithFloat:unchngIsC] forKey:@"value"];
    [components addObject:dict2];
    [dict2 release];
    
    // 디버그.
//    for (NSDictionary *dict in components) 
//    {
//        Debug(@">>>>>>>>>>>>>>>>%@", dict);
//    }
    
    return components;
}

// 업종테마흐름 세로 차트 용 데이터 생성.
- (NSMutableArray *)genDataForVBarChartTheme:(NSDictionary *)data
{
    NSMutableArray *themes = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [data objectForKey:@"grid"]) 
    {
        [themes addObject:dict];
    }
    
    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"upDwnR" ascending:NO] autorelease];
    [themes sortUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    NSMutableArray *sortedThemes = [[NSMutableArray alloc] init];
    sortedThemes = [themes copy];
    
    return sortedThemes;
}

// 코스피, 코스닥, 선물, 원/달러 리얼 지수를 위한 SB 등록.
- (void)regRealForIndexes
{
    
}

// TODO: 리팩토링(일반화)!!  
// 실시간지수 코스피.
- (void)settingRealForKospi
{
    NSString *queryString = [NSString stringWithFormat:@"%@&cd001", TRCD_JS01BASE];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[self fetchData:queryString]];
    
    int index = 0.0;                                        // 지수.
    int rest = 0;                                           // 소숫점 이하 2자리.
    float comparisonRate = 0.0;                             // 대비.
    float rate = 0.0;                                       // 대비율.
    int numberSign = 1;                                     // 등락에 따른 +, - 결정.
    int symbol = [[dict objectForKey:@"smbl"] intValue];    // 등락 심벌.
    UIColor *color = [UIColor whiteColor];
    
    switch (symbol) 
    {
        case 1:
        {
            self.kArrow.image = [UIImage imageNamed:@"icon_up_daily.png"];
            color = RGB(255, 133, 156);
            numberSign = 1;
            break;
        }
        case 2:
        {
            self.kArrow.image = [UIImage imageNamed:@"icon_up_daily.png"];
            color = RGB(255, 133, 156);
            numberSign = 1;
            break;
        }
        case 3:
        {
            self.kArrow.image = nil;
            color = [UIColor whiteColor];
            numberSign = 1;
            break;
        }
        case 4:
        {
            self.kArrow.image = [UIImage imageNamed:@"icon_down_daily.png"];
            color = RGB(125, 202, 241);
            numberSign = -1;
            break;
        }
        case 5:
        {
            self.kArrow.image = [UIImage imageNamed:@"icon_down_daily.png"];
            color = RGB(125, 202, 241);
            numberSign = -1;
            break;
        }
        default:
            break;
    }
    
    // 지수.
    NSString *stringIndex = [dict objectForKey:@"indx"];
    index = [[stringIndex substringToIndex:([stringIndex length] - 2)] intValue];
    rest = [[stringIndex substringFromIndex:([stringIndex length] - 2)] intValue];
    
    // 대비율 계산을 위해.
    stringIndex = [NSString stringWithFormat:@"%@.%@", [stringIndex substringToIndex:([stringIndex length] - 2)], [stringIndex substringFromIndex:([stringIndex length] - 2)]];
    float floatIndex = [stringIndex floatValue];
    
    // 대비.
    NSString *stringComparisonRate = [dict objectForKey:@"cmpr"];
    stringComparisonRate = [NSString stringWithFormat:@"%@.%@", [stringComparisonRate substringToIndex:([stringComparisonRate length] - 2)], [stringComparisonRate substringFromIndex:([stringComparisonRate length] - 2)]];
    comparisonRate = [stringComparisonRate floatValue];
    
    // 대비율 = (대비 * 100.0) / (지수 - (+/-대비)).
    rate = (comparisonRate * 100.0) / (floatIndex - (numberSign * comparisonRate));
    
    self.kIndex.text = [NSString stringWithFormat:@"%@.%d", [LPUtils formatNumber:index], rest];
    self.kFluctuation.text = stringComparisonRate;
    self.kFluctuation.textColor = color;
    self.kFluctuationRate.text = [NSString stringWithFormat:@"%.2f%%", rate];
    self.kFluctuationRate.textColor = color;
}

// 코스피 매매동향 가로 바차트.
- (void)drawHBarChartForKospi
{
    float height = 65.0;
    float width = 110.0;
    
    LPHBarChart *hBarChart = [[LPHBarChart alloc] initWithFrame:CGRectMake(98.0, 23.0, width, height)];
    [hBarChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [hBarChart setSameColorLabel:YES];
    hBarChart.barWidth = 11.0;
    [self.indexBg3 addSubview:hBarChart];
    [hBarChart release];
    
    hBarChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    // 데이터.
    NSMutableArray *dataArray = [self genDataForHBarChartKospi:self.hBarChartData];
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSDictionary *item = [dataArray objectAtIndex:i];
        LPHBarComponent *component = [LPHBarComponent barComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
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
    [dataArray release];
}

// 코스닥 매매동향 가로 바차트.
- (void)drawHBarChartForKosdaq
{
    float height = 65.0;
    float width = 110.0;
    
    LPHBarChart *hBarChart = [[LPHBarChart alloc] initWithFrame:CGRectMake(218.0, 23.0, width, height)];
    [hBarChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [hBarChart setSameColorLabel:YES];
    hBarChart.barWidth = 11.0;
    [self.indexBg3 addSubview:hBarChart];
    [hBarChart release];
    
    hBarChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    // 데이터.
    NSMutableArray *dataArray = [self genDataForHBarChartKosdaq:self.hBarChartData];
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSDictionary *item = [dataArray objectAtIndex:i];
        LPHBarComponent *component = [LPHBarComponent barComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
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
    [dataArray release];
}

// 코스티 등락종목 파이차트.
- (void)drawPieChartForKospi
{
    float height = 65.0;
    float width = 120.0;
    
    LPPieChart *pieChart = [[LPPieChart alloc] initWithFrame:CGRectMake(80.0, 25.0, width, height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setShowArrow:NO];
    [pieChart setDiameter:50.0];
    [pieChart setSameColorLabel:YES];
    
    [self.indexBg4 addSubview:pieChart];
    [pieChart release];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    
    // 데이터.
    NSMutableArray *dataArray = [self genDataForPieChartKospi:self.pieChartDataForKospi];
    NSMutableArray *components = [NSMutableArray array];
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSDictionary *item = [dataArray objectAtIndex:i];
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
    [dataArray release];
}

// 코스닥 등락종목 파이차트
- (void)drawPieChartForKosdaq
{
    float height = 65.0;
    float width = 120.0;
    
    LPPieChart *pieChart = [[LPPieChart alloc] initWithFrame:CGRectMake(200.0, 25.0, width, height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setShowArrow:NO];
    [pieChart setDiameter:50.0];
    [pieChart setSameColorLabel:YES];
    
    [self.indexBg4 addSubview:pieChart];
    [pieChart release];
    
    pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
    
    // 데이터.
    NSMutableArray *dataArray = [self genDataForPieChartKosdaq:self.pieChartDataForKosdaq];
    NSMutableArray *components = [NSMutableArray array];
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSDictionary *item = [dataArray objectAtIndex:i];
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
    [dataArray release];
}

// 업종테마흐름 세로 바 차트.
- (void)drawVBarChartForTheme
{
    // 데이터.
    NSMutableArray *dataArray = [self genDataForVBarChartTheme:self.vBarChartDataForTheme];
    
    self.val1.text = [NSString stringWithFormat:@"%@%%", [[dataArray objectAtIndex:0] objectForKey:@"upDwnR"]]; 
    self.title1.text = [[dataArray objectAtIndex:0] objectForKey:@"thmNm"];
    
    self.val2.text = [NSString stringWithFormat:@"%@%%", [[dataArray objectAtIndex:1] objectForKey:@"upDwnR"]]; 
    self.title2.text = [[dataArray objectAtIndex:1] objectForKey:@"thmNm"];
    
    self.val3.text = [NSString stringWithFormat:@"%@%%", [[dataArray objectAtIndex:2] objectForKey:@"upDwnR"]]; 
    self.title3.text = [[dataArray objectAtIndex:2] objectForKey:@"thmNm"];
    
    self.val4.text = [NSString stringWithFormat:@"%@%%", [[dataArray objectAtIndex:3] objectForKey:@"upDwnR"]]; 
    self.title4.text = [[dataArray objectAtIndex:3] objectForKey:@"thmNm"];
    
    self.val5.text = [NSString stringWithFormat:@"%@%%", [[dataArray objectAtIndex:4] objectForKey:@"upDwnR"]]; 
    self.title5.text = [[dataArray objectAtIndex:4] objectForKey:@"thmNm"];
    
    [dataArray release];
}

@end
