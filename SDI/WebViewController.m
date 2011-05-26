//
//  WebViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 27..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "WebViewController.h"
#import "NSObject+JSON.h"


@implementation WebViewController

@synthesize web;
@synthesize trCd;
@synthesize stockCode;
@synthesize jsFunction;

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
    [web release];
    [trCd release];
    [stockCode release];
    [jsFunction release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    // 이전화면 버튼.
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"이전화면" forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    // UITapGestureRecognizer 인스턴스 생성.
    UITapGestureRecognizer *recognizerTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeWebViewTapGesture:)] autorelease];
    recognizerTap.numberOfTapsRequired = 1;
    recognizerTap.delegate = self;
    [self.web addGestureRecognizer:recognizerTap];
    
    // RqRp, Real, history, login 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(runJavaScriptForRqRp:) name:@"RqRp" object:nil];
    [nc addObserver:self selector:@selector(configNotification:) name:@"Real" object:nil];
    [nc addObserver:self selector:@selector(runJavaScriptForHistory:) name:@"History" object:nil];
    [nc addObserver:self selector:@selector(runJavaScriptForLogin:) name:@"Login" object:nil];
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.200.2.47/common/html/list.html"]]];
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

// 웹뷰로 RQ/RP 데이터 전달.
- (void)runJavaScriptForRqRp:(NSNotification *)notification 
{
    // 트림 및 이스케이프 처리.
    NSString *data = [[notification userInfo] objectForKey:@"data"];
    data = [data stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    data = [data stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *jsCommand = [NSString stringWithFormat:@"%@('%@', '%@');", 
                           [[notification userInfo] objectForKey:@"jsName"],
                           [[notification userInfo] objectForKey:@"trCode"], 
                           data];

    [self.web stringByEvaluatingJavaScriptFromString:jsCommand];
}

// 웹뷰로 실시간 데이터 전달하기 위해...
- (void)configNotification:(NSNotification *)notification
{
    self.trCd = [[notification userInfo] objectForKey:@"trCode"];
    self.stockCode = [[notification userInfo] objectForKey:@"stockCode"];
    self.jsFunction = [[notification userInfo] objectForKey:@"jsName"];
    
    // 실시간 시세 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(runJavaScriptForReal:) name:self.trCd object:nil];
}

// 웹뷰로 실시간 데이터 전달.
- (void)runJavaScriptForReal:(NSNotification *)notification
{
    if ([self.stockCode isEqualToString:[[notification userInfo] objectForKey:@"isCd"]]) 
    {
        // JSON 포맷.
        NSString *json = [[notification userInfo] JSONRepresentation];
        json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        NSString *jsCommand = [NSString stringWithFormat:@"%@('%@', '%@');", 
                               self.jsFunction,
                               self.trCd, 
                               json];
        
        [self.web stringByEvaluatingJavaScriptFromString:jsCommand]; 
    }
}

// 웹뷰로 히스토리 데이터 전달.
- (void)runJavaScriptForHistory:(NSNotification *)notification
{
    // 데이터 포맷.
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:[[notification userInfo] objectForKey:@"data"] forKey:@"histories"];
    
    // JSON 포맷.
    NSString *json = [dataDict JSONRepresentation];
    
    // 이스케이프 처리.
    json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *jsCommand = [NSString stringWithFormat:@"%@('%@');", 
                           [[notification userInfo] objectForKey:@"jsName"],
                           json];
    
    [self.web stringByEvaluatingJavaScriptFromString:jsCommand];
}

// 웹뷰로 로그인 정보 전달.
- (void)runJavaScriptForLogin:(NSNotification *)notification
{
    // JSON 포맷.
    NSString *json = [[notification userInfo] JSONRepresentation];
    json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *jsCommand = [NSString stringWithFormat:@"%@('%@');", 
                           [[notification userInfo] objectForKey:@"jsName"],
                           json];

    [self.web stringByEvaluatingJavaScriptFromString:jsCommand]; 
}

// 웹뷰 제거.
- (void)removeWebViewTapGesture:(UITapGestureRecognizer *)recognizer
{
    // TODO: 애니메이션 효과 결정할 것!
    [self.web removeFromSuperview];
}

// 백버튼 액션.
- (IBAction)backAction:(id)sender
{
    Debug(@"Back button tapped!");
    [self.navigationController.view removeFromSuperview];
}

@end
