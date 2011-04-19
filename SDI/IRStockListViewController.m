//
//  IRStockListViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 성능 개선!
//

#import "IRStockListViewController.h"
#import "IRStockAddViewController.h"
#import "SDIAppDelegate.h"
#import "HTTPHandler.h"

#define CUSTOM_BUTTON_HEIGHT 30.0

#define LABEL_WIDTH 106
#define STOCK_LABEL_TAG 1
#define CURRENT_PRICE_LABEL_TAG 2


@implementation IRStockListViewController

@synthesize fetchedResultsControllerForIRGroup = __fetchedResultsControllerForIRGroup;
@synthesize fetchedResultsControllerForIRStock = __fetchedResultsControllerForIRStock;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize irGroup;
@synthesize responseArray;
@synthesize currentStockCode;
@synthesize currentPrice;

@synthesize previousButton;
@synthesize nextButton;
@synthesize selectPickerButton;
@synthesize groupLabel;
@synthesize stockTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // 관리 객체 컨텍스트 설정.
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        
        // 그룹 리스트 가져오기.
        [self fetchedResultsControllerForIRGroup];
        
        // 관심종목 리스트 가져오기.
        [self fetchedResultsControllerForIRStock:currentIndex + 1];
        
//        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
//        Debug(@"Group row count: %d", [sectionInfo numberOfObjects]);
//        Debug(@"Group section count: %d", [[self.fetchedResultsController sections] count]);
        Debug(@"IRGroup row count: %d", [[self.fetchedResultsControllerForIRGroup fetchedObjects] count]);
        Debug(@"IRStock row count: %d", [[self.fetchedResultsControllerForIRStock fetchedObjects] count]);
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
    [responseArray release];
    [currentStockCode release];
    [currentPrice release];
    [stockTableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [__fetchedResultsControllerForIRGroup release];
    [__fetchedResultsControllerForIRStock release];
    [__managedObjectContext release];
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
    
    // 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(viewText:) name:TRCD_SS01REAL object:nil];
    
    // 화면 레이아웃 설정.
    [self setLayout];
    
    // 그룹이름 초기화.
    self.irGroup = [[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:0];
    self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
    
    isReal = NO;
    
    // 관심 종목 데이터 초기화.
    [self initIRStocks];
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
    
    // 관심 종목 데이터 초기화.
    [self initIRStocks];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsControllerForIRStock sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsControllerForIRStock sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // 커스텀 셀.
    UILabel *stockLabel, *currentPriceLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        // 종목.
        stockLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, LABEL_WIDTH, tableView.rowHeight)] autorelease];
        stockLabel.tag = STOCK_LABEL_TAG;
        stockLabel.font = [UIFont systemFontOfSize:17.0];
        stockLabel.textAlignment = UITextAlignmentLeft;
        stockLabel.textColor = [UIColor blackColor];
        //titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:stockLabel];
        
        // 현재가.
        currentPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(107.0, 0.0, LABEL_WIDTH, tableView.rowHeight)] autorelease];
        currentPriceLabel.tag = CURRENT_PRICE_LABEL_TAG;
        currentPriceLabel.font = [UIFont systemFontOfSize:14.0];
        currentPriceLabel.textAlignment = UITextAlignmentLeft;
        currentPriceLabel.textColor = [UIColor darkGrayColor];
        //subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:currentPriceLabel];
    }
    else
    {
        stockLabel = (UILabel *)[cell.contentView viewWithTag:STOCK_LABEL_TAG];
        currentPriceLabel = (UILabel *)[cell.contentView viewWithTag:CURRENT_PRICE_LABEL_TAG];
    }
    
    // Configure the cell...
    NSManagedObject *managedObject = [self.fetchedResultsControllerForIRStock objectAtIndexPath:indexPath];
    stockLabel.text = [managedObject valueForKey:@"stockName"]; //[[managedObject valueForKey:@"stockName"] description];
    
    if (isReal) 
    {
        // 리얼 시세가 들어 오는 경우...
        if ([[[managedObject valueForKey:@"stockCode"] description] isEqualToString:self.currentStockCode]) 
        {
            currentPriceLabel.text = [LPUtils formatNumber:[self.currentPrice intValue]];
        }
        
        isReal = NO;
    }
    else
    {
        // 화면에 처음 진입할 경우, RQ로 현재가 등의 데이터를 설정한다.
        for (NSDictionary *dict in self.responseArray) 
        {
            if ([[managedObject valueForKey:@"stockCode"] isEqualToString:[dict objectForKey:@"isNo"]]) 
            {
                currentPriceLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"nowPrc"] intValue]];
            }
        }
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSManagedObject *managedObject = [self.fetchedResultsControllerForIRStock objectAtIndexPath:indexPath];
        [dict setValue:[managedObject valueForKey:@"stockCode"] forKey:@"stockCode"];
        [dict setValue:[managedObject valueForKey:@"stockName"] forKey:@"stockName"];
        
        // SB 해제 메시지 전송.
        [[AppInfo sharedAppInfo] clearSB:dict idx:@"0" trCode:TRCD_SS01REAL];
        
        NSManagedObjectContext *context = [self.fetchedResultsControllerForIRStock managedObjectContext];
        [context deleteObject:[self.fetchedResultsControllerForIRStock objectAtIndexPath:indexPath]];
        
        // 컨텍스트 저장.
        NSError *error = nil;
        if (![context save:&error]) {
            // TODO: 에러 처리.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // 관심종목 삭제 노티피케이션큐: 그룹 1만.
        [self fetchedResultsControllerForIRStock:1];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.fetchedResultsControllerForIRStock, @"deleteIRStock", nil];
        NSNotificationQueue *nq = [NSNotificationQueue defaultQueue];
        [nq enqueueNotification:[NSNotification notificationWithName:@"DeleteIRStock" object:self userInfo:dict2] postingStyle:NSPostWhenIdle];
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
    for (int i = 0; i < [[self.fetchedResultsControllerForIRStock fetchedObjects] count]; i++)
    {
        NSManagedObject *managedObject = [self.fetchedResultsControllerForIRStock objectAtIndexPath:fromIndexPath];
        [managedObject setValue:[NSNumber numberWithInt:toIndexPath.row] forKey:@"displayOrder"];
    }
    
    NSManagedObjectContext *context = [self.fetchedResultsControllerForIRStock managedObjectContext];
    
    // 컨텍스트 저장.
    NSError *error = nil;
    if (![context save:&error])
    {
        // TODO: 에러 처리.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self fetchedResultsControllerForIRStock:currentIndex + 1];
    [self.stockTableView reloadData];
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

#pragma mark - 피커뷰 데이터소스 메서드

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
	return [[self.fetchedResultsControllerForIRGroup fetchedObjects] count];
}

