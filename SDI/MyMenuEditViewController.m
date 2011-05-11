//
//  MyMenuEditViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MyMenuEditViewController.h"

#define MY_MENU_FILE @"MyMenu.plist"


@implementation MyMenuEditViewController

@synthesize menuTable;
@synthesize myMenus;
@synthesize displayMyMenus;

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
    [myMenus release];
    [displayMyMenus release];
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
    
    self.title = @"마이메뉴 정렬";
    
    // 편집 버튼.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"편집" style:UIBarButtonItemStylePlain target:self action:@selector(editMyMenu:)];
	self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    // 테이블뷰 스타일.
    self.menuTable.separatorColor = RGB(54, 54, 54);
    
    // 마이메뉴 로드.
    self.displayMyMenus = [self loadMyMenus];
    
    // 디폴트 마이메뉴인 편집과 전체설정을 유지하기 위해...
    defaultMyMenus = [[NSMutableArray alloc] init];
    [defaultMyMenus addObject:[self.displayMyMenus lastObject]];
    [self.displayMyMenus removeLastObject];
    [defaultMyMenus insertObject:[self.displayMyMenus lastObject] atIndex:0];
    [self.displayMyMenus removeLastObject];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.displayMyMenus count];
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
    
    tableView.backgroundColor = RGB(61, 61, 61);
    UIView *bgColor = [cell viewWithTag:100];
    if (!bgColor) 
    {
        CGRect frame = CGRectMake(0, 0, 320, self.menuTable.rowHeight);
        bgColor = [[UIView alloc] initWithFrame:frame];
        bgColor.tag = 100; // 나중에 뷰에서 태그로 접근함.
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        [bgColor release];
    }
    
    if (indexPath.row % 2 == 0)
    {
        bgColor.backgroundColor = RGB(26, 26, 26);
    } 
    else 
    {
        bgColor.backgroundColor = RGB(34, 34, 34);
    }
    
    // Configure the cell...
    cell.textLabel.textColor = RGB(237, 237, 237);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [[self.displayMyMenus objectAtIndex:indexPath.row] objectForKey:@"name"];
    
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Delete the row from the data source
        [self.displayMyMenus removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.displayMyMenus exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [self.menuTable reloadData];
}

#pragma mark - Table view delegate

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

#pragma mark - 커스터 메서드

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

- (IBAction)editMyMenu:(id)sender
{
    if (self.menuTable.editing == NO) 
    {
        // 마이메뉴 편집.
        [self.menuTable setEditing:YES animated:YES];
        // 백버튼 비활성.
        self.navigationItem.backBarButtonItem.enabled = NO;
        // 버튼의 제목 변경.
        [sender setTitle:@"완료"];
    }
    else
    {             
        [self.menuTable setEditing:NO animated:YES];
        // 백버튼 활성.
        self.navigationItem.backBarButtonItem.enabled = YES;
        // 버튼의 제목 변경.
        [sender setTitle:@"편집"];
        // 마이메뉴 저장.
        [self saveMyMenu];
    }
}

// 마이메뉴 저장.
- (void)saveMyMenu
{
    self.myMenus = [NSMutableArray arrayWithArray:self.displayMyMenus];
    [self.myMenus addObjectsFromArray:defaultMyMenus];
    
    // Document 디렉토리.
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    
    // 파일명.
    NSString *fileName = [documentDirectory stringByAppendingPathComponent:MY_MENU_FILE];
    
    // 마이메뉴 파일이 존재하면 삭제.
//    if ([self isFileExistence:MY_MENU_FILE]) 
//    {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:fileName error:nil];
//    }
    
    [self.myMenus writeToFile:fileName atomically:NO];
    
    // 마이메뉴 편집 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"EditedMyMenu" object:self];
}

@end
