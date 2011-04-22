//
//  SecondViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 폴더 애니메이션 관련 좌표 세부 조정 필요!
//

#import "SecondViewController.h"
#import "SDIAppDelegate.h"

#define COORDINATE_REVSE 20


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
    UIGraphicsBeginImageContext(mainBackgroundView.window.frame.size);
    // FIXME: 화면 상단의 20 포인트 공백 문제 해결: 현제는 좌표 조정으로 처리함!
    // 전체 화면 갭춰.    
    [mainBackgroundView.window.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 앨범에 사진 저장: 테스트 용...
    //UIImageWriteToSavedPhotosAlbum(backgroundImage, self, nil, nil);
    
	[bottomPartOfMainBackgroundView setImage:backgroundImage];
    // 메인 뷰 이미지에서 폴더 뷰 위에서 보여지고 아래에서 감춰질 바운드 설정.
    // 화면에 폴더 뷰가 나타난 후 이미지에 효과를 지속 시킨다.
    [bottomPartOfMainBackgroundView.superview setBounds:CGRectMake(0.0, selectedFolderPoint.y + selectedArrowTipView.frame.size.height + COORDINATE_REVSE, mainBackgroundView.window.frame.size.width, mainBackgroundView.window.frame.size.height + COORDINATE_REVSE)];
    
    Debug(@"mainBackgroundView frame: %@", NSStringFromCGRect(mainBackgroundView.frame));
    Debug(@"bottomPartOfMainBackgroundView frame: %@", NSStringFromCGRect(bottomPartOfMainBackgroundView.frame));
}

// 2 단계: 폴더 뷰(Layer 2와 2-1)와 메인 뷰의 아랫 부분(Layer 3) 레이아웃 설정.
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
    
    Debug(@"maskFrame frame: %@", NSStringFromCGRect(maskFrame));
	
    // 화살표를 탭한 아이콘의 중앙 아래에 위치 시킴.
	[UIView setAnimationsEnabled:NO];
	selectedArrowTipView.center = CGPointMake(selectedFolderPoint.x, 0.0);
	CGRect arrowFrame = selectedArrowTipView.frame;
	arrowFrame.origin.y = 1.0;                  // 폴더뷰와 1픽셀 겹침.
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
@synthesize menus;
@synthesize filteredMenus;

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
    [menus release];
    [filteredMenus release];
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
    //self.menuGroups = [[NSMutableArray alloc] init];
	self.menuGroups = [self loadMenuGroups];
    
    // 전체 메뉴 로드.
    //self.menus = [[NSMutableArray alloc] init];
    self.menus = [self loadMenus];
	
	// 메인 메뉴.
	[self createButtons];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.menuGroups = nil;
    self.menus = nil;
    self.filteredMenus = nil;
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

// 메뉴 로드.
- (NSMutableArray *)loadMenus
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
	NSMutableArray *menuList = [[NSMutableArray alloc] initWithContentsOfFile:path];
	return [menuList autorelease];
}

// 그룹별 메뉴 검색.
- (void)filteredMenus:(NSInteger)groupID
{
    self.filteredMenus = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.menus) 
    {
        if ([[dict objectForKey:@"groupID"] isEqualToString:[NSString stringWithFormat:@"%d", groupID]]) 
        {
            [self.filteredMenus addObject:dict];
        }
    }
}

// 메뉴 버튼 생성.
- (void)createButtons 
{
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
			[button addTarget:self action:@selector(openFolder:) forControlEvents:UIControlEventTouchUpInside];
			UIImage *buttonBackground = [UIImage imageNamed:[[menuGroups objectAtIndex:index] objectForKey:@"icon"]];
			[button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
            
            [self.mainBackgroundView addSubview:button];
            [button setNeedsDisplay];
            [button release];
		}
    }
}

