//
//  SecondViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 버튼 타겟 설정.
//  TODO: 폴더 닫히는 애니메이션 시 좌표 세부 조정.
//

#import "SecondViewController.h"
#import "SDIAppDelegate.h"
#import "WebViewController.h"

#define ContentViewFrame CGRectMake(0.0, 20.0, 320.0, 460);


#pragma mark - 프라이빗 클래스

@interface SecondViewController (Private)

- (void)reviseButtonCoordinate:(NSInteger)selectedButtonTag isOpen:(BOOL)status;

- (void)captureImageFromPointAndSetupMaskView:(CGPoint)selectedFolderPoint withSelectedButtonTag:(NSInteger)selectedButtonTag isOpen:(BOOL)status;

- (void)layoutBottomPartOfMainViewRelativeToPointInMainView:(CGPoint)selectedFolderPoint withSelectedButtonTag:(NSInteger)selectedButtonTag isOpen:(BOOL)status;
- (void)layoutFinalFrameOfBottomPartOfMainContentViewWithSelectedButtonTag:(NSInteger)selectedButtonTag isOpen:(BOOL)status;

- (void)closeFolder:(CGPoint)selectedFolderPoint withSelectedButtonTag:(NSInteger)selectedButtonTag;

@end

@implementation SecondViewController (Private)

// 0 단계: 버튼 좌표 보정.
- (void)reviseButtonCoordinate:(NSInteger)selectedButtonTag isOpen:(BOOL)status
{
    // 보정할 Y축 좌표.
    float coordinateRevise = [self coordinateRevise:selectedButtonTag isOpen:status];
    
    for (UIButton *button in self.mainBackgroundView.subviews) 
    {
        if ([button isKindOfClass:[UIButton class]]) 
        {
            button.center = CGPointMake(button.center.x, button.center.y + coordinateRevise);
        }
    }
}

