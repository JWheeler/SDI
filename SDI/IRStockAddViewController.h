//
//  IRStockAddViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IRStockAddViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
}

@property (nonatomic, retain) NSMutableArray *indexes;
@property (nonatomic, retain) NSMutableArray *stockCodes;
@property (nonatomic, retain) NSMutableArray *indexList;
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) IBOutlet UITableView *indexTableView;
@property (nonatomic, retain) IBOutlet UITableView *dataTableView;

- (void)setIndex;
- (void)loadStockCodes;
- (IBAction)regIRStock:(id)sender;

@end
