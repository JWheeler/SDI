//
//  IRStockAddViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class IRGroup;
@class IRStock;


@interface IRStockAddViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *pickerView;
    UIToolbar *toolbar;
    BOOL isSelectedPicker;
    int currentIndex;       // 현재 선택된 그룹의 인덱스(0부터 시작).
    int totalCountIRStock;  // IRStock 테이블의 전체 행 수.
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForIRGroup;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForIRStock;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IRGroup *irGroup;

@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPickerButton;
@property (nonatomic, retain) IBOutlet UILabel *groupLabel;

@property (nonatomic, retain) NSMutableArray *indexes;              // 검색용 인덱스 목록.
@property (nonatomic, retain) NSMutableArray *stockCodes;           // 주식코드 전체 목록.
@property (nonatomic, retain) NSMutableArray *indexList;            // 인덱스로 검색된 목록.
@property (nonatomic, retain) NSMutableArray *filteredList;         // 종목명 또는 주식코드로 검색된 목록.
@property (nonatomic, retain) IBOutlet UITableView *indexTableView;
@property (nonatomic, retain) IBOutlet UITableView *dataTableView;

- (NSFetchedResultsController *)fetchedResultsControllerForIRGroup;
- (NSFetchedResultsController *)fetchedResultsControllerForIRStock:(int)searchGroup;
- (void)insertNewObject:(NSMutableDictionary *)dict;
- (IRStock *)isObjectExistence:(NSMutableDictionary *)dict;

- (NSIndexPath *)searchIndex:(NSString *)searchString;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)selectPicker:(id)sender;
- (void)togglePicker:(int)type;

- (void)setIndex;
- (void)loadStockCodes;
- (IBAction)syncToHTS:(id)sender;
- (IBAction)regIRStock:(id)sender;

@end