// 1 단계: 메인 뷰를 이미지로 갭춰. 
- (void)captureImageFromPointAndSetupMaskView:(CGPoint)selectedFolderPoint withSelectedButtonTag:(NSInteger)selectedButtonTag isOpen:(BOOL)status
{
    UIGraphicsBeginImageContext(mainBackgroundView.window.frame.size);
    // FIXME: 화면 상단의 20 포인트 공백 문제 해결: 현제는 좌표 조정으로 처리함!
    // 전체 화면 갭춰.    
    [mainBackgroundView.window.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 앨범에 사진 저장: 테스트 용...
    //UIImageWriteToSavedPhotosAlbum(backgroundImage, self, nil, nil);
    
    // 예외 처리할 버튼을 선택할 경우...
    float coordinateRevise = 0;
    BOOL isException = [self isException:selectedButtonTag];
    if (isException) 
    {
        coordinateRevise = [self coordinateRevise:selectedButtonTag isOpen:status];
    } 
    
	[bottomPartOfMainBackgroundView setImage:backgroundImage];
    // 메인 뷰 이미지에서 폴더 뷰 위에서 보여지고 아래에서 감춰질 바운드 설정.
    // 화면에 폴더 뷰가 나타난 후 이미지에 효과를 지속 시킨다.
    [bottomPartOfMainBackgroundView.superview setBounds:
     CGRectMake(0.0, 
                selectedFolderPoint.y + selectedArrowTipView.frame.size.height + COORDINATE_REVISE + coordinateRevise, 
                mainBackgroundView.window.frame.size.width, 
                mainBackgroundView.window.frame.size.height + COORDINATE_REVISE)];
    
    Debug(@"mainBackgroundView frame: %@", NSStringFromCGRect(mainBackgroundView.frame));
    Debug(@"bottomPartOfMainBackgroundView frame: %@", NSStringFromCGRect(bottomPartOfMainBackgroundView.frame));
}

// 2 단계: 폴더 뷰(Layer 2와 2-1)와 메인 뷰의 아랫 부분(Layer 3) 레이아웃 설정.
- (void)layoutBottomPartOfMainViewRelativeToPointInMainView:(CGPoint)selectedFolderPoint withSelectedButtonTag:(NSInteger)selectedButtonTag isOpen:(BOOL)status
{
    // 예외 처리할 버튼을 선택할 경우...
    float coordinateRevise = 0;
    BOOL isException = [self isException:selectedButtonTag];
    if (isException) 
    {
        coordinateRevise = [self coordinateRevise:selectedButtonTag isOpen:status];
    } 
    
    // 폴더를 열 때 슈퍼뷰로 이동시키기 위해 선택된 버튼의 좌표를 COORDINATE_REVISE 만클 + 변경했다.
    // 그래서 폴더를 닫을 때는 그만큼 빼준다. 물론 예외 처리한 경우에는 그에 따른 보정을 해줘야 한다.
    if (!status) 
    {
        selectedFolderPoint.y -= COORDINATE_REVISE;
    }
    
    CGRect folderViewFrame;
    // 서브 메뉴의 갯수가 4개 이하일 경우...
    if ([self.filteredMenus count] <= SUB_BUTTON_COLUMNS) 
    {
        // 폴더 뷰를 화살표 뷰 아래에 위치시킴.	
        folderViewFrame = CGRectMake(0.0, 0.0, 320.0, 137.0);
        folderViewFrame.origin.y = floorf(selectedFolderPoint.y + coordinateRevise);  
        [folderView setFrame:folderViewFrame];	
        [folderView bringSubviewToFront:folderViewBackgroundView];
        [folderView bringSubviewToFront:selectedArrowTipView];
        
        // 메인 백그라운드 뷰의 아랫 부분이 폴더 뷰 아래에 표시되게 만듬.
        CGRect maskFrame = bottomPartOfMainBackgroundView.superview.frame;
        maskFrame.origin.y = folderViewFrame.origin.y + selectedArrowTipView.frame.size.height + coordinateRevise;
        bottomPartOfMainBackgroundView.superview.frame = maskFrame;
        
        // 화살표를 탭한 아이콘의 중앙 아래에 위치 시킴.
        [UIView setAnimationsEnabled:NO];
        selectedArrowTipView.center = CGPointMake(selectedFolderPoint.x, 0.0);
        CGRect arrowFrame = selectedArrowTipView.frame;
        arrowFrame.origin.y = 0.0;
        selectedArrowTipView.frame = arrowFrame;
        [UIView setAnimationsEnabled:YES];
    }
    else    // 서브 메뉴의 갯수가 4개 이상일 경우...
    {
        // 폴더 뷰를 화살표 뷰 아래에 위치시킴.
        folderViewFrame = CGRectMake(0.0, 0.0, 320.0, 280.0);
        folderViewFrame.origin.y = floorf(selectedFolderPoint.y + coordinateRevise);  
        [folderView setFrame:folderViewFrame];
        [folderView bringSubviewToFront:folderViewBackgroundView2];
        [folderView bringSubviewToFront:selectedArrowTipView];
        
        // 메인 백그라운드 뷰의 아랫 부분이 폴더 뷰 아래에 표시되게 만듬.
        CGRect maskFrame = bottomPartOfMainBackgroundView.superview.frame;
        maskFrame.origin.y = folderViewFrame.origin.y + selectedArrowTipView.frame.size.height + coordinateRevise;
        bottomPartOfMainBackgroundView.superview.frame = maskFrame;
        
        // 화살표를 탭한 아이콘의 중앙 아래에 위치 시킴.
        [UIView setAnimationsEnabled:NO];
        selectedArrowTipView.center = CGPointMake(selectedFolderPoint.x, 0.0);
        CGRect arrowFrame = selectedArrowTipView.frame;
        arrowFrame.origin.y = 0.0;
        selectedArrowTipView.frame = arrowFrame;
        [UIView setAnimationsEnabled:YES];
    }
    
    Debug(@"folderView frame: %@", NSStringFromCGRect(folderViewFrame));
}

// 3 단계: 메인 뷰의 나머지 부분(Layer 3) 설정.
- (void)layoutFinalFrameOfBottomPartOfMainContentViewWithSelectedButtonTag:(NSInteger)selectedButtonTag isOpen:(BOOL)status
{
    // TODO: 일반화 시켜야 함.
    float coordinateRevise = 0;
    if ([self isException:selectedButtonTag]) 
    {
        if (selectedButtonTag == 14 || selectedButtonTag == 15 || selectedButtonTag == 16) 
        {
            coordinateRevise = 0;
        }
        else
        {
            coordinateRevise = - ONE_STEP_REVISE;
        }
    }
    
    CGRect maskFrame = bottomPartOfMainBackgroundView.superview.frame;
    maskFrame.origin.y = folderView.frame.origin.y + folderView.frame.size.height + coordinateRevise;
    bottomPartOfMainBackgroundView.superview.frame = maskFrame;
    Debug(@"maskFrame frame: %@", NSStringFromCGRect(maskFrame));
    
    // 알파값 조절.
    bottomPartOfMainBackgroundView.alpha = 0.75;
    mainBackgroundView.alpha = 0.75;
}

- (void)closeFolder:(CGPoint)selectedFolderPoint withSelectedButtonTag:(NSInteger)selectedButtonTag
{
	[self layoutBottomPartOfMainViewRelativeToPointInMainView:selectedFolderPoint withSelectedButtonTag:selectedButtonTag isOpen:NO];
}

@end


@implementation SecondViewController

@synthesize menuGroups;
@synthesize menus;
@synthesize filteredMenus;

@synthesize mainBackgroundView;
@synthesize folderView;
@synthesize folderViewBackgroundView;
@synthesize folderViewBackgroundView2;
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
    self.folderViewBackgroundView = nil;
    folderViewBackgroundView2 = nil;
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
	self.menuGroups = [self loadMenuGroups];
    
    // 전체 메뉴 로드.
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
            
            // 서브메뉴가 없어서 메뉴 그룹에서 바로 이동할 경우.
            // 9: 신탁, 10: WRAP, 12: 나의자산환현황, 19: 지점안내.
            if (index == 9 || index == 10 || index == 12 || index == 19) 
            {
                [button addTarget:self action:@selector(openTarget:) forControlEvents:UIControlEventTouchUpInside];
            }
            else // 폴더 애니메이션 적용.
            {
                [button addTarget:self action:@selector(openFolder:) forControlEvents:UIControlEventTouchUpInside];
            }
			
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
    // 서브 메뉴 타이틀.
    UIImage *image = [UIImage imageNamed:[[menuGroups objectAtIndex:groupID] objectForKey:@"titleIcon"]];
    UIImageView *subTitle = [[UIImageView alloc] initWithImage:image];
    subTitle.frame = CGRectMake(SUB_MENU_TITLE_X, SUB_MENU_TITLE_Y, image.size.width, image.size.height);
    subTitle.tag = SUB_MENU_TITLE_TAG;
    [self.folderView addSubview:subTitle];
    [subTitle release];
    
    // 서브 메뉴의 최대 갯수는 현재 7개임!
    int subButtonCount = [self.filteredMenus count];
    int subButtonCol = 0;
    int subButtonRow = 0;
    
    if (subButtonCount > 4) 
        subButtonRow = 2;
    else
        subButtonRow = 1;
    
    for (int row = 0; row < subButtonRow; ++row)
    {
        if (row == 0) 
        {
            if (subButtonCount > 4) 
                subButtonCol = SUB_BUTTON_COLUMNS;
            else
                subButtonCol = subButtonCount;
        }
        if (row == 1) 
        {
            subButtonCol = subButtonCount % SUB_BUTTON_COLUMNS;
        }
        
        for (int col = 0; col < subButtonCol; col++) 
        {
            int index = (row * subButtonCol) + col;
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
            
            // 서브 메뉴 타이틀.
            UIImageView *subMenuTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self.filteredMenus objectAtIndex:index] objectForKey:@"iconForTotal"]]];
            subMenuTitle.frame = CGRectMake(0.0, 0.0, SUB_BUTTON_WIDTH, SUB_BUTTON_HEIGHT);
            [button addSubview:subMenuTitle];
            [subMenuTitle release];
            
            [self.folderView addSubview:button];
            [button setNeedsDisplay];
            [button release];
        }
    }
}

