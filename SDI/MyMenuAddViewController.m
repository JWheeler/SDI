//
//  MyMenuAddViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 테이블뷰 애니메이션 세부 조정.
//  TODO: 리팩토링.
//

#import "MyMenuAddViewController.h"
#import "MyMenuEditViewController.h"
#import "SectionInfo.h"
#import "MenuGroup.h"
#import "Menu.h"

#define MY_MENU_FILE @"MyMenu.plist"
#define DEFAULT_ROW_HEIGHT 35
#define HEADER_HEIGHT 36


@implementation MyMenuAddViewController

@synthesize sectionInfoArray = sectionInfoArray_;
@synthesize openSectionIndex = openSectionIndex_;
@synthesize uniformRowHeight = rowHeight_;

@synthesize menuTable;
@synthesize menuGroups;
@synthesize menus = menus_;
@synthesize myMenus;
@synthesize dataSets;

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
    [sectionInfoArray_ release];
    [menuTable release];
    [menuGroups release];
    [menus_ release];
    [myMenus release];
    [dataSets release];
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
    
    self.title = @"마이메뉴 편집";
    
    // 기본값 설정.
    self.menuTable.sectionHeaderHeight = HEADER_HEIGHT;
    rowHeight_ = DEFAULT_ROW_HEIGHT;
    openSectionIndex_ = NSNotFound;
    
    // 테이블뷰 스타일 설정.
    self.menuTable.separatorColor = RGB(14, 14, 14);
    
    // 이전화면 버튼.
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"이전화면" forState:UIControlStateNormal];
    //backButton.backgroundColor = RGB(41, 41, 41);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    // 정렬 버튼.
    UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithTitle:@"정렬" style:UIBarButtonItemStylePlain target:self action:@selector(myMenuSort:)];
	self.navigationItem.rightBarButtonItem = syncButton;
    [syncButton release];
}

