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

@interface IRStockListViewController : UIViewController <NSFetchedResultsControllerDelegate, 
UITableViewDataSource, UITableViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource> 
{
    UIColor *defaultTintColor;
    UIPickerView *pickerView;
    UIToolbar *toolbar;
    BOOL showPickerVeiw;
    int currentIndex;       // 현재 선택된 그룹의 인덱스(0부터 시작).
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForIRGroup;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerForIRStock;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IRGroup *irGroup;
@property (nonatomic, retain) NSString *currentStockCode;
@property (nonatomic, retain) NSNumber *currentPrice;       // 현재가.ㄴ

@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPickerButton;
@property (nonatomic, retain) IBOutlet UILabel *groupLabel;
@property (nonatomic, retain) IBOutlet UITableView *stockTableView;

- (NSFetchedResultsController *)fetchedResultsControllerForIRGroup;
- (NSFetchedResultsController *)fetchedResultsControllerForIRStock:(int)searchGroup;

- (void)setLayout;
- (IBAction)backAction:(id)sender;
- (IBAction)segmentAction:(id)sender;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)selectPicker:(id)sender;
- (void)viewText:(NSNotification *)notification;

@end
