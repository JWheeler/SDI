//
//  MainViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 검색 결과 히스토리용 로직 추가!
//  TODO: 검색 후 테이뷸뷰의 탭이 안되는 문제 해결할 것!
//  TODO: 리팩토링!!!
//

#import "MainViewController.h"
#import "SDIAppDelegate.h"
#import "HTTPHandler.h"
#import "UISearchBar+Button.h"

#define SEARCHBAR_FRMAE CGRectMake(0.0, 0.0, 240.0, 44.0)

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
@synthesize realArray;
@synthesize responseArray;
@synthesize currentStockCode;
@synthesize currentPrice;
@synthesize currentSymbol;
@synthesize currentFluctuation;
@synthesize currentFluctuationRate;
@synthesize currentTradeVolume;

@synthesize searchBar;
@synthesize stockTableView;

@synthesize mikeButton;
@synthesize searchButton;

@synthesize searchResultView;
@synthesize stockList;
@synthesize resultStockName;
@synthesize resultCurrentPrice;
@synthesize resultImageView;
@synthesize resultFluctuation;

- (void)dealloc
{    
    [searchBar release];
    [stockTableView release];
    [mikeButton release];
    [searchButton release];
    [searchResultView release];
    [stockList release];
    [resultStockName release];
    [resultCurrentPrice release];
    [resultImageView release];
    [resultFluctuation release];
    [realArray release];
    [responseArray release];
    [currentStockCode release];
    [currentPrice release];
    [currentSymbol release];
    [currentFluctuation release];
    [currentFluctuationRate release];
    [currentTradeVolume release];
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
    
    // 실시간 시세 노티피케이션.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(viewText:) name:TRCD_SS01REAL object:nil];
    
    // 관심종목 추가 노티피케이션.
	[nc addObserver:self selector:@selector(refreshTableForAdd:) name:@"AddIRStock" object:nil];
    
    // 관심종목 삭제 노티피케이션.
	[nc addObserver:self selector:@selector(refreshTableForDelete:) name:@"DeleteIRStock" object:nil];
    
    // 검색바 설정.
    [self setSearchBar];
    
    // 테이블뷰의 데이터 설정을 위해...
    isReal = NO;
    changeField = 0;
    
    // 관심 종목 데이터 초기화.
    [self initIRStocks];
    
    // 리얼 데이터 설정용...
    self.realArray = [[NSMutableArray alloc] init];
    [self initRealArray];
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
    return [[self.fetchedResultsController sections] count];
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
        stockLabel.shadowColor = [UIColor darkGrayColor];
        stockLabel.shadowOffset = CGSizeMake(0, 1);
        [cell.contentView addSubview:stockLabel];
        
        // 현재가.
        currentPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(81.0, 0.0, CURRENT_PRICE_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        currentPriceLabel.tag = CURRENT_PRICE_LABEL_TAG;
        currentPriceLabel.backgroundColor = [UIColor clearColor];
        currentPriceLabel.font = [UIFont systemFontOfSize:17.0];
        currentPriceLabel.textAlignment = UITextAlignmentRight;
        currentPriceLabel.textColor = [UIColor whiteColor];
        currentPriceLabel.shadowColor = [UIColor darkGrayColor];
        currentPriceLabel.shadowOffset = CGSizeMake(0, 1);
        [cell.contentView addSubview:currentPriceLabel];
        
        // 전일대비구분: 상한(1), 상승(2), 보합(3), 하한(4), 하락(5) 추가 해야함!
        // 상한(1).
        upperArrowLabel = [[[UILabel alloc] initWithFrame:CGRectMake(168.0, 0.0, UP_ARROW_LABEL_WIDTH, tableView.rowHeight)] autorelease];
        upperArrowLabel.tag = UPPER_ARROW_LABEL_TAG;
        upperArrowLabel.backgroundColor = [UIColor clearColor];
        upperArrowLabel.hidden = YES;
        
        upperArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_uppper.png"]] autorelease];
        upperArrow.frame = CGRectMake(0.0, 0.0, 10.0, 13.0);
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
        lowerArrow.frame = CGRectMake(0.0, 0.0, 10.0, 13.0);
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
        fluctuationLabel.shadowColor = [UIColor darkGrayColor];
        fluctuationLabel.shadowOffset = CGSizeMake(0, 1);
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
        fluctuationRateLabel.shadowColor = [UIColor darkGrayColor];
        fluctuationRateLabel.shadowOffset = CGSizeMake(0, 1);
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
    
    float rateUnit = 0.0;
    if (isReal) 
    {
        Debug(@"Set real data!");
        for (NSMutableDictionary *dict in self.realArray) 
        {
            if ([[managedObject valueForKey:@"stockCode"] isEqualToString:[dict objectForKey:@"stockCode"]]) 
            {
                currentPriceLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"currentPrice"] intValue]];
                if ([[dict objectForKey:@"symbol"] isEqualToString:@"1"]) 
                {
                    rateUnit = 0.01;
                    upperArrowLabel.hidden = NO;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = YES;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor redColor];
                }
                if ([[dict objectForKey:@"symbol"] isEqualToString:@"2"]) 
                {
                    rateUnit = 0.01;
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = NO;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = YES;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor redColor];
                }
                if ([[dict objectForKey:@"symbol"] isEqualToString:@"3"]) 
                {
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = YES;
                }
                if ([[dict objectForKey:@"symbol"] isEqualToString:@"4"]) 
                {
                    rateUnit = -0.01;
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = NO;
                    downArrowLabel.hidden = YES;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor blueColor];
                }
                if ([[dict objectForKey:@"symbol"] isEqualToString:@"5"]) 
                {
                    rateUnit = -0.01;
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = NO;
                    fluctuationLabel.textColor = fluctuationRateLabel.textColor = [UIColor blueColor];
                }
                
                fluctuationLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"fluctuation"] intValue]];
                
                // 마지막 필드의 데이터 변경.
                switch (changeField) 
                {
                    case 0:
                        // 등락율.
                        fluctuationRateLabel.text = [NSString stringWithFormat:@"%.2f%@", ([[dict objectForKey:@"fluctuationRate"] floatValue] * rateUnit), @"%"];
                        break;
                    case 1:
                        // 거래량.
                        fluctuationRateLabel.text = [LPUtils formatNumber:[[dict objectForKey:@"tradeVolume"] intValue]];
                        break;
                    default:
                        fluctuationRateLabel.text = [NSString stringWithFormat:@"%.2f%@", ([[dict objectForKey:@"fluctuationRate"] floatValue] * rateUnit), @"%"];
                        break;
                }
            }
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
                if ([[dict objectForKey:@"bDyCmprSmbl"] isEqualToString:@"3"]) 
                {
                    upperArrowLabel.hidden = YES;
                    upArrowLabel.hidden = YES;
                    lowerArrowLabel.hidden = YES;
                    downArrowLabel.hidden = YES;
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar 
{
	// 디자인을 위해 검색 버튼 감추기.
    self.mikeButton.hidden = YES;
    self.searchButton.hidden = YES;
    
	[self.searchBar sizeToFit];
	[self.searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setCloseButtonTitle:@"취소" forState:UIControlStateNormal];
    
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar 
{
	// 디자인을 위해 검색 버튼 보이기.
    self.mikeButton.hidden = NO;
    self.searchButton.hidden = NO;
    
	[self.searchBar sizeToFit];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.frame = SEARCHBAR_FRMAE;
    
	return YES;
}

// 취소.
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 디자인을 위해 검색 버튼 보이기.
    self.mikeButton.hidden = NO;
    self.searchButton.hidden = NO;
    
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
}

// 검색.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // SOLogger 테스트.
    [gLogger debug:@"Entering %s", __FUNCTION__];
    
    self.stockList = [NSMutableArray arrayWithCapacity:[[AppInfo sharedAppInfo].stockCodeMasters count]];
    [self.stockList addObjectsFromArray:[AppInfo sharedAppInfo].stockCodeMasters];
    
    for (NSMutableDictionary *dict in self.stockList) 
    {
        // 종목명과 종목코드 동시 검색.
		NSString *stockName = [dict objectForKey:@"stockName"];
        NSString *stockCode = [dict objectForKey:@"stockCode"];
        
        // ==(equal) 검색!
		if ([stockName isEqualToString:self.searchBar.text] || [stockCode isEqualToString:self.searchBar.text]) 
        {
			// HTTPRequest: 리얼 시세 데이터 가 들어 오기 전에 종목별 현재가 설정을 위해...
            self.responseArray = [[NSMutableArray alloc] init];
            HTTPHandler *httpHandler = [[HTTPHandler alloc] init];
            // NSIndexPath의 indexPathWithIndex 메서드를 사용하기 위해, NSInteger를 사용함!
           
            [httpHandler searchCurrentPrice:stockCode];
            if (httpHandler.reponseDict != nil) 
            {
                [self setupSearchResultView:httpHandler.reponseDict withStockName:stockName];
                self.searchBar.text = nil;
                return;
            }
		}
        
        if (dict == [self.stockList lastObject]) {
            [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:@"검색 결과가 없습니다."];
        }
	}
}

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
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %d", 1];
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

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.stockTableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    switch(type)
//    {
//        case NSFetchedResultsChangeInsert:
//            [self.stockTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.stockTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
//{
//    UITableView *tableView = self.stockTableView;
//    
//    switch(type)
//    {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            [tableView reloadData];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.stockTableView endUpdates];
//}

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
}

