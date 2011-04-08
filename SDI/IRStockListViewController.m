//
//  IRStockListViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "IRStockListViewController.h"
#import "IRStockAddViewController.h"
#import "IRStockEditViewController.h"
#import "SDIAppDelegate.h"
#import "LPGridTabaleCell.h"

#define CUSTOM_BUTTON_HEIGHT 30.0

#define LABEL_TAG 1 
#define VALUE_TAG 2 
#define FIRST_CELL_IDENTIFIER @"TrailItemCell" 
#define SECOND_CELL_IDENTIFIER @"RegularCell" 


@implementation IRStockListViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize irGroup;

@synthesize previousButton;
@synthesize nextButton;
@synthesize selectPickerButton;
@synthesize groupLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // 관리 객체 컨텍스트 설정.
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        
        // 그룹 리스트 가져오기.
        [self fetchedResultsController];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
        Debug(@"Group row count: %d", [sectionInfo numberOfObjects]);
        Debug(@"Group section count: %d", [[self.fetchedResultsController sections] count]);
        Debug(@"Group row count: %d", [[self.fetchedResultsController fetchedObjects] count]);
    }
    return self;
}

- (void)dealloc
{   
    [previousButton release];
    [nextButton release];
    [selectPickerButton release];
    [groupLabel release];
    [irGroup release];
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
    
    self.title = @"관심종목";
    
    // 이전화면 버튼.
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"이전화면" forState:UIControlStateNormal];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    // 등록, 편집 버튼.
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"등록", @"편집", nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, CUSTOM_BUTTON_HEIGHT);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
    
    // 나중에 사용하기 위해...
    defaultTintColor = [segmentedControl.tintColor retain];	
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
    
    // 피커뷰 표시를 위해...
    showPickerVeiw = NO;
    
    // 그룹이름 초기화.
    self.irGroup = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
	
    // 세그멘티드 컨트롤의 스타일을 네비게이션 바의 스트일과 일치 시킴.
	if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent ||
		self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque)
		segmentedControl.tintColor = [UIColor darkGrayColor];
	else
		segmentedControl.tintColor = defaultTintColor;
    
    [self selectPicket:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    LPGridTabaleCell *cell = (LPGridTabaleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[LPGridTabaleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *label = [[[UILabel	alloc] initWithFrame:CGRectMake(0.0, 0, 30.0, tableView.rowHeight)] autorelease]; 
		[cell addColumn:50];
		label.tag = LABEL_TAG; 
		label.font = [UIFont systemFontOfSize:12.0]; 
		label.text = [NSString stringWithFormat:@"%d", indexPath.row];
		label.textAlignment = UITextAlignmentRight; 
		label.textColor = [UIColor blueColor]; 
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
		UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:label]; 
        
		label = [[[UILabel	alloc] initWithFrame:CGRectMake(60.0, 0, 30.0, tableView.rowHeight)] autorelease]; 
		[cell addColumn:120];
		label.tag = VALUE_TAG; 
		label.font = [UIFont systemFontOfSize:12.0]; 
		// add some silly value
		label.text = [NSString stringWithFormat:@"%d", indexPath.row * 4];
		label.textAlignment = UITextAlignmentRight; 
		label.textColor = [UIColor blueColor]; 
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
		UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:label]; 
    }
    
    // Configure the cell...
    
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

#pragma mark - 피커뷰 데이터소스 메서드

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
	return [[self.fetchedResultsController fetchedObjects] count];
}

#pragma mark - 피커뷰 델리게이트 메서드

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.irGroup = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
	return [self.irGroup valueForKey:@"groupName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentIndex = row;
    self.irGroup = [[self.fetchedResultsController fetchedObjects] objectAtIndex:row];
    self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRGroup" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

#pragma mark - 커스텀 메서드

- (IBAction)backAction:(id)sender
{
    Debug(@"Back button tapped!");
    [self selectPicket:sender];
    [self.navigationController.view removeFromSuperview];
}

- (IBAction)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	Debug(@"Segment tapped: %d", segmentedControl.selectedSegmentIndex);
    
    if (segmentedControl.selectedSegmentIndex == 0) 
    {
        // 관심종목 등록.
        IRStockAddViewController *viewController = [[IRStockAddViewController alloc] initWithNibName:@"IRStockAddViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    
    if (segmentedControl.selectedSegmentIndex == 1) 
    {
        // 관심종목 편집.
        IRStockEditViewController *viewController = [[IRStockEditViewController alloc] initWithNibName:@"IRStockEditViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

// TODO: 실제 데이터 로드...
// 이전 그룹 선택.
- (IBAction)previousAction:(id)sender
{
    if (currentIndex > 0) 
    {
        self.irGroup = [[self.fetchedResultsController fetchedObjects] objectAtIndex:(currentIndex - 1)];
        self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
        
        currentIndex = currentIndex - 1;
    }
    
}

// TODO: 실제 데이터 로드...
// 다음 그룹 선택.
- (IBAction)nextAction:(id)sender
{
    if (currentIndex < [[self.fetchedResultsController fetchedObjects] count]) 
    {
        self.irGroup = [[self.fetchedResultsController fetchedObjects] objectAtIndex:(currentIndex + 1)];
        self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
        
        currentIndex = currentIndex + 1;
    }
}

// 피커 선택.
- (IBAction)selectPicket:(id)sender
{
    if (showPickerVeiw) 
    {
        // 툴바: 화면 밖에서 생성한다.
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, self.view.bounds.size.width, 44)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.tintColor = [UIColor darkGrayColor];
        
        // 완료 버튼.
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectPicket:)];
        doneButtonItem.title = @"완료";
        
        NSArray *items = [[NSArray alloc] initWithObjects:doneButtonItem, nil];
        [toolbar setItems:items];
        [doneButtonItem release];
        [items release];			
        
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:toolbar];
        
        // 피커뷰: 화면 밖에서 생성한다.
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 480, self.view.bounds.size.width, 0)];  
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        //SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        pickerView.transform = CGAffineTransformMakeTranslation(0, -216);
        toolbar.transform = CGAffineTransformMakeTranslation(0, -260);
        [UIView commitAnimations];
        
        showPickerVeiw = NO;
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        pickerView.transform = CGAffineTransformMakeTranslation(0, 216);
        toolbar.transform = CGAffineTransformMakeTranslation(0, 260);
        [UIView commitAnimations];
        
        showPickerVeiw = YES;
    }
}

@end
