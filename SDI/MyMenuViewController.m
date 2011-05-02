//
//  MyMenuViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MyMenuViewController.h"

#define MY_MENU_FILE @"MyMenu.plist"
#define MY_MENU_DISPLAY_CNT 9


@implementation MyMenuViewController

@synthesize myMenuTable;
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
    [myMenuTable release];
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
    
    // 마이메뉴 로드.
    [self loadMyMenus];
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
    return [self.myMenus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // 커스텀 셀.
//    CGRect buttonFrame[MY_MENU_DISPLAY_CNT];
//    UIButton *buttonForFrame[MY_MENU_DISPLAY_CNT];
    UIButton *button_0, *button_1, *button_2, *button_3, *button_4, *button_5, *button_6, *button_7, *button_8; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
//        for (int i = 0; i < MY_MENU_DISPLAY_CNT; i++) 
//        {
//            CGRect frame = CGRectZero;
//            buttonFrame[i] = frame;
//            UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//            buttonForFrame[i] = button;
//            button.frame = frame;
//			button.tag = i;
//            
//            // 배경 이미지.
//            [cell.contentView addSubview:button];
//            [button setNeedsDisplay];
//            [button release];
//        }
        
        button_0 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_0.frame = CGRectZero;
        button_0.tag = 0;
        [cell.contentView addSubview:button_0];
        
        button_1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_1.frame = CGRectZero;
        button_1.tag = 1;
        [cell.contentView addSubview:button_1];
        
        button_2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_2.frame = CGRectZero;
        button_2.tag = 2;
        [cell.contentView addSubview:button_2];
        
        button_3 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_3.frame = CGRectZero;
        button_3.tag = 3;
        [cell.contentView addSubview:button_3];
        
        button_4 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_4.frame = CGRectZero;
        button_4.tag = 4;
        [cell.contentView addSubview:button_4];
        
        button_5 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_5.frame = CGRectZero;
        button_5.tag = 5;
        [cell.contentView addSubview:button_5];
        
        button_6 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_6.frame = CGRectZero;
        button_6.tag = 6;
        [cell.contentView addSubview:button_6];
        
        button_7 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_7.frame = CGRectZero;
        button_7.tag = 7;
        [cell.contentView addSubview:button_7];
        
        button_8 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button_8.frame = CGRectZero;
        button_8.tag = 8;
        [cell.contentView addSubview:button_8];
    }
    else
    {
//        for (int i = 0; i < MY_MENU_DISPLAY_CNT; i++) 
//        {
//            buttonForFrame[i] = (UIButton *)[cell.contentView viewWithTag:i];
//        }
        
        button_0 = (UIButton *)[cell.contentView viewWithTag:0];
        button_1 = (UIButton *)[cell.contentView viewWithTag:1];
        button_2 = (UIButton *)[cell.contentView viewWithTag:2];
        button_3 = (UIButton *)[cell.contentView viewWithTag:3];
        button_4 = (UIButton *)[cell.contentView viewWithTag:4];
        button_5 = (UIButton *)[cell.contentView viewWithTag:5];
        button_6 = (UIButton *)[cell.contentView viewWithTag:6];
        button_7 = (UIButton *)[cell.contentView viewWithTag:7];
        button_8 = (UIButton *)[cell.contentView viewWithTag:8];
    }
    
    // Configure the cell...
    int index = indexPath.row % MY_MENU_DISPLAY_CNT;

    if (index == 0) 
    {
//        UIImage *image = [UIImage imageNamed:[[self.myMenus objectAtIndex:indexPath.row] objectForKey:@"iconForMyMenu"]];
//        buttonForFrame[index].frame = CGRectMake(0.0, 0, image.size.width, image.size.height);
//        buttonForFrame[index].center = CGPointMake(116.0, tableView.rowHeight / 2);
//        [buttonForFrame[index] setImage:image forState:UIControlStateNormal];
        
        UIImage *image = [[UIImage imageNamed:[[self.myMenus objectAtIndex:indexPath.row] objectForKey:@"iconForMyMenu"]] retain];
        button_0.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button_0.center = CGPointMake(116.0, tableView.rowHeight / 2);
        //[button_0 setBackgroundImage:image forState:UIControlStateNormal];
    }

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

// 음성검색.
- (IBAction)voiceSearch:(id)sender
{
    Debug(@"Voice search button tapped!");
}

@end
