//
//  IRStockAddViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "IRStockAddViewController.h"
#import "StockCode.h"


@implementation IRStockAddViewController

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
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [indexes release];
    [stockCodes release];
    [indexList release];
    [filteredList release];
    [indexTableView release];
    [dataTableView release];
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
    
    // 등록 버튼.
    UIBarButtonItem *regButton = [[UIBarButtonItem alloc] initWithTitle:@"등록" style:UIBarButtonItemStylePlain target:self action:@selector(regIRStock:)];
	self.navigationItem.rightBarButtonItem = regButton;
    [regButton release];
    
    // 인덱스 설정.
    [self setIndex];
    
    // 주식 코드 로드.
    [self loadStockCodes];
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
    
    filteredList = [[NSMutableArray alloc] init];
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
		ctn = [filteredList count];
	} 
    
    return ctn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        if (tableView == indexTableView) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        if (tableView == dataTableView) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    
    if (tableView == self.indexTableView)
    {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [[self.indexes objectAtIndex:indexPath.row] objectForKey:@"indexName"];
    }
    
    if (tableView == dataTableView)
    {
        NSArray *searchStockCodes;
        if (tableView == self.searchDisplayController.searchResultsTableView) 
        {
            searchStockCodes = filteredList;
            NSDictionary *dict = [filteredList objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict objectForKey:@"stockName"];
            cell.detailTextLabel.text = [dict objectForKey:@"stockCode"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"star_off.png"];
            cell.textLabel.text = [[self.stockCodes objectAtIndex:indexPath.row] objectForKey:@"stockName"];
            cell.detailTextLabel.text = [[self.stockCodes objectAtIndex:indexPath.row] objectForKey:@"stockCode"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.indexTableView)
    {
        
    }
    
    // TODO: DB에 데이터 입력 구현.
    if (tableView == dataTableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"star_on.png"];
        
//        for (NSInteger idx = 0; idx < [self.stockCodes count]; idx++) 
//        {
//            UITableViewCell *idxCell = nil;
//            idxCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
//            if ([indexPath row] == idx) 
//            {
//                idxCell.imageView.image = [UIImage imageNamed:@"star_on.png"];
//            }
//            else 
//            {
//                idxCell.accessoryType = UITableViewCellAccessoryNone;
//            }
//        }
        //셀 선택을 해제한다.
        //[cell setSelected:NO animated:YES];
    }
}

#pragma mark - UISearchDisplayController 델리게이트 메서드

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString 
{
	[filteredList removeAllObjects];
	Debug(@">>>>>>>>>>>>>>>>>>>> %d", [self.stockCodes count]);
	for (NSDictionary *dict in self.stockCodes) 
    {
		NSString *stockName = [dict objectForKey:@"stockName"];
		NSRange rangeName = [stockName rangeOfString:searchString];
        
		if (rangeName.location != NSNotFound) 
        {
			[filteredList addObject:dict];
		}
	}
    
    Debug(@">>>>>>>>>>>>>>>>>>>> %d", [filteredList count]);
	
    return YES;
}

#pragma mark - 커스텀 메서드

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

- (IBAction)regIRStock:(id)sender
{
    Debug(@"Register button tapped!");
}

@end
