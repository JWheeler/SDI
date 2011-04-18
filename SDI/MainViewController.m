//
//  MainViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MainViewController.h"
#import "SDIAppDelegate.h"
#import "HTTPHandler.h"

#define STOCK_LABEL_WIDTH 87
#define CURRENT_PRICE_LABEL_WIDTH 80
#define UP_ARROW_LABEL_WIDTH 10
#define DOWN_ARROW_LABEL_WIDTH 10
#define FLUCTUATION_LABEL_WIDTH 53
#define FLUCTUATION_RATE_BG_LABEL_WIDTH 90
#define FLUCTUATION_RATE_LABEL_WIDTH 76

#define STOCK_LABEL_TAG 1
#define CURRENT_PRICE_LABEL_TAG 2
#define UPPER_ARROW_LABEL_TAG 3
#define UP_ARROW_LABEL_TAG 4
#define LOWER_ARROW_LABEL_TAG 5
#define DOWN_ARROW_LABEL_TAG 6
#define FLUCTUATION_LABEL_TAG 7
#define FLUCTUATION_RATE_BG_LABEL_TAG 8
#define FLUCTUATION_RATE_LABEL_TAG 9


@implementation MainViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize responseArray;
@synthesize currentStockCode;
@synthesize currentPrice;
@synthesize currentSymbol;
@synthesize currentFluctuation;
@synthesize currentFluctuationRate;

@synthesize searchBar;
@synthesize stockTableView;