// !!!: Real과 RQ/RP 통신 포맷이 달라 분리해 놓음.
// 실시간 데이터 설정용.
- (void)initRealArray
{
    self.realArray = nil;
    
    for (NSManagedObject *managedObject in [self.fetchedResultsController fetchedObjects])
    {
        
       [self.realArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [managedObject valueForKey:@"stockCode"], @"stockCode", 
                                  [managedObject valueForKey:@"stockName"], @"stockName", 
                                  0, @"currentPrice",
                                  @"", @"symbol",
                                  0, @"fluctuation",
                                  0, @"fluctionRate",
                                  0, @"tradeVolume",
                                  nil]];
    }
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
    Debug(@"Received real data!");
    isReal = YES;
    self.currentStockCode = [[notification userInfo] objectForKey:@"isCd"];             // 종목코드.
    self.currentPrice = [[notification userInfo] objectForKey:@"nowPrc"];               // 현재가.
    self.currentSymbol = [[notification userInfo] objectForKey:@"bDyCmprSmbl"];         // 전일대비구분. bDyCmprSmbl
    self.currentFluctuation = [[notification userInfo] objectForKey:@"bDyCmpr"];        // 전일대비(등락).
    self.currentFluctuationRate = [[notification userInfo] objectForKey:@"bDyCmprR"];   // 전일대비율(등락율).
    self.currentTradeVolume = [[notification userInfo] objectForKey:@"acmlVlm"];        // 변동거래량.
    
    for (NSMutableDictionary *dict in self.realArray) 
    {
        if ([[dict objectForKey:@"stockCode"] isEqualToString:[[notification userInfo] objectForKey:@"isCd"]]) 
        {
            [dict setObject:[[notification userInfo] objectForKey:@"nowPrc"] forKey:@"currentPrice"];
            [dict setObject:[[notification userInfo] objectForKey:@"bDyCmprSmbl"] forKey:@"symbol"];
            [dict setObject:[[notification userInfo] objectForKey:@"bDyCmpr"] forKey:@"fluctuation"];
            [dict setObject:[[notification userInfo] objectForKey:@"bDyCmprR"] forKey:@"fluctuationRate"];
            [dict setObject:[[notification userInfo] objectForKey:@"acmlVlm"] forKey:@"tradeVolume"];
            
            [self.stockTableView reloadData];
        }
    }
}

