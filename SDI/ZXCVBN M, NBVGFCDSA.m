//
//  WebViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 27..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "WebViewController.h"
#import "NSObject+JSON.h"
#import "NSString+LPCategory.h"


@implementation WebViewController

@synthesize web;
@synthesize url;
@synthesize trCd;
@synthesize stockCode;
@synthesize jsFunction;

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
    [web release];
    [url release];
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
    
    // RqRp, Real, history, login, addNaviButton 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(runJavaScriptForRqRp:) name:@"RqRp" object:nil];
    [nc addObserver:self selector:@selector(configNotification:) name:@"Real" object:nil];
    [nc addObserver:self selector:@selector(runJavaScriptForHistory:) name:@"History" object:nil];
    [nc addObserver:self selector:@selector(runJavaScriptForLogin:) name:@"Login" object:nil];
    [nc addObserver:self selector:@selector(addNaviButton:) name:@"AddNaviButton" object:nil];
    
    // 테스트.
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

#pragma mark - 웹뷰 델리게이트

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    Debug(@"Current page URL: %@", self.url);
	
	NSURL *reqUrl = [request URL];
	NSString *scheme = [[request URL] scheme];
	NSString *pathExtension = [[reqUrl pathExtension] lowercaseString];
#ifdef DEBUG
	Debug(@"Path extension: %@", [reqUrl pathExtension]);
	Debug(@"url recieved: %@", reqUrl);
    Debug(@"query string: %@", [reqUrl query]);
    Debug(@"host: %@", [reqUrl host]);
    Debug(@"url path: %@", [reqUrl path]);
    NSDictionary *dict = [self parseQueryString:[reqUrl query]];
	Debug(@"query dict: %@", dict);
#endif
    
    // 커스텀 URL 처리.
	// !!!: 케이스가 늘어날 경우 추가할 것.
	if ([@"smp" isEqual:scheme]) 
    {
		[[UIApplication sharedApplication] openURL:reqUrl];
		return NO;
	}
    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    // 제목.
    self.title = [self.web stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
	
}

#pragma mark - 커스텀 메서드

// 쿼리스트링 파싱.
- (NSDictionary *)parseQueryString:(NSString *)query 
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:7] autorelease];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) 
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		// val 이 nil인 경우 예외 처리!
		if (val != nil) 
        {
			// 변경 없음.
		}
        else 
        {
			val = @"";
		}
		
		[dict setObject:val forKey:key];
        
    }
    
    return dict;
}

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

// 네비게이션에 버튼 추가.
- (void)addNaviButton:(NSNotification *)notification
{
    NSString *buttonType = [[notification userInfo] objectForKey:@"buttonType"];
    self.url = [[notification userInfo] objectForKey:@"target"];
    self.jsFunction = [[notification userInfo] objectForKey:@"jsName"];
    
    switch ([buttonType intValue]) 
    {
        case 0:
        {
            // 리프레쉬 버튼.
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
            self.navigationItem.rightBarButtonItem = button;
            [button release];
            break;
        }
            
        case 1:
        {
            // 팝업레이어 버튼(검색).
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"검색" style:UIBarButtonItemStylePlain target:self action:@selector(openPopup:)];
            self.navigationItem.rightBarButtonItem = button;
            [button release];
            break;
        }
            
        case 2:
        {
            // !!!: 케이스별로 버튼의 이름 결정.
            // 페이지 이동.
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"이동" style:UIBarButtonItemStylePlain target:self action:@selector(goToPage:)];
            self.navigationItem.rightBarButtonItem = button;
            [button release];
            break;
        }
            
        default:
            break;
    }
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

// 웹뷰 리프레쉬.
- (void)refresh:(id)sender
{
    [self.web reload];
}

// 오픈 팝업: 검색 화면.
- (void)openPopup:(id)sender
{
    NSString *jsCommand = [NSString stringWithFormat:@"%@();", self.jsFunction];
    [self.web stringByEvaluatingJavaScriptFromString:jsCommand]; 
}

// 페이지 이동.
- (void)goToPage:(id)sender
{
    if (self.url != nil) 
    {
        /**
         *  !!!: 인코딩 확인 필요.
         1. CP949: CFStringConvertEncodingToNSStringEncoding(0x0422)
         2. EUC-KR: -2147481280
         3. NSASCIIStringEncoding
         4. NSUTF8StringEncoding
         */
        Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@", self.url);
        NSString *decoded = [self.url stringByUrlDecoding];  //[self.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@", decoded);
		[self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:decoded]]];
	}
}

@end