#pragma mark - 피커뷰 델리게이트 메서드

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.irGroup = [[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:row];
	return [self.irGroup valueForKey:@"groupName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentIndex = row;
    self.irGroup = [[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:row];
    self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
    
    [self fetchedResultsControllerForIRStock:currentIndex + 1];
    [self initIRStocks];
    [self.stockTableView reloadData];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 관심종목 리스트 가져오기.
    [self fetchedResultsControllerForIRStock:currentIndex + 1];
    // 관심 종목 데이터 초기화.
    [self initIRStocks];
    [self.stockTableView reloadData];
}


#pragma mark - Fetched results controller

// IRGroup 테이블에서 그룹 목록 가져오기.
- (NSFetchedResultsController *)fetchedResultsControllerForIRGroup
{
    if (__fetchedResultsControllerForIRGroup != nil)
    {
        return __fetchedResultsControllerForIRGroup;
    }
    
    // 엔티티를 위한 리궤스트 생성.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // 엔티티 이름 설정.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRGroup" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 배치 사이즈 설정: 최대 50개의 그룹 저장.
    [fetchRequest setFetchBatchSize:50];
    
    // 검색조건.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerForIRGroup = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsControllerForIRGroup performFetch:&error])
    {
	    // TODO: 에러 처리!
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsControllerForIRGroup;
}    

// IRStock 테이블에서 현재 선택된 그룹포함된 주식종목 목록 가져오기.
- (NSFetchedResultsController *)fetchedResultsControllerForIRStock:(int)searchGroup
{
//    if (__fetchedResultsControllerForIRStock != nil && searchGroup != 0)
//    {
//        return __fetchedResultsControllerForIRStock;
//    }
    
    // 엔티티를 위한 리궤스트 생성.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // 엔티티 이름 설정.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRStock" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 배치 사이즈 설정: 하나의 그룹에 최대 50개의 주식종목 저장.
    [fetchRequest setFetchBatchSize:50];
    
    // 검색조건.
    [fetchRequest setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %d", searchGroup];
	[fetchRequest setPredicate:predicate];
    
    // 정렬할 키 설정: displayOrder를 ascending 한다..
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerForIRStock = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsControllerForIRStock performFetch:&error])
    {
	    // TODO: 에러 처리.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsControllerForIRStock;
} 

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.stockTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.stockTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.stockTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.stockTableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            [tableView reloadData];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.stockTableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark - 커스텀 메서드

// 화면 레이아웃 설정.
- (void)setLayout
{
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
    isSelectedPicker = NO;
}

// 백버튼 액션.
- (IBAction)backAction:(id)sender
{
    Debug(@"Back button tapped!");
    [self togglePicker:1];
    [self.navigationController.view removeFromSuperview];
}

// 세그먼티드 컨드롤 액션.
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
        if (self.stockTableView.editing == NO) 
        {
            // 관심종목 편집.
            [self.stockTableView setEditing:YES animated:YES];
            // 백버튼 비활성.
            self.navigationItem.leftBarButtonItem.enabled = NO;
            // 세그먼티드컨롤 중 인덱스 1인 편집 버튼의 제목 변경.
            [sender setTitle:@"완료" forSegmentAtIndex:1];
        }
        else
        {             
            [self.stockTableView setEditing:NO animated:YES];
            // 백버튼 활성.
            self.navigationItem.leftBarButtonItem.enabled = YES;
            // 세그먼티드컨롤 중 인덱스 1인 편집 버튼의 제목 변경.
            [sender setTitle:@"편집" forSegmentAtIndex:1];
        }
    }
}

// 이전 그룹 선택.
- (IBAction)previousAction:(id)sender
{
    if (currentIndex > 0) 
    {
        self.irGroup = [[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:(currentIndex - 1)];
        self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
        
        currentIndex = currentIndex - 1;
    }
    else
    {
        Debug(@"First index!");
    }
    
    [self fetchedResultsControllerForIRStock:currentIndex + 1];
    [self initIRStocks];
    [self.stockTableView reloadData];
}

// 다음 그룹 선택.
- (IBAction)nextAction:(id)sender
{
    if (currentIndex < [[self.fetchedResultsControllerForIRGroup fetchedObjects] count] - 1) 
    {
        self.irGroup = [[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:(currentIndex + 1)];
        self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
        
        currentIndex = currentIndex + 1;
    }
    else
    {
        Debug(@"Last index!");
    }
    
    [self fetchedResultsControllerForIRStock:(currentIndex + 1)];
    [self initIRStocks];
    [self.stockTableView reloadData];
    
    Debug(@"IRStock row count: %d", [[self.fetchedResultsControllerForIRStock fetchedObjects] count]);
}

// 피커 선택.
- (IBAction)selectPicker:(id)sender
{
    if (!isSelectedPicker) 
    {
        [self togglePicker:0];
        isSelectedPicker = YES;
    }
    else
    {
        [self togglePicker:1];
        isSelectedPicker = NO;
    }
}

// 피커 토글.
- (void)togglePicker:(int)type
{
    if (type == 0) 
    {
        // 툴바: 화면 밖에서 생성한다.
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, self.view.bounds.size.width, 44)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.tintColor = [UIColor darkGrayColor];
        
        // 완료 버튼.
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectPicker:)];
        doneButtonItem.title = @"완료";
        
        NSArray *items = [[NSArray alloc] initWithObjects:doneButtonItem, nil];
        [toolbar setItems:items];
        [doneButtonItem release];
        [items release];			
        
        // 리본뷰 위에 추가하기 위해 앱델리게이트의 window를 이용함!
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:toolbar];
        
        // 피커뷰: 화면 밖에서 생성한다.
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 480, self.view.bounds.size.width, 0)];  
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        [appDelegate.window addSubview:pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        pickerView.transform = CGAffineTransformMakeTranslation(0, -216);
        toolbar.transform = CGAffineTransformMakeTranslation(0, -260);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        pickerView.transform = CGAffineTransformMakeTranslation(0, 216);
        toolbar.transform = CGAffineTransformMakeTranslation(0, 260);
        [UIView commitAnimations];
        [pickerView release];
    }
}

