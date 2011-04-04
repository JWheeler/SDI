//
//  MyMenuViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MyMenuViewController.h"
#import "MyMenuView.h"


@implementation MyMenuViewController

@synthesize scrollMyMenuView;

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
    [scrollMyMenuView release];
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
    
    // 마이메뉴 설정.
    [self setMyMenu];
    
    // UITapGestureRecognizer 인스턴스 생성.
    UITapGestureRecognizer *recognizerTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMyMenuTapGesture:)] autorelease];
    recognizerTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizerTap];
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

-(void)setMyMenu
{
    // TODO: DB또는 파일에서 정보 로딩하도록 수정!
    // 세로 스크롤 메뉴에 사용할 버튼 생성(20 개).
	NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    
	for (int i = 0; i < 20; i++) 
    {
		// 커스텀 타입의 버튼 생성.
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		
		// 버튼 이미지 사이즈: 130 * 39.
		NSString *imageName = [NSString stringWithFormat:@"%d", i];
		imageName = [imageName stringByAppendingString:@".png"];
		UIImage *buttonBackground = [UIImage imageNamed:imageName];
		
		[btn setFrame:CGRectMake(0.0, 0.0, 130.0, 39.0)];
		[btn setBackgroundImage:buttonBackground forState:UIControlStateNormal];
		[btn setTag:i];	
		[btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[buttonArray addObject:btn];
		[btn release];
	}
	
	// 세로 스크롤 메뉴 초기화.
    scrollMyMenuView = [[MyMenuView alloc] initWithFrameAndButtons:CGRectMake(0.0, 0.0, 320.0, 480.0) buttons:buttonArray];
	
	// 스크롤메뉴뷰 추가.
	[self.view addSubview:scrollMyMenuView];
}

- (IBAction)buttonPressed:(id)sender 
{
	Debug(@"Button tapped: %d", ((UIButton *)sender).tag);
}

// 마이메뉴 제거.
- (void)removeMyMenuTapGesture:(UITapGestureRecognizer *)recognizer
{
    // TODO: 애니메이션 효과 결정할 것!
    [self.view removeFromSuperview];
}

@end
