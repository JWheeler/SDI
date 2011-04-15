//
//  MainViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "MainViewController.h"
#import "LPUISearchBarMaskLayer.h"


@implementation MainViewController

@synthesize searchBar;

- (void)dealloc
{    
    [searchBar release];
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
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(viewText:) name:TRCD_SHNNREAL object:nil];
    
//    LPUISearchBarMaskLayer *maskLayer = [[LPUISearchBarMaskLayer alloc] init];
//    [maskLayer setFrame:CGRectMake(0, 0, 270, 34)];
//    [maskLayer setPosition:CGPointMake(138, 22)];
//    [maskLayer setNeedsDisplay];    
//    [self.searchBar.layer setNeedsDisplay];
//    [self.searchBar.layer setMask:maskLayer];
//    [maskLayer release];
    
    Debug(@">>>>>>>>>>>>>>>>>%@", NSStringFromCGPoint(self.searchBar.center));
}

- (void)viewText:(NSNotification *)notification 
{
	NSString *text = [[notification userInfo] objectForKey:@"title"];
	Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %@", text);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"test";
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

// 서버 재접속.
- (IBAction)reconnect:(id)sender 
{
    [[DataHandler sharedDataHandler] reconnect];
}

// 접속 종료.
- (IBAction)close:(id)sender
{
    [[DataHandler sharedDataHandler] close];
}

// 전문 전송.
- (IBAction)sendTR:(id)sender 
{
    // 3 단계: SB 등록.
    // SB 등록 테스트.
    NSMutableArray *sbBodies = [NSMutableArray array];
//    for (int i = 0; i < 1; i++) 
//    {
//        SBRegBody *sbRegBody = [[SBRegBody alloc] init];
//        sbRegBody.idx = @"N";
//        
//        if (i == 0) {
//            sbRegBody.code = @"null";
//        }
//        if (i == 1) {
//            sbRegBody.code = @"003450";
//        }
//        if (i == 2) {
//            sbRegBody.code = @"005930";
//        }
//        
//        [sbBodies addObject:sbRegBody];
//    }
    SBRegBody *sbRegBody = [[SBRegBody alloc] init];
    sbRegBody.idx = @"N";
    sbRegBody.code = @"";
    [sbBodies addObject:sbRegBody];
    
    TRGenerator *tr =  [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_REGSITER andTRCode:TRCD_SHNNREAL withCodeSet:sbBodies]];
}

@end