- (void)dealloc
{    
    [searchBar release];
    [stockTableView release];
    [responseArray release];
    [currentStockCode release];
    [currentPrice release];
    [currentSymbol release];
    [currentFluctuation release];
    [currentFluctuationRate release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [__fetchedResultsController release];
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
    
    // 관리 객체 컨텍스트 설정.
    SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // 관심종목 그룹1의 목록 가져오기.
    [self fetchedResultsController];
    
    // 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(viewText:) name:TRCD_SS01REAL object:nil];
    
    // 검색바 설정.
    [self setSearchBar];
    
    // 테이블뷰 스타일.
	self.stockTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 133.0, 320.0, 325.0) style:UITableViewStylePlain];
    self.stockTableView.dataSource = self;
    self.stockTableView.delegate = self;
    self.stockTableView.rowHeight = 40.0;
    [self.view addSubview:self.stockTableView];
    
    // 테이블뷰의 데이터 설정을 위해...
    isReal = NO;
    changeField = 0;
    
    // 관심 종목 데이터 초기화.
    [self initIRStocks];
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
    [tableView setBackgroundColor:[UIColor clearColor]];
    return [[self.fetchedResultsController sections] count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    static NSString *CellIdentifier = @"Cell";
    
    // 커스텀 셀.
    //      - 종목명      - 현재가             - 등락                                       - 등락율, 거래량      
    UILabel *stockLabel, *currentPriceLabel, *fluctuationLabel, *fluctuationRateBgLabel, *fluctuationRateLabel, *upperArrowLabel, *upArrowLabel, *lowerArrowLabel, *downArrowLabel;
    UIImageView *upperArrow, *upArrow, *lowerArrow, *downArrow, *bg;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        // 종목.
        stockLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, STOCK_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        stockLabel.tag = STOCK_LABEL_TAG;
        stockLabel.backgroundColor = [UIColor clearColor];
        stockLabel.font = [UIFont systemFontOfSize:16.0];
        stockLabel.textAlignment = UITextAlignmentCenter;
        stockLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:stockLabel];
        
        // 현재가.
        currentPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(81.0, 0.0, CURRENT_PRICE_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        currentPriceLabel.tag = CURRENT_PRICE_LABEL_TAG;
        currentPriceLabel.backgroundColor = [UIColor clearColor];
        currentPriceLabel.font = [UIFont systemFontOfSize:17.0];
        currentPriceLabel.textAlignment = UITextAlignmentRight;
        currentPriceLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:currentPriceLabel];
        
        // 전일대비구분: 상한(1), 상승(2), 보합(3), 하한(4), 하락(5) 추가 해야함!
        // 상한(1).
        upperArrowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(168.0, 0.0, UP_ARROW_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        upperArrowLabel.tag = UPPER_ARROW_LABEL_TAG;
        upperArrowLabel.backgroundColor = [UIColor clearColor];
        upperArrowLabel.hidden = YES;
        
        upperArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_uppper.png"]] autorelease];
        upperArrow.frame = CGRectMake(0.0, 0.0, 9.0, 13.0);
        upperArrow.center = CGPointMake(upperArrowLabel.frame.size.width / 2, upperArrowLabel.center.y);
        [upperArrowLabel addSubview:upperArrow];
        
        [cell.contentView addSubview:upperArrowLabel];
        
        // 상승(2).
        upArrowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(168.0, 0.0, UP_ARROW_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        upArrowLabel.tag = UP_ARROW_LABEL_TAG;
        upArrowLabel.backgroundColor = [UIColor clearColor];
        upArrowLabel.hidden = YES;
        
        upArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_up.png"]] autorelease];
        upArrow.frame = CGRectMake(0.0, 0.0, 10.0, 10.0);
        upArrow.center = CGPointMake(upArrowLabel.frame.size.width / 2, upArrowLabel.center.y);
        [upArrowLabel addSubview:upArrow];
        
        [cell.contentView addSubview:upArrowLabel];
        
        // 하한(4)
        lowerArrowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(168.0, 0.0, DOWN_ARROW_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        lowerArrowLabel.tag = LOWER_ARROW_LABEL_TAG;
        lowerArrowLabel.backgroundColor = [UIColor clearColor];
        lowerArrowLabel.hidden = YES;
        
        lowerArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lower.png"]] autorelease];
        lowerArrow.frame = CGRectMake(0.0, 0.0, 9.0, 13.0);
        lowerArrow.center = CGPointMake(lowerArrowLabel.frame.size.width / 2, lowerArrowLabel.center.y);
        [lowerArrowLabel addSubview:lowerArrow];
        
        [cell.contentView addSubview:lowerArrowLabel];
        
        // 하락(5).
        downArrowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(168.0, 0.0, DOWN_ARROW_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        downArrowLabel.tag = DOWN_ARROW_LABEL_TAG;
        downArrowLabel.backgroundColor = [UIColor clearColor];
        downArrowLabel.hidden = YES;
        
        downArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down.png"]] autorelease];
        downArrow.frame = CGRectMake(0.0, 0.0, 10.0, 10.0);
        downArrow.center = CGPointMake(downArrowLabel.frame.size.width / 2, downArrowLabel.center.y);
        [downArrowLabel addSubview:downArrow];
        
        [cell.contentView addSubview:downArrowLabel];
 
        // 등락.
        fluctuationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(179.0, 0.0, FLUCTUATION_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        fluctuationLabel.tag = FLUCTUATION_LABEL_TAG;
        fluctuationLabel.backgroundColor = [UIColor clearColor];
        fluctuationLabel.font = [UIFont systemFontOfSize:17.0];
        fluctuationLabel.textAlignment = UITextAlignmentRight;
        fluctuationLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:fluctuationLabel];
        
        // 마지막 필드: 등락율, 거래량.
        fluctuationRateBgLabel = [[[UILabel alloc] initWithFrame:CGRectMake(231.0, 0.0, FLUCTUATION_RATE_BG_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        fluctuationRateBgLabel.tag = FLUCTUATION_RATE_BG_LABEL_TAG;
        fluctuationRateBgLabel.backgroundColor = [UIColor clearColor];
        fluctuationRateBgLabel.font = [UIFont systemFontOfSize:17.0];
        fluctuationRateBgLabel.textAlignment = UITextAlignmentRight;
        fluctuationRateBgLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:fluctuationRateBgLabel];
        
        fluctuationRateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, FLUCTUATION_RATE_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        fluctuationRateLabel.center = fluctuationRateBgLabel.center;
        fluctuationRateLabel.tag = FLUCTUATION_RATE_LABEL_TAG;
        fluctuationRateLabel.backgroundColor = [UIColor clearColor];
        fluctuationRateLabel.font = [UIFont systemFontOfSize:17.0];
        fluctuationRateLabel.textAlignment = UITextAlignmentRight;
        fluctuationRateLabel.textColor = [UIColor whiteColor];
        [cell.contentView insertSubview:fluctuationRateLabel belowSubview:fluctuationRateBgLabel];
        
        // 배경 이미지.
        bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_fluctuate.png"]] autorelease];
        bg.frame = CGRectMake(0.0, 0.0, 80.0, 31.0);
        bg.center = CGPointMake(fluctuationRateLabel.center.x + 1, fluctuationRateLabel.center.y);
        [cell.contentView insertSubview:bg belowSubview:fluctuationRateLabel];
    }
    else
    {
        stockLabel = (UILabel *)[cell.contentView viewWithTag:STOCK_LABEL_TAG];
        currentPriceLabel = (UILabel *)[cell.contentView viewWithTag:CURRENT_PRICE_LABEL_TAG];
        upperArrowLabel = (UILabel *)[cell.contentView viewWithTag:UPPER_ARROW_LABEL_TAG];
        upArrowLabel = (UILabel *)[cell.contentView viewWithTag:UP_ARROW_LABEL_TAG];
        lowerArrowLabel = (UILabel *)[cell.contentView viewWithTag:LOWER_ARROW_LABEL_TAG];
        downArrowLabel = (UILabel *)[cell.contentView viewWithTag:DOWN_ARROW_LABEL_TAG];
        fluctuationLabel = (UILabel *)[cell.contentView viewWithTag:FLUCTUATION_LABEL_TAG];
        fluctuationRateBgLabel = (UILabel *)[cell.contentView viewWithTag:FLUCTUATION_RATE_BG_LABEL_TAG];
        fluctuationRateLabel = (UILabel *)[cell.contentView viewWithTag:FLUCTUATION_RATE_LABEL_TAG];
    }
    
    // Configure the cell...
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    stockLabel.text = [managedObject valueForKey:@"stockName"];
    
    if (isReal) 
    {
        // 리얼 시세가 들어 오는 경우...
        if ([[[managedObject valueForKey:@"stockCode"] description] isEqualToString:self.currentStockCode]) 
        {
            currentPriceLabel.text = [LPUtils formatNumber:[self.currentPrice intValue]];
            fluctuationLabel.text = [LPUtils formatNumber:[self.currentFluctuation intValue]];
        }
    }
    else
    {
        // 화면에 처음 진입할 경우, RQ로 현재가 등의 데이터를 설정한다.
        float rateUnit = 0.0;
        for (NSDictionary *dict in self.responseArray) 
        {
            if ([[managedObject valueForKey:@"stockCode"] isEqualToString:[dict objectForKey:@"isNo"]]) 
            {
                currentPriceLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"nowPrc"] intValue]];
                if ([[dict objectForKey:@"bDyCmprSmbl"] isEqualToString:@"1"]) 
                {
                    rateUnit = 0.01;
                    upperArrowLabel.hidden = NO;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = YES;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor redColor];
                }
                if ([[dict objectForKey:@"bDyCmprSmbl"] isEqualToString:@"2"]) 
                {
                    rateUnit = 0.01;
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = NO;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = YES;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor redColor];
                }
                if ([[dict objectForKey:@"bDyCmprSmbl"] isEqualToString:@"4"]) 
                {
                    rateUnit = -0.01;
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = NO;
                    downArrowLabel.hidden = YES;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor blueColor];
                }
                if ([[dict objectForKey:@"bDyCmprSmbl"] isEqualToString:@"5"]) 
                {
                    rateUnit = -0.01;
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = NO;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor blueColor];
                }

                fluctuationLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"bDyCmpr"] intValue]];
                
                // 마지막 필드의 데이터 변경.
                switch (changeField) 
                {
                    case 0:
                        // 등락율.
                        fluctuationRateLabel.text = [NSString stringWithFormat:@"%.2f%@", ([[dict objectForKey:@"upDwnR"] floatValue] * rateUnit), @"%"];
                        break;
                    case 1:
                        // 거래량.
                        fluctuationRateLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"vlm"] intValue]];
                        break;
                    default:
                        fluctuationRateLabel.text = [NSString stringWithFormat:@"%.2f%@", ([[dict objectForKey:@"upDwnR"] floatValue] * rateUnit), @"%"];
                        break;
                }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (changeField >= 0) 
    {
        changeField = changeField + 1;
        
        if (changeField == 2) 
        {
            changeField = 0;
        }
    }
    
    [self.stockTableView reloadData];
}

