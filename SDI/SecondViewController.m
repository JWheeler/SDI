//
//  SecondViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SecondViewController.h"

#pragma mark - 프라이빗 메서드

@interface SecondViewController (Private)

- (void)captureImageFromPointAndSetupMaskView:(CGPoint)selectedFolderPoint;

- (void)layoutBottomPartOfMainViewRelativeToPointInMainView:(CGPoint)selectedFolderPoint;
- (void)layoutFinalFrameOfBottomPartOfMainContentView;

- (void)closeFolder:(CGPoint)selectedFolderPoint;

@end

@implementation SecondViewController (Private)

// 1 단계: 메인 뷰를 이미지로 갭춰. 
- (void)captureImageFromPointAndSetupMaskView:(CGPoint)selectedFolderPoint
{
    UIGraphicsBeginImageContext(mainBackgroundView.frame.size);
	// 메인 백그라운드 뷰 갭춰.
	[mainBackgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 앨범에 사진 저장: 테스트 용...
    //UIImageWriteToSavedPhotosAlbum(backgroundImage, self, nil, nil);
    
	[bottomPartOfMainBackgroundView setImage:backgroundImage];
    // 메인 뷰 이미지에서 폴더 뷰 위에서 보여지고 아래에서 감춰질 바운드 설정.
    // 화면에 폴더 뷰가 나타난 후 이미지에 효과를 지속 시킨다.
	[bottomPartOfMainBackgroundView.superview setBounds:CGRectMake(0.0, selectedFolderPoint.y + selectedArrowTipView.frame.size.height, mainBackgroundView.frame.size.width, mainBackgroundView.frame.size.height)];
    
    NSLog(@"mainBackgroundView frame: %@", NSStringFromCGRect(mainBackgroundView.frame));
}

// 2 단계: 폴더 뷰(Layer 2와 2-1)과 메인 뷰의 아랫 부분(Layer 3) 레이아웃 설정.
- (void)layoutBottomPartOfMainViewRelativeToPointInMainView:(CGPoint)selectedFolderPoint
{
	// 폴더 뷰를 화살표 뷰 아래에 위치시킴.
	CGRect folderViewFrame = [folderView frame];
	folderViewFrame.origin.y = floorf(selectedFolderPoint.y);
    [folderView setFrame:folderViewFrame];	
	
    // 메인 백그라운드 뷰의 아랫 부분이 폴더 뷰 아래에 표시되게 만듬.
	CGRect maskFrame = bottomPartOfMainBackgroundView.superview.frame;
	maskFrame.origin.y = folderViewFrame.origin.y + selectedArrowTipView.frame.size.height;
	bottomPartOfMainBackgroundView.superview.frame = maskFrame;
	
    // 화살표를 탭한 아이콘의 중앙 아래에 위치 시킴.
	[UIView setAnimationsEnabled:NO];
	selectedArrowTipView.center = CGPointMake(selectedFolderPoint.x, 0.0);
	CGRect arrowFrame = selectedArrowTipView.frame;
	arrowFrame.origin.y = 0.0;
	selectedArrowTipView.frame = arrowFrame;
    
	[UIView setAnimationsEnabled:YES];
}

// 3 단계: 메인 뷰의 나머지 부분(Layer 3) 설정.
- (void)layoutFinalFrameOfBottomPartOfMainContentView
{
	CGRect maskFrame = bottomPartOfMainBackgroundView.superview.frame;
	maskFrame.origin.y = folderView.frame.origin.y + folderView.frame.size.height;
	bottomPartOfMainBackgroundView.superview.frame = maskFrame;
    // 알파값 조절.
    bottomPartOfMainBackgroundView.alpha = 0.75;
    mainBackgroundView.alpha = 0.75;
}

- (void)closeFolder:(CGPoint)selectedFolderPoint
{
	[self layoutBottomPartOfMainViewRelativeToPointInMainView:selectedFolderPoint];
}

@end


@implementation SecondViewController

@synthesize menuGroups;

@synthesize mainBackgroundView;
@synthesize folderView;
@synthesize selectedArrowTipView;
@synthesize bottomPartOfMainBackgroundView;
@synthesize folderIcon;

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
    [menuGroups release];
    self.mainBackgroundView = nil;
	self.folderView = nil;
	self.selectedArrowTipView = nil;
	self.bottomPartOfMainBackgroundView = nil;
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
    
    // 전체 메뉴그룹(1차 메뉴) 로드.
    self.menuGroups = [[NSArray alloc] init];
	self.menuGroups = [self loadMenuGroups];
	
	// 메인 메뉴.
	[self createButtons];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.menuGroups = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 커스텀 메서드

// 메뉴그룹 로드.
- (NSMutableArray *)loadMenuGroups 
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuGroup" ofType:@"plist"];
	NSMutableArray *menuGroupList = [[NSMutableArray alloc] initWithContentsOfFile:path];
	return [menuGroupList autorelease];
}