- (void)viewWillAppear:(BOOL)animated 
{	
	[super viewWillAppear:animated]; 
    
    // 메뉴그룹, 메뉴, 마이메뉴 로드 및 데이터셋 생성.
    self.menuGroups = [self loadMenuGroups];
    self.menus = [self loadMenus];
    self.myMenus = [self loadMyMenus];
    self.dataSets = [self createDataSet];
    
    Debug(@"MenuGroups count: %d, Menu count: %d, MyMenu count: %d", [self.menuGroups count], [self.menus count], [self.myMenus count]);
    Debug(@"DataSets count: %d", [self.dataSets count]);
	
    // sectionInfoArray 생성여부 확인.
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.menuTable])) 
    {
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (NSDictionary *dict in self.dataSets) 
        {
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			//sectionInfo.menuGroup = dict;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
            NSInteger countOfSubmenus = [[dict objectForKey:@"subMenus"] count];
			for (NSInteger i = 0; i < countOfSubmenus; i++) 
            {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
			[sectionInfo release];
		}
		
		self.sectionInfoArray = infoArray;
		[infoArray release];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.sectionInfoArray = nil;
    [self saveMyMenu];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSets count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    NSArray *subMenus = [[self.dataSets objectAtIndex:section] objectForKey:@"subMenus"];
    NSInteger numInSection = [subMenus count];
    return sectionInfo.open ? numInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    // Configure the cell...
    NSDictionary *dict = [self.dataSets objectAtIndex:indexPath.section];
    NSArray *subMenus = [dict objectForKey:@"subMenus"];
    NSString *name = [[subMenus objectAtIndex:indexPath.row] objectForKey:@"name"];
    //Debug(@"%@", dict);
    cell.backgroundColor = RGB(41, 41, 41);
    cell.textLabel.textColor = RGB(192, 192, 192);
    cell.textLabel.text = name;
    
    // 체크 처리를 위해 cell을 추가한다.
    [[subMenus objectAtIndex:indexPath.row] setObject:cell forKey:@"cell"];
    
    // 마이메뉴 추가 여부.
    BOOL isMyMenu = [[[subMenus objectAtIndex:indexPath.row] objectForKey:@"isMyMenu"] boolValue];
	UIImage *image = (isMyMenu) ? [UIImage imageNamed:@"icon_check.png"] : [UIImage imageNamed:@"icon_ucheck.png"];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	button.frame = frame;	// 버튼의 사이즈를 이미지의 사이즈로 설정.
	
	[button setBackgroundImage:image forState:UIControlStateNormal];

    // 버튼 타겟 설정하여 테이블뷰컨트롤러의 터치이벤트와 NSIndexSet를 막는다.
	[button addTarget:self action:@selector(toggleMyMenu:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	cell.accessoryView = button;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];

    // 각 행의 높이가 동일할 경우...
//    return DEFAULT_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 섹션 헤더 지연 생성.
    CGRect rect1 = CGRectMake(9.0, 0.0, 302.0, [self tableView:tableView heightForHeaderInSection:section]);
    CGRect rect2 = rect1;
    rect2.size.height += 16.0f;
    
    UIView *headerBG = [[UIView alloc] initWithFrame:rect1];
    
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    sectionInfo.headerView.imageName = @"m_header_plus.png";
    NSString *headerIconName = [[self.menuGroups objectAtIndex:section] objectForKey:@"headerIcon"];
    NSString *title = [[self.menuGroups objectAtIndex:section] objectForKey:@"name"];
    if (!sectionInfo.headerView) 
    {
        sectionInfo.headerView = [[[SectionHeaderView alloc] initWithFrame:rect2 headerIconName:headerIconName title:title section:section delegate:self] autorelease];
    }
    
    [headerBG addSubview:sectionInfo.headerView];
    
    return [headerBG autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 마이메뉴 추가/삭제에 따른 처리를 한다.
    NSDictionary *dict = [self.dataSets objectAtIndex:indexPath.section];
    NSArray *subMenus = [dict objectForKey:@"subMenus"];
    NSMutableDictionary *currentMyMenu = [subMenus objectAtIndex:indexPath.row];
    Debug(@"Before: %@", currentMyMenu);
	
	BOOL isMyMenu = [[currentMyMenu objectForKey:@"isMyMenu"] boolValue];
    if (isMyMenu) 
    {
        [self removeMyMenu:currentMyMenu];
    }
    else
    {
        [self addMyMenu:currentMyMenu];
    }
    [self saveMyMenu];
	
	[currentMyMenu setObject:[NSString stringWithFormat:@"%@", !isMyMenu ? @"YES" : @"NO"] forKey:@"isMyMenu"];
	
    // 체크 이미지 변경.
	UITableViewCell *cell = [[subMenus objectAtIndex:indexPath.row] objectForKey:@"cell"];
	UIButton *button = (UIButton *)cell.accessoryView;
	
	UIImage *newImage = (isMyMenu) ? [UIImage imageNamed:@"icon_check.png"] : [UIImage imageNamed:@"icon_ucheck.png"];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    [self.menuTable deselectRowAtIndexPath:indexPath animated:YES];
    
    Debug(@"After: %@", currentMyMenu);
    
    // 마이메뉴 추가/삭제 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"ChangedMyMenu" object:self];
}

// 마이메뉴 추가에 따른 처리를 한다.
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{	
    // 버튼을 직접 선택하게 하려면, 이곳에 구현한다.
    // 현재는 셀 선택시 처리함.
}

#pragma mark - 섹션 헤더 델리게이트

-(void)sectionHeaderView:(SectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened 
{	
    [self.menuTable reloadData];
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;

    // 행에 추가할 인덱스패스 배열 생성.
    NSArray *currentSubMenus = [[self.dataSets objectAtIndex:sectionOpened] objectForKey:@"subMenus"];
    NSInteger countOfRowsToInsert = [currentSubMenus count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) 
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    // 행에서 삭제할 인덱스패스 배열 생성.
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) 
    {
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSArray *previousSubMenus = [[self.dataSets objectAtIndex:previousOpenSectionIndex] objectForKey:@"subMenus"];
        NSInteger countOfRowsToDelete = [previousSubMenus count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) 
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // 애니메이션 스타일.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) 
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else 
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // 업데이트.
    [self.menuTable beginUpdates];
    [self.menuTable insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.menuTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.menuTable endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed 
{    
    [self.menuTable reloadData];
    
    // 섹션에서 행의 인덱스패스 배열 생성.
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.menuTable numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) 
    {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) 
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.menuTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;
}


#pragma mark - 커스텀 메서드

// 백버튼 액션.
- (IBAction)backAction:(id)sender
{
    Debug(@"Back button tapped!");
    [self.navigationController.view removeFromSuperview];
}

// 정렬버튼 액션.
- (IBAction)myMenuSort:(id)sender
{
    // 관심종목 등록.
    MyMenuEditViewController *viewController = [[MyMenuEditViewController alloc] initWithNibName:@"MyMenuEditViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

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
- (NSMutableDictionary *)filteredMenus:(NSString *)groupID
{
    NSMutableArray *filteredMenus = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dict in self.menus) 
    {
        if ([[dict objectForKey:@"groupID"] isEqualToString:groupID]) 
        {
            // 마이메뉴 추가 여부 확인하여 isMyMenu 값 설정.
            NSString *menuID = [dict objectForKey:@"menuID"];
            NSString *isMyMenu = @"NO";
            if ([self isMyMenu:groupID menuID:menuID]) 
            {
                isMyMenu = @"YES";
            }
            [dict setObject:isMyMenu forKey:@"isMyMenu"];
            
            [filteredMenus addObject:dict];
        }
    }
    
    return [filteredMenus autorelease];
}

// 마이메뉴 로드.
- (NSMutableArray *)loadMyMenus
{
    // Document 디렉토리.
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    
    // 파일명 생성.
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentDirectory, MY_MENU_FILE];
    NSMutableArray *myMenuList = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    
    return [myMenuList autorelease];
}

// 마이메뉴를 파일로 저장.
- (void)saveMyMenu
{
    // Document 디렉토리.
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    
    // 파일명.
    NSString *fileName = [documentDirectory stringByAppendingPathComponent:MY_MENU_FILE];
    
    // 마이메뉴 파일이 존재하면 삭제.
    if ([self isFileExistence:MY_MENU_FILE]) 
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fileName error:nil];
    }

    // 마이메뉴 데이터 중 cell 제거: 파일 저장을 위해...
    for (NSMutableDictionary *dict in self.myMenus) 
    {
        [dict removeObjectForKey:@"cell"];
    }
    
    [self.myMenus writeToFile:fileName atomically:YES];
}

// 마이메뉴에 포함되어 있는지 확인.
- (BOOL)isMyMenu:(NSString *)groupID menuID:(NSString *)menuID
{
    for (NSDictionary *dict in self.myMenus) 
    {
        if ([[dict objectForKey:@"groupID"] isEqualToString:groupID] 
            && [[dict objectForKey:@"menuID"] isEqualToString:menuID]) 
        {
            return YES;
        }
    }
    
    return NO;
}

// 테이블뷰 출력 용 데이터셋 생성.
- (NSMutableArray *)createDataSet
{
    NSMutableArray *dataSetList = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dict in self.menuGroups) 
    {
        NSString *groupID = [dict objectForKey:@"groupID"];
        [dict setObject:[self filteredMenus:groupID] forKey:@"subMenus"];   
        [dataSetList addObject:dict];
    }
    
    return [dataSetList autorelease];
}

// 마이메뉴 추가/삭제 토글.
- (void)toggleMyMenu:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.menuTable];
	NSIndexPath *indexPath = [self.menuTable indexPathForRowAtPoint:currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView:self.menuTable accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}

// 마이메뉴 추가.
- (void)addMyMenu:(NSDictionary *)dict
{
    [self.myMenus insertObject:dict atIndex:0];
    [self.menuTable reloadData];
}

// 마이메뉴 삭제.
- (void)removeMyMenu:(NSDictionary *)dict
{
    [self.myMenus removeObject:dict];
    [self.menuTable reloadData];
}

@end