// 서브 메뉴 버튼 생성: 버튼의 태그 == groupID.
- (void)createSubButton:(NSInteger)groupID
{   
    [self filteredMenus:groupID];
    int subButtonRow = [self.filteredMenus count] / SUB_BUTTON_COLUMNS;
    
    for (int row = 0; row < subButtonRow; ++row)
    {
        for (int col = 0; col < SUB_BUTTON_COLUMNS; ++col) 
        {
            int index = (row * SUB_BUTTON_COLUMNS) + col;
            CGRect frame = CGRectMake(SUB_BUTTON_START_X + col * (SUB_BUTTON_MARGIN + SUB_BUTTON_WIDTH),
                                      SUB_BUTTON_START_Y + row * ((SUB_BUTTON_MARGIN) + SUB_BUTTON_HEIGHT),
                                      SUB_BUTTON_WIDTH, SUB_BUTTON_HEIGHT);
            subButtonFrame[index] = frame;
            UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            
            subButtonForFrame[index] = button;
            button.frame = frame;
			button.tag = index;
			[button addTarget:self action:@selector(openTarget:) forControlEvents:UIControlEventTouchUpInside];
            UIImage *buttonBackground = [UIImage imageNamed:@"depth_box.png"];
            [button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
            
            [self.folderView addSubview:button];
            [button setNeedsDisplay];
            [button release];
        }
    }
}

// 서브 메뉴 버튼 액션.
- (IBAction)openTarget:(id)sender
{
	// TODO:버튼 별 케이스 처리.
	UIButton *button = (UIButton *)sender;
	int buttonTag = button.tag;
	Debug(@"Button pressed: %d", buttonTag);
	
	switch (buttonTag) 
    {
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
	// 선택한 버튼의 태그.
    UIButton *selectedButton = (UIButton *)sender;
    
    // 버튼의 원래 center;
    CGPoint orginCenter = selectedButton.center;
    
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
        
        // 현재 뷰의 위로...        
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:bottomPartOfMainBackgroundView.superview];
        selectedButton.center = CGPointMake(orginCenter.x, orginCenter.y + COORDINATE_REVSE);
        [appDelegate.window addSubview:selectedButton];
        
		// 3 단계: 메인 뷰의 나머지 부분(Layer 3) 설정.
		[self layoutFinalFrameOfBottomPartOfMainContentView];
		[UIView commitAnimations];
        
        // 4 단계: 선택한 이외의 버튼 상태 변경.
        [self changeButtonState:selectedButton.tag withType:NO];
        
        // 5 단계: 서브 메뉴 버튼 생성.
        [self createSubButton:selectedButton.tag];
	}
	else 
    {
		// 1단계: 폴더 닫기 애니메이션.
		[UIView beginAnimations:@"FolderClose" context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDidStopSelector:@selector(animation:didFinish:context:)];
		[UIView setAnimationDelegate:self];
        
		// 애니메이션 종료 후 레이아웃과 폴더 뷰 감추기.
		[self closeFolder:selectedFolderPoint];
        
        // 버튼 원상복귀.
        selectedButton.center = CGPointMake(orginCenter.x, orginCenter.y - COORDINATE_REVSE);
        [mainBackgroundView addSubview:selectedButton];
		[UIView commitAnimations];
        
        // 2 단계: 선택한 이외의 버튼 상태 변경.
        [self changeButtonState:selectedButton.tag withType:YES];
	}
}

// 애니메이션 종료.
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

// 메뉴 버튼의 상태 변경.
- (void)changeButtonState:(NSInteger)buttonTag withType:(BOOL)type
{
    for (int i = 0; i < (BUTTON_COLUMNS * BUTTON_ROWS); i++) 
    {
        if (buttonTag != i) 
        {
            buttonForFrame[i].userInteractionEnabled = type;
        }
    }
}

// 버튼 이동 제한.
//#define MAX_BOTTOM_PLACE_FOR_FOLDER_ICON 390    
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	if (folderView.hidden)
//	{
//		CGPoint touchPoint = [[touches anyObject] locationInView:mainBackgroundView];
//		if (touchPoint.y > MAX_BOTTOM_PLACE_FOR_FOLDER_ICON)
//		{
//			touchPoint.y = MAX_BOTTOM_PLACE_FOR_FOLDER_ICON;	
//		}
//		
//		folderIcon.center = touchPoint;
//		
//		
//		
//	}
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	if (folderView.hidden)
//	{
//        CGPoint touchPoint = [[touches anyObject] locationInView:mainBackgroundView];
//		if (touchPoint.y > MAX_BOTTOM_PLACE_FOR_FOLDER_ICON)
//		{
//			touchPoint.y = MAX_BOTTOM_PLACE_FOR_FOLDER_ICON;	
//		}
//		folderIcon.center = touchPoint;
//	}
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	if (folderView.hidden)
//	{
//		CGPoint touchPoint = [[touches anyObject] locationInView:mainBackgroundView];
//		if (touchPoint.y > MAX_BOTTOM_PLACE_FOR_FOLDER_ICON)
//		{
//			touchPoint.y = MAX_BOTTOM_PLACE_FOR_FOLDER_ICON;	
//		}
//		folderIcon.center = touchPoint;
//	}
//	
//}

@end