#pragma mark - UISearchBar 델리게이트

#pragma mark - Fetched results controller

// IRStock 테이블에서 현재 선택된 그룹포함된 주식종목 목록 가져오기.
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    // 엔티티를 위한 리궤스트 생성.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // 엔티티 이름 설정.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRStock" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 배치 사이즈 설정: 하나의 그룹에 최대 50개의 주식종목 저장.
    [fetchRequest setFetchBatchSize:50];
    
    // 검색조건: 그룹 1월 종목목 가져온다.
    [fetchRequest setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == 1"];
	[fetchRequest setPredicate:predicate];
    
    // 정렬할 키 설정: displayOrder를 ascending 한다..
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    // TODO: 에러 처리.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
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

// 검색바 설정.
- (void)setSearchBar
{
    // 검색바 백그라운드 투명 처리.
    [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    
    // 액세서리뷰 생성.
	UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
	inputAccessoryView.backgroundColor = [UIColor darkGrayColor];
    
    // 닫기 버튼.
	
	// 상세검색 버튼.
	UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	searchButton.frame = CGRectMake(210.0, 6.5, 100.0, 37.0);
	[searchButton setTitle: @"상세검색" forState:UIControlStateNormal];
	[searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[searchButton addTarget:self action:@selector(openSearch:)forControlEvents:UIControlEventTouchUpInside];
	[inputAccessoryView addSubview:searchButton];
    [searchButton release];
    
    // 검색바의 텍스트필드: 위에서 백그라운드(0)을 제거하였으므로 텍스트필드의 인덱스는 0이다.
    UITextField *textField = (UITextField *)[self.searchBar.subviews objectAtIndex:0];
    textField.inputAccessoryView = inputAccessoryView;
}

// 관심 종목 데이터 초기화
- (void)initIRStocks
{
    // HTTPRequest: 리얼 시세 데이터 가 들어 오기 전에 종목별 현재가 설정을 위해...
    self.responseArray = [[NSMutableArray alloc] init];
    HTTPHandler *httpHandler = [[HTTPHandler alloc] init];
    for (NSInteger i = 0; i < [[self.fetchedResultsController fetchedObjects] count]; i++) 
    {
        // NSIndexPath의 indexPathWithIndex 메서드를 사용하기 위해, NSInteger를 사용함!
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
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
    Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    isReal = YES;
    self.currentStockCode = [[notification userInfo] objectForKey:@"isCd"];
    self.currentPrice = [[notification userInfo] objectForKey:@"nowPrc"]; 
    self.currentFluctuation = [[notification userInfo] objectForKey:@"bDyCmpr"]; 
    self.currentFluctuationRate = [[notification userInfo] objectForKey:@"bDyCmprR"]; 
    [self.stockTableView reloadData];
    isReal = NO;
}

@end