// 메뉴 버튼 생성.
- (void)createButtons 
{
	// O 번을 전체메뉴에서 제목으로 사용하기 때문에 전체 수는 -1하고 인덱스는 +1 할 것.
    for (int row = 0; row < BUTTON_ROWS; ++row) 
    {
        for (int col = 0; col < BUTTON_COLUMNS; ++col) 
        {
            int index = (row * BUTTON_COLUMNS) + col;
            CGRect frame = CGRectMake(BUTTON_START_X + BUTTON_MARGIN + col * (BUTTON_MARGIN + BUTTON_WIDTH),
                                      BUTTON_START_Y + BUTTON_MARGIN + row * ((BUTTON_MARGIN) + BUTTON_HEIGHT),
                                      BUTTON_WIDTH, BUTTON_HEIGHT);
            buttonFrame[index] = frame;
            UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            
            buttonForFrame[index] = button;
            button.frame = frame;
			button.tag = index;
			[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			UIImage *buttonBackground = [UIImage imageNamed:[[menuGroups objectAtIndex:index] objectForKey:@"icon"]];
            //UIImage *buttonBackground = [UIImage imageNamed:@"menu_stock.png"];
			[button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
            
            [self.view addSubview:button];
            [button setNeedsDisplay];
            [button release];
            Debug(@">>>>>>>>>>>>>>>>>%@", [[menuGroups objectAtIndex:index] objectForKey:@"icon"]);
		}
    }
}

// 메인 메뉴 버튼 액션.
- (IBAction)buttonPressed:(id)sender 
{
	// TODO:버튼 별 케이스 처리.
	UIButton *button = (UIButton *)sender;
	int buttonTag = button.tag;
	Debug(@"Button pressed: %d", buttonTag);
	// !!! 전체메뉴 UI 때문에 0번 데이터를 넣었다. 그러므로 실제 +1 해야 한다.
	int menuIndex = buttonTag + 1;
	switch (buttonTag) {
		case 0: 
        {
			
			break;
		}
		default: 
        {
			break;
		}
	}
}

#pragma mark - 폴더 애니메이션 관련 커스텀 메서드

- (IBAction)openFolder:(id)sender
{		
    // 탭한 폴더의 센터.
	CGPoint selectedFolderPoint = CGPointMake([sender center].x, [sender frame].origin.y + [sender frame].size.height);
    
	if (folderView.hidden) // 만약 폴더가 열려 있지 않으면...
	{
		// 폴더 열기 애니메이션.
		// 1 단계: 메인 뷰를 이미지로 갭춰. 
		[self captureImageFromPointAndSetupMaskView:selectedFolderPoint];
		
		// 2 단계: 폴더 뷰(Layer 2와 2-1)과 메인 뷰의 아랫 부분(Layer 3) 레이아웃 설정.
		[self layoutBottomPartOfMainViewRelativeToPointInMainView:selectedFolderPoint];
		
		[UIView beginAnimations:@"FolderOpen" context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		
		// 메인 백그라운드 뷰의 이미지 캡춰.
		
		folderView.hidden = NO;
		bottomPartOfMainBackgroundView.superview.hidden = NO;
        
		// 3 단계: 메인 뷰의 나머지 부분(Layer 3) 설정.
		[self layoutFinalFrameOfBottomPartOfMainContentView];
		[UIView commitAnimations];
	}
	else 
    {
		// 폴더 닫기 애니메이션.
		[UIView beginAnimations:@"FolderClose" context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDidStopSelector:@selector(animation:didFinish:context:)];
		[UIView setAnimationDelegate:self];
		// 애니메이션 종료 후 레이아웃과 폴더 뷰 감추기.
		[self closeFolder:selectedFolderPoint];
		[UIView commitAnimations];
	}
}

- (void)animation:(NSString*)animation didFinish:(BOOL)finish context:(void *)context
{
    if ([animation isEqualToString:@"FolderClose"])
    {
        folderView.hidden = YES;
        bottomPartOfMainBackgroundView.superview.hidden = YES;
        // 알파값 원상 복귀.
        mainBackgroundView.alpha = 1.0;
    }
}

#define MAX_BOTTOM_PLACE_FOR_FOLDER_ICON 390    // 버튼 이동 제한.

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (folderView.hidden)
	{
		CGPoint touchPoint = [[touches anyObject] locationInView:mainBackgroundView];
		if (touchPoint.y > MAX_BOTTOM_PLACE_FOR_FOLDER_ICON)
		{
			touchPoint.y = MAX_BOTTOM_PLACE_FOR_FOLDER_ICON;	
		}
		
		folderIcon.center = touchPoint;
		
		
		
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (folderView.hidden)
	{
        CGPoint touchPoint = [[touches anyObject] locationInView:mainBackgroundView];
		if (touchPoint.y > MAX_BOTTOM_PLACE_FOR_FOLDER_ICON)
		{
			touchPoint.y = MAX_BOTTOM_PLACE_FOR_FOLDER_ICON;	
		}
		folderIcon.center = touchPoint;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (folderView.hidden)
	{
		CGPoint touchPoint = [[touches anyObject] locationInView:mainBackgroundView];
		if (touchPoint.y > MAX_BOTTOM_PLACE_FOR_FOLDER_ICON)
		{
			touchPoint.y = MAX_BOTTOM_PLACE_FOR_FOLDER_ICON;	
		}
		folderIcon.center = touchPoint;
	}
	
}

@end
