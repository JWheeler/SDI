//
//  MyMenuAddViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MyMenuAddViewController.h"
#import "MyMenuEditViewController.h"
#import "SectionHeaderView.h"

#define MY_MENU_FILE @"MyMenu.plist"


@implementation MyMenuAddViewController

@synthesize menuTable;
@synthesize menuGroups;
@synthesize menus;
@synthesize myMenus;
@synthesize dataSets;

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
    [menuTable release];
    [menuGroups release];
    [menus release];
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
    
    // 메뉴그룹, 메뉴, 마이메뉴 로드 및 데이터셋 생성.
    self.menuGroups = [self loadMenuGroups];
    self.menus = [self loadMenus];
    self.myMenus = [self loadMyMenus];
    self.dataSets = [self createDataSet];
    
    Debug(@"MenuGroups count: %d, Menu count: %d, MyMenu count: %d", [self.menuGroups count], [self.menus count], [self.myMenus count]);
    Debug(@"DataSets count: %d", [self.dataSets count]);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSets count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subMenus = [[self.dataSets objectAtIndex:section] objectForKey:@"subMenus"];
    return [subMenus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    NSDictionary *dict = [self.dataSets objectAtIndex:indexPath.section];
    NSArray *subMenus = [dict objectForKey:@"subMenus"];
    NSString *name = [[subMenus objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.textLabel.text = name;
    
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
    if (indexPath.row == 0) 
    {
        return 59.0;
    }
    else
    {
        return 44.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect1 = CGRectMake(8.5, 0.0, 303.0, [self tableView:tableView heightForHeaderInSection:section]);
    CGRect rect2 = rect1;
    rect2.size.height += 15.0f;
    
    UIView *headerBG = [[UIView alloc] initWithFrame:rect1];
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithFrame:rect2];
    headerView.imageName = @"m_header.png";
    
    [headerBG addSubview:headerView];
    [headerView release];
    
    return [headerBG autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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

// 마이메뉴 저장.
- (void)saveMyMenus
{
    
}

@end
