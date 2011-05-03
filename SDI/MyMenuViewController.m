//
//  MyMenuViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MyMenuViewController.h"
#import "ButtonCell.h"

#define MY_MENU_FILE @"MyMenu.plist"


@implementation MyMenuViewController

@synthesize myMenus;


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
    [myMenus release];
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
    
    // UITapGestureRecognizer 인스턴스 생성.
    UITapGestureRecognizer *recognizerTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMyMenuTapGesture:)] autorelease];
    // 더블탭했을 경우 MyMenu 화면 닫기.
    recognizerTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:recognizerTap];
    
    // UISwipeGestureRecognizer 인스턴스 생성.
	UISwipeGestureRecognizer *recognizerUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeDirection:)] autorelease];
	// 스와이프 제스처를 인식하기위한 탭 수.
	recognizerUp.numberOfTouchesRequired = 1;
	// 스와이프의 방향: 상.
    recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
	[self.view addGestureRecognizer:recognizerUp];
	
	UISwipeGestureRecognizer *recognizerDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeDirection:)] autorelease];
	// 스와이프 제스처를 인식하기위한 탭 수.
	recognizerDown.numberOfTouchesRequired = 1;
	// 스와이프의 방향: 하.
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:recognizerDown];
    
    // 마이메뉴 로드.
    [self loadMyMenus];
    
    // 편집과 전체설정 버튼을 하단에 두기 위해 currentIndex를 초기화 한다.
    startIndex = ([self.myMenus count] % MY_MENU_BUTTON_COUNT) + ([self.myMenus count] / MY_MENU_BUTTON_COUNT - 1);
    currentIndex = [self.myMenus count] - 1;
    
    // 버튼 생성.
    [self createButtons];
    
    Debug(@">>>>>>>>>>>>>>>Start index: %d", startIndex);
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

// 앱의 Documents 디렉토리.
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// 파일 존재 유무 확인.
- (BOOL)isFileExistence:(NSString *)file
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentDirectory = [self applicationDocumentsDirectory];
	NSString *writableFilePath = [documentDirectory stringByAppendingPathComponent:file];
	
	BOOL fileExits = [fileManager fileExistsAtPath:writableFilePath];
	
    return fileExits;
}

// 최초 실행 시 사용할 MyMenu 기본 값.
- (void)createEditableCopyOfFileIfNeeded
{
	// MyMenu.plist가 존재하는 지 확인.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentDirectory = [self applicationDocumentsDirectory];
	NSString *writableFilePath = [documentDirectory stringByAppendingPathComponent:MY_MENU_FILE];
	
	BOOL fileExits = [fileManager fileExistsAtPath:writableFilePath];
	if (!fileExits) 
    {
		NSString *defaultFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MY_MENU_FILE];
		
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultFilePath toPath:writableFilePath error:&error];
		if (!success) 
        {
			NSAssert1(0, @"Failed to create writable my menu file with message '%@'.", [error localizedDescription]);
		}
	}
}

// 마이메뉴 로드.
- (void)loadMyMenus
{
    if ([self isFileExistence:MY_MENU_FILE]) 
    {
        // Document 디렉토리.
        NSString *documentDirectory = [self applicationDocumentsDirectory];
        
        // 파일명 생성.
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentDirectory, MY_MENU_FILE];
        
        self.myMenus = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    }
    else
    {
        [self createEditableCopyOfFileIfNeeded];
        [self loadMyMenus];
    }
}

// TODO: 버튼 링크!
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

// 마이메뉴 상/하 이동.
- (void)changeDirection:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        Debug(@"Up direction!");
        if (currentIndex >= [self.myMenus count] - 1) 
        {
            [self.myMenus addObject:[self.myMenus objectAtIndex:0]];
            [self.myMenus removeObjectAtIndex:0];
        }
        
        currentIndex += 1;
        
        [self removeButtons];
        [self createButtons];
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        Debug(@"Down direction!")
//        if (currentIndex > 0) 
//        {
//            [self.myMenus insertObject:[self.myMenus lastObject] atIndex:0];
//            [self.myMenus removeLastObject];
//        }
//        
//        currentIndex -= 1;
        
        [self.myMenus insertObject:[self.myMenus lastObject] atIndex:0];
        [self.myMenus removeLastObject];
       
        [self removeButtons];
        [self createButtons];
    }
    
    Debug(@"Current index: %d", currentIndex);
}

// 음성검색.
- (IBAction)voiceSearch:(id)sender
{
    Debug(@"Voice search button tapped!");
}

// 버튼 생성.
- (void)createButtons
{
    for (int i = 0; i < MY_MENU_BUTTON_COUNT; i++) 
    {
        NSInteger index = i + startIndex;
        
        Debug(@">>>>>>>>>>>>>>>Current index: %d", index);
        
        UIImage *image = [UIImage imageNamed:[[self.myMenus objectAtIndex:index] objectForKey:@"iconForMyMenu"]];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        buttonFrame[i] = frame;
        UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        buttonForFrame[i] = button;
        button.frame = frame;
        button.tag = index;
        
        // 센터 X 좌표 설정(디자인에서 픽스 함!).
        float x = 0.0;
        switch (i) 
        {
            case 0:
                x = 116.0;
                break;
            case 1:
                x = 94.0;
                break;
            case 2:
                x = 83.0;
                break;
            case 3:
                x = 80.0;
                break;
            case 4:
                x = 83.0;
                break;
            case 5:
                x = 97.0;
                break;
            case 6:
                x = 117.0;
                break;
            case 7:
                x = 147.0;
                break;
            case 8:
                x = 200.0;
                break;
            default:
                break;
        }
        
        button.center = CGPointMake(x, (VIEW_REVISE + MY_MENU_BUTTON_MARGIN + MY_MENU_BUTTON_HEIGHT / 2) + i * (MY_MENU_BUTTON_MARGIN * 2 + MY_MENU_BUTTON_HEIGHT));
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button setNeedsDisplay];
        [button release];
                                    
    }
}

// 버튼 제거.
- (void)removeButtons
{
    for (UIView *view in self.view.subviews) 
    {
        // 음성검색 버튼은 제외!
        if ([view isKindOfClass:[UIButton class]] && view.tag != 1000) 
        {
            [view removeFromSuperview];
        }
    }
}

@end
