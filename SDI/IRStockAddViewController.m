//
//  IRStockAddViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: HTS연계 구현!
//  TODO: 음성검색 추가!
//

#import "IRStockAddViewController.h"
#import "LPUtils.h"
#import "SDIAppDelegate.h"
#import "MainViewController.h"


@implementation IRStockAddViewController

@synthesize fetchedResultsControllerForIRGroup = __fetchedResultsControllerForIRGroup;
@synthesize fetchedResultsControllerForIRStock = __fetchedResultsControllerForIRStock;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize irGroup;

@synthesize previousButton;
@synthesize nextButton;
@synthesize selectPickerButton;
@synthesize groupLabel;
@synthesize searchBar;

@synthesize indexes;
@synthesize stockCodes;
@synthesize indexList;
@synthesize filteredList;
@synthesize indexTableView;
@synthesize dataTableView;

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
    }
    return self;
}

- (void)dealloc
{
    [previousButton release];
    [nextButton release];
    [selectPickerButton release];
    [groupLabel release];
    [searchBar release];
    [irGroup release];
    [indexes release];
    [stockCodes release];
    [indexList release];
    [filteredList release];
    [indexTableView release];
    [dataTableView release];
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
    
    self.title = @"관심종목 등록";
    
    // HTS 싱크.
    UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithTitle:@"HTS연계" style:UIBarButtonItemStylePlain target:self action:@selector(syncToHTS:)];
	self.navigationItem.rightBarButtonItem = syncButton;
    [syncButton release];
    
    // 인덱스 설정.
    [self setIndex];
    
    // 주식 코드 로드.
    [self loadStockCodes];
    
    // 그룹이름 초기화.
    self.irGroup = [[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:0];
    self.groupLabel.text = [self.irGroup valueForKey:@"groupName"];
    
    // 피커뷰 표시를 위해...
    isSelectedPicker = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.filteredList = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.filteredList = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self togglePicker:1];
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
    int ctn;
    
    // 인덱스.
    if (tableView == self.indexTableView) 
    {
        ctn =  [self.indexes count];
    }
    
    // 데이터.
    if (tableView == self.dataTableView) 
    {
        ctn = [self.stockCodes count];
    }
    
    // 데이터 검색.
    if (tableView == self.searchDisplayController.searchResultsTableView) 
    {
        ctn = [self.filteredList count];
    }
    
    return ctn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        tableView.separatorColor = RGB(82, 82, 82);
        
        if (tableView == indexTableView) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        if (tableView == dataTableView || tableView == self.searchDisplayController.searchResultsTableView) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    
    if (tableView == self.indexTableView)
    {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = RGB(237, 237, 237);
        cell.textLabel.text = [[self.indexes objectAtIndex:indexPath.row] objectForKey:@"indexName"];
    }
    
    // 홀짝 컬러.
    if (tableView == dataTableView || tableView == self.searchDisplayController.searchResultsTableView)
    {
        tableView.backgroundColor = RGB(61, 61, 61);
        UIView *bgColor = [cell viewWithTag:100];
        if (!bgColor) 
        {
            CGRect frame = CGRectMake(0, 0, 320, self.dataTableView.rowHeight);
            bgColor = [[UIView alloc] initWithFrame:frame];
            bgColor.tag = 100; // 나중에 뷰에서 태그로 접근함.
            [cell addSubview:bgColor];
            [cell sendSubviewToBack:bgColor];
            [bgColor release];
        }
        
        if (indexPath.row % 2 == 0)
        {
            bgColor.backgroundColor = RGB(61, 61, 61);
        } 
        else 
        {
            bgColor.backgroundColor = RGB(82, 82, 82);
        }
    }
    
    if (tableView == dataTableView)
    {
        cell.imageView.image = [UIImage imageNamed:@"star_off.png"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = RGB(237, 237, 237);
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = RGB(146, 146, 146);
        cell.textLabel.text = [[self.stockCodes objectAtIndex:indexPath.row] objectForKey:@"stockName"];
        cell.detailTextLabel.text = [[self.stockCodes objectAtIndex:indexPath.row] objectForKey:@"stockCode"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) 
    {
        cell.imageView.image = [UIImage imageNamed:@"star_off.png"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = RGB(237, 237, 237);
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = RGB(146, 146, 146);
        cell.textLabel.text = [[self.filteredList objectAtIndex:indexPath.row] objectForKey:@"stockName"];
        cell.detailTextLabel.text = [[self.filteredList objectAtIndex:indexPath.row] objectForKey:@"stockCode"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 인덱스 선택.
    if (tableView == self.indexTableView)
    {
        NSString *searchString = [[self.indexes objectAtIndex:indexPath.row] objectForKey:@"indexName"];
        
        for (int idx = 0; idx < [self.stockCodes count]; idx++)
        {
            NSString *stockName = [[self.stockCodes objectAtIndex:idx] objectForKey:@"stockName"];
            NSString *substringStockName = [stockName substringWithRange:NSMakeRange(0, 1)];
            
            // TODO: 숫자와 알파벳의 경우 세부 검색 조절해야 함.
            if (indexPath.row == 0) 
            {
                // 0-9.
                searchString = @"0123456789";
                searchString = @"3";
                NSRange rangeSearch = [searchString rangeOfString:substringStockName];
                
                if (rangeSearch.location != NSNotFound) 
                {
                    [self.dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            else if (indexPath.row == 1) 
            {
                // A-Z.
                //searchString = @"ABCDEFGHIZKLMNOPQRSTUVWXYZ";
                searchString = @"A";
                NSRange rangeSearch = [[searchString lowercaseString] rangeOfString:[substringStockName lowercaseString]];
            
                if (rangeSearch.location != NSNotFound) 
                {
                    [self.dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            else
            {
                if ([substringStockName isEqualToString:searchString])
                {
                    // 가, 나, 다, 라...
                    [self.dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }
    }
    
    // 선택된 항목을 그룹별로 IRStock 테이블에 입력한다.
    if (tableView == dataTableView || tableView == self.searchDisplayController.searchResultsTableView)
    {
        if (tableView == dataTableView) 
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
            
            // 데이터 추가.
            // searchGroup = 0이면 전체 검색.
            totalCountIRStock = [[[self fetchedResultsControllerForIRStock:0] fetchedObjects] count];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:(totalCountIRStock + 1)] forKey:@"idx"];
            [dict setValue:[[self.stockCodes objectAtIndex:indexPath.row] objectForKey:@"stockCode"] forKey:@"stockCode"];
            [dict setValue:[[self.stockCodes objectAtIndex:indexPath.row] objectForKey:@"stockName"] forKey:@"stockName"];
            [dict setValue:[[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:currentIndex] forKey:@"group"];
            
            // IRStock 테이블에 입력.
            [self insertNewObject:dict];
            
            // SB 등록 메시지 전송.
            [[AppInfo sharedAppInfo] regSB:dict idx:@"0" trCode:TRCD_SS01REAL];
            
            // 셀 선택 해제.
            [cell setSelected:NO animated:YES];
        }
        
        // 검색 결과 중 선택된 항목을 그룹별로 IRStock 테이블에 입력한다.
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
            
            // 데이터 추가.
            // searchGroup = 0이면 전체 검색.
            totalCountIRStock = [self.filteredList count];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:(totalCountIRStock + 1)] forKey:@"idx"];
            [dict setValue:[[self.filteredList objectAtIndex:indexPath.row] objectForKey:@"stockCode"] forKey:@"stockCode"];
            [dict setValue:[[self.filteredList objectAtIndex:indexPath.row] objectForKey:@"stockName"] forKey:@"stockName"];
            [dict setValue:[[self.fetchedResultsControllerForIRGroup fetchedObjects] objectAtIndex:currentIndex] forKey:@"group"];
            
            // IRStock 테이블에 입력.
            [self insertNewObject:dict];
            
            // SB 등록 메시지 전송.
            [[AppInfo sharedAppInfo] regSB:dict idx:@"0" trCode:TRCD_SS01REAL];
            
            // 셀 선택 해제.
            [cell setSelected:NO animated:YES];
        }
        
        
        // 관심종목 추가 노티피케이션큐: 그룹 1만.
        [self fetchedResultsControllerForIRStock:1];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.fetchedResultsControllerForIRStock, @"addIRStock", nil];
        NSNotificationQueue *nq = [NSNotificationQueue defaultQueue];
        [nq enqueueNotification:[NSNotification notificationWithName:@"AddIRStock" object:self userInfo:dict2] postingStyle:NSPostWhenIdle];
    }
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
}

#pragma mark - UISearchBar 델리게이트

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar 
{
    [self.searchBar sizeToFit];
	[self.searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCloseButtonTitle:@"취소" forState:UIControlStateNormal];
    
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar 
{
	// 디자인을 위해 검색 버튼 보이기.
//    self.mikeButton.hidden = NO;
//    self.searchButton.hidden = NO;
//    
//	[self.searchBar sizeToFit];
//	[self.searchBar setShowsCancelButton:NO animated:YES];
//    self.searchBar.frame = SEARCHBAR_FRMAE;
    
	return YES;
}

// 취소.
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 디자인을 위해 검색 버튼 보이기.
//    self.mikeButton.hidden = NO;
//    self.searchButton.hidden = NO;
//    
//    self.searchBar.text = nil;
//    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchDisplayController 델리게이트 메서드

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
	[self.filteredList removeAllObjects];
    
	for (NSMutableDictionary *dict in self.stockCodes) 
    {
        // 종목명과 종목코드 동시 검색.
		NSString *stockName = [dict objectForKey:@"stockName"];
        NSString *stockCode = [dict objectForKey:@"stockCode"];
		NSRange rangeName = [stockName rangeOfString:searchString];
        NSRange rangeCode = [stockCode rangeOfString:searchString];
        
		if (rangeName.location != NSNotFound || rangeCode.location != NSNotFound) 
        {
			[self.filteredList addObject:dict];
		}
	}
	
    return YES;
}

#pragma mark - Fetched results controller

// IRGroup 테이블에서 그룹 목록 가져오기.
- (NSFetchedResultsController *)fetchedResultsControllerForIRGroup
{
    if (__fetchedResultsControllerForIRGroup != nil)
    {
        return __fetchedResultsControllerForIRGroup;
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
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
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
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsControllerForIRGroup;
}   

// IRStock 테이블에서 현재 선택된 그룹포함된 주식종목 목록 가져오기.
- (NSFetchedResultsController *)fetchedResultsControllerForIRStock:(int)searchGroup
{
    /*
     * fetched results controller 설정.
     */
    // 엔티티를 위한 리궤스트 생성.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // 엔티티 이름 설정.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRStock" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 배치 사이즈 설정.
    [fetchRequest setFetchBatchSize:50];
    
    // 검색조건.
    if (searchGroup != 0) {
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %d", searchGroup];
        [fetchRequest setPredicate:predicate];
    }
    
    // 정렬할 키 설정.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
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
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsControllerForIRStock;
} 

#pragma markt - CR

// 삽입.
- (void)insertNewObject:(NSMutableDictionary *)dict
{
    if (![self isObjectExistence:dict]) 
    {
        // 페치 리절트 컨트롤러에 의해 관리되는 엔티티의 새 인스턴스 생성.
        NSManagedObjectContext *context = self.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRStock" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        // 새 관리 객체 설정.
        [newManagedObject setValue:[dict objectForKey:@"idx"] forKey:@"idx"];
        [newManagedObject setValue:[dict objectForKey:@"stockCode"] forKey:@"stockCode"];
        [newManagedObject setValue:[dict objectForKey:@"stockName"] forKey:@"stockName"];
        [newManagedObject setValue:[dict objectForKey:@"group"] forKey:@"group"];
    
        // 컨텍스트 저장.
        NSError *error = nil;
        if (![context save:&error])
        {
            // TODO: 에러 처리.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else
    {
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:@"이미 등록된 종목 입니다."];
    }
    
}

// 확인.
- (IRStock *)isObjectExistence:(NSMutableDictionary *)dict 
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"IRStock" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // 검색 조건.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(group == %@) AND (stockCode == %@) AND (stockName == %@)", [dict objectForKey:@"group"],  [dict objectForKey:@"stockCode"], [dict objectForKey:@"stockName"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) 
    {
        NSUInteger count = [array count]; 
        // 만약 count == 0 이면 해당 그룹에 주식 종목이 없다.
        Debug(@"Searched count: %d", count);
        
        if (count > 0) 
        {
            // 객체가 하나라는 보장이 되어야 함!
            return [array lastObject];
        }
        else
        {
            return nil;
        }
    }
    else 
    {
        // TODO: 에러 치러!
        return nil;
    }
}

#pragma mark - 커스텀 메서드

- (NSIndexPath *)searchIndex:(NSString *)searchString
{
    return nil;
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

// 인덱스 설정.
- (void)setIndex
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	[tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0-9", @"indexName", @"0", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"A-Z", @"indexName", @"1", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"가", @"indexName", @"2", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"나", @"indexName", @"3", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"다", @"indexName", @"4", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"라", @"indexName", @"5", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"마", @"indexName", @"6", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"바", @"indexName", @"7", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"사", @"indexName", @"8", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"아", @"indexName", @"9", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"자", @"indexName", @"10", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"차", @"indexName", @"11", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"카", @"indexName", @"12", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"타", @"indexName", @"13", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"파", @"indexName", @"14", @"index", nil]];
    [tmpArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"하", @"indexName", @"15", @"index", nil]];
	
	self.indexes = tmpArray;
	[tmpArray release];
}

// 주식코드 로드.
- (void)loadStockCodes
{
    self.stockCodes = [NSMutableArray arrayWithCapacity:[[AppInfo sharedAppInfo].stockCodeMasters count]];
    [self.stockCodes addObjectsFromArray:[AppInfo sharedAppInfo].stockCodeMasters];
}

// HTS의 관심종목으로 싱크.
- (IBAction)syncToHTS:(id)sender
{
    Debug(@"Snyc button tapped!");
}

- (IBAction)regIRStock:(id)sender
{
    Debug(@"Register button tapped!");
}

@end