// 관심종목 추가에 따른 데이블뷰 갱신.
- (void)refreshTableForAdd :(NSNotification *)notification 
{
    self.fetchedResultsController = [[notification userInfo] objectForKey:@"addIRStock"];
    [self initIRStocks];
    [self initRealArray];
    [self.stockTableView reloadData];
}

// 관심종목 삭제에 따른 데이블뷰 갱신.
- (void)refreshTableForDelete :(NSNotification *)notification 
{
    self.fetchedResultsController = [[notification userInfo] objectForKey:@"deleteIRStock"];
    [self initIRStocks];
    [self initRealArray];
    [self.stockTableView reloadData];
}

// 검색 결과를 출력하기 위한 뷰 설정.
- (void)setupSearchResultView:(NSDictionary *)searchResult withStockName:(NSString *)stockName
{
    // 검색 결과 뷰 제거를 위한 제스처 등록.
    UITapGestureRecognizer *recognizerTab = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearchResultView:)] autorelease];
	// 스와이프 제스처를 인식하기위한 탭 수.
	recognizerTab.numberOfTouchesRequired = 1;
	[self.searchResultView addGestureRecognizer:recognizerTab];
    
    [self.searchBar resignFirstResponder];
    
    // 검색 결과뷰를 최상 위에 추가하기 위해 앱델리게이트의 window를 이용함!
    SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self.searchResultView];
    
    self.searchResultView.frame = CGRectMake(0.0, 65.0, 320.0, 480.0);
    self.searchResultView.alpha = 0.7;
    self.searchResultView.hidden = NO;
    
    self.resultStockName.text = stockName;
    self.resultCurrentPrice.text = [searchResult objectForKey:@"nowPrc"];
    self.resultFluctuation.text = [searchResult objectForKey:@"upDwnR"];
    
    NSString *imageName;
    if ([[searchResult objectForKey:@"bDyCmprSmbl"] isEqualToString:@"1"])
    {
        imageName = @"icon_upper_price.png";
    }
    if ([[searchResult objectForKey:@"bDyCmprSmbl"] isEqualToString:@"2"])
    {
        imageName = @"icon_up_price.png";
    }
    if ([[searchResult objectForKey:@"bDyCmprSmbl"] isEqualToString:@"4"])
    {
        imageName = @"icon_lower_price.png";
    }
    if ([[searchResult objectForKey:@"bDyCmprSmbl"] isEqualToString:@"5"])
    {
        imageName = @"icon_down_price.png";
    }
    
    if (![[searchResult objectForKey:@"bDyCmprSmbl"] isEqualToString:@"3"])
    {
        self.resultImageView.image = [UIImage imageNamed:imageName];
    }
}

// 검색 결과 뷰 제거.
- (void)closeSearchResultView:(UITapGestureRecognizer *)recognizer
{
    //self.searchResultView.hidden = NO;
    self.searchResultView.alpha = 0.0;
    self.searchResultView.opaque = YES;
    
//    SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [self.searchResultVie sendSubviewToBack:self.searchResultView];
    //self.searchResultView.frame = CGRectMake(-320.0, -480.0, 320.0, 480.0);
    //[self.searchResultView sendSubviewToBack:self.view];
}

@end
