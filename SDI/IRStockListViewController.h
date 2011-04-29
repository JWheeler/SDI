//
//  IRStockListViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 6..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class IRGroup;
@class IRStock;
@class CustomHeader;

@interface IRStockListViewController : UIViewController <NSFetchedResultsControllerDelegate, 
UITableViewDataSource, UITableViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate> 
{
    UIColor *defaultTintColor;
    UIPickerView *pickerView;
    UIToolbar *toolbar;
    BOOL isSelectedPicker;      // 피커 선택 여부.
    int currentIndex;           // 현재 선택된 그룹의 인덱스(0부터 시작).
    int changeField;            // 마지막 필드 데이터 종류 변경.
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForIRGroup;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForIRStock;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IRGroup *irGroup;
@property (nonatomic, retain) NSMutableArray *stocks;
@property (nonatomic, retain) NSMutableArray *responseArray;
@property (nonatomic, retain) NSString *currentStockCode;
@property (nonatomic, retain) NSNumber *currentPrice;       // 현재가.

@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPickerButton;
@property (nonatomic, retain) IBOutlet UILabel *groupLabel;
@property (nonatomic, retain) IBOutlet UITextField *groupTextField;
@property (nonatomic, retain) IBOutlet UITableView *stockTableView;
@property (nonatomic, retain) CustomHeader *header;

- (NSFetchedResultsController *)fetchedResultsControllerForIRGroup;
- (NSFetchedResultsController *)fetchedResultsControllerForIRStock:(int)searchGroup;

- (void)setLayout;
- (void)requestStocks;
- (void)initDataSet;
- (void)viewText:(NSNotification *)notification;
- (void)refreshTableForAdd:(NSNotification *)notification;
- (void)refreshTableForDelete :(NSNotification *)notification;
- (IBAction)backAction:(id)sender;
- (IBAction)segmentAction:(id)sender;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)selectPicker:(id)sender;
- (void)togglePicker:(int)type;
- (void)changeHeaderImage:(CustomHeader *)customHeader;

@end