// 관심 종목 데이터 초기화
- (void)initIRStocks
{
    // HTTPRequest: 리얼 시세 데이터 가 들어 오기 전에 종목별 현재가 설정을 위해...
    self.responseArray = [[NSMutableArray alloc] init];
    HTTPHandler *httpHandler = [[HTTPHandler alloc] init];
    for (NSInteger i = 0; i < [[self.fetchedResultsControllerForIRStock fetchedObjects] count]; i++) 
    {
        // NSIndexPath의 indexPathWithIndex 메서드를 사용하기 위해, NSInteger를 사용함!
        NSManagedObject *managedObject = [self.fetchedResultsControllerForIRStock objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [httpHandler searchCurrentPrice:[[managedObject valueForKey:@"stockCode"] description]];
        if (httpHandler.reponseDict != nil) 
        {
            [self.responseArray addObject:httpHandler.reponseDict];
        }
    }
}

// TODO: 관심 종목 필드 설정 및 확인(현재가, 전일비, 등락율, 거래대금 등)!
// 종목별 실시간 데이터.
- (void)viewText:(NSNotification *)notification 
{
    isReal = YES;
    self.currentStockCode = [[notification userInfo] objectForKey:@"isCd"];
    self.currentPrice = [[notification userInfo] objectForKey:@"nowPrc"];     
    [self.stockTableView reloadData];
}

@end