// 서브 메뉴 타이틀과 버튼들 삭제.
- (void)removeSubButtons
{
    for (UIView *subview in self.folderView.subviews) 
    {
        if ([subview isKindOfClass:[UIButton class]] 
            || ([subview isKindOfClass:[UIImageView class]] && subview.tag == SUB_MENU_TITLE_TAG)) 
        {
            [subview removeFromSuperview];
        }
    }
}


// 서브 메뉴 버튼 액션.
- (IBAction)openTarget:(id)sender
{
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil]; 
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController]; 
    navigationController.delegate = webViewController;
    navigationController.view.frame = ContentViewFrame;
    navigationController.view.tag = 1010;   // !!!: 뷰의 태그는 화면번호로 설정함!
    [self.view.superview.superview addSubview:navigationController.view];
    [navigationController.view bringToFront];
    
    // TODO: 애니메이션 변경.
    // 전체메뉴를 모달로 띄움.
    UIView *modalView = webViewController.view;
    modalView.frame = ContentViewFrame;
    
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 2.0);
    modalView.center = offScreenCenter;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    modalView.center = middleCenter;
    [UIView commitAnimations];
    
    
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
        // 서브 메뉴 로드: 메뉴 그룹에 따른 필터링.
        [self filteredMenus:selectedButton.tag];
        
        // 0단계: 서브 메뉴 갯수 및 버튼 위치에 따른 좌표 보정.
        [self reviseButtonCoordinate:selectedButton.tag isOpen:YES];
        
        // 버튼의 원래 center;
        CGPoint orginCenter = selectedButton.center;
        
        // 1 단계: 메인 뷰를 이미지로 갭춰. 
        [self captureImageFromPointAndSetupMaskView:selectedFolderPoint withSelectedButtonTag:selectedButton.tag isOpen:YES];
        
        // 2 단계: 폴더 뷰(Layer 2와 2-1)과 메인 뷰의 아랫 부분(Layer 3) 레이아웃 설정.
        [self layoutBottomPartOfMainViewRelativeToPointInMainView:selectedFolderPoint withSelectedButtonTag:selectedButton.tag isOpen:YES];
        
        // 현재 뷰의 위로...        
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:bottomPartOfMainBackgroundView.superview];
        selectedButton.center = CGPointMake(orginCenter.x, orginCenter.y + COORDINATE_REVISE);
        [appDelegate.window addSubview:selectedButton];
        
        [UIView beginAnimations:@"FolderOpen" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		
        // 메인 백그라운드 뷰의 이미지 캡춰.
        
        folderView.hidden = NO;
        bottomPartOfMainBackgroundView.superview.hidden = NO;
        
        // 3 단계: 메인 뷰의 나머지 부분(Layer 3) 설정.
        [self layoutFinalFrameOfBottomPartOfMainContentViewWithSelectedButtonTag:selectedButton.tag isOpen:YES];
        [UIView commitAnimations];
        
        // 4 단계: 선택한 이외의 버튼 상태 변경.
        [self changeButtonState:selectedButton.tag withType:NO];
        
        // 5 단계: 서브 메뉴 버튼 생성.
        [self createSubButton:selectedButton.tag];
    }
    else 
    {
        // 원래의 뷰로 버튼 원상복귀.
        selectedButton.center = CGPointMake(orginCenter.x, orginCenter.y - COORDINATE_REVISE);
        [mainBackgroundView addSubview:selectedButton];
        
        // 0단계: 서브 메뉴 갯수 및 버튼 위치에 따른 좌표 보정.
        [self reviseButtonCoordinate:selectedButton.tag isOpen:NO];
        
        // 1단계: 폴더 닫기 애니메이션.
        [UIView beginAnimations:@"FolderClose" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(animation:didFinish:context:)];
        [UIView setAnimationDelegate:self];
        
        // 애니메이션 종료 후 레이아웃과 폴더 뷰 감추기.
        [self closeFolder:selectedFolderPoint withSelectedButtonTag:selectedButton.tag];
        [UIView commitAnimations];
        
        
        // 2 단계: 선택한 이외의 버튼 상태 변경.
        [self changeButtonState:selectedButton.tag withType:YES];
        
        // 3 단계: 서브 메뉴 버튼 삭제.
        [self removeSubButtons];
        self.filteredMenus = nil;
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

// 보정할 좌표 값 구하기. 
// 11: 퇴직연금, 13: 리서치, 14:커뮤니티, 15: 업무안내가이드, 16: 홍보센터, 17: 세무도우미, 18: 고객센터.
- (float)coordinateRevise:(NSInteger)selectedButtonTag isOpen:(BOOL)status
{
    float coordinateRevise = 0;
    if (status) 
    {
        switch (selectedButtonTag) 
        {
            case 11:
                coordinateRevise = - ONE_STEP_REVISE;
                break;
            case 13:
                coordinateRevise = - TWO_STEP_REVISE;
                break;
            case 14:
                coordinateRevise = - TWO_STEP_REVISE;
                break;
            case 15:
                coordinateRevise = - TWO_STEP_REVISE;
                break;
            case 16:
                coordinateRevise = - TWO_STEP_REVISE;
                break;
            case 17:
                coordinateRevise = - THREE_STEP_REVISE;
                break;
            case 18:
                coordinateRevise = - THREE_STEP_REVISE;
                break;
            default:
                break;
        } 
    }
    else
    {
        switch (selectedButtonTag) 
        {
            case 11:
                coordinateRevise = ONE_STEP_REVISE;
                break;
            case 13:
                coordinateRevise = TWO_STEP_REVISE;
                break;
            case 14:
                coordinateRevise = TWO_STEP_REVISE;
                break;
            case 15:
                coordinateRevise = TWO_STEP_REVISE;
                break;
            case 16:
                coordinateRevise = TWO_STEP_REVISE;
                break;
            case 17:
                coordinateRevise = THREE_STEP_REVISE;
                break;
            case 18:
                coordinateRevise = THREE_STEP_REVISE;
                break;
            default:
                break;
        }
    }
    
    return coordinateRevise;
}

// TODO: NSPredicate를 사용하는 방식으로 수정할 것!
// 선택한 버튼의 좌표 보정을 해야할 예외에 속하는 지 확인.
// 11: 퇴직연금, 13: 리서치, 14:커뮤니티, 15: 업무안내가이드, 16: 홍보센터, 17: 세무도우미, 18: 고객센터.
- (BOOL)isException:(NSInteger)selectedButtonTag
{
    NSArray *exceptions = [NSArray arrayWithObjects:
                           [NSNumber numberWithInteger:11],
                           [NSNumber numberWithInteger:13],
                           [NSNumber numberWithInteger:14],
                           [NSNumber numberWithInteger:15],
                           [NSNumber numberWithInteger:16],
                           [NSNumber numberWithInteger:17],
                           [NSNumber numberWithInteger:18], nil];
    
    for (NSNumber *num in exceptions) 
    {
        if ([num isEqualToNumber:[NSNumber numberWithInteger:selectedButtonTag]]) 
        {
            return YES;
        }
    }
    
    return NO;
}

@end
