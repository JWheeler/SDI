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

@interface IRStockListViewController : UIViewController <NSFetchedResultsControllerDelegate, 
UITableViewDataSource, UITableViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource> 
{
    UIColor *defaultTintColor;
    UIPickerView *pickerView;
    UIToolbar *toolbar;
    BOOL showPickerVeiw;
    int currentIndex;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IRGroup *irGroup;

@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPickerButton;
@property (nonatomic, retain) IBOutlet UILabel *groupLabel;

- (IBAction)backAction:(id)sender;
- (IBAction)segmentAction:(id)sender;
- (IBAction)previousAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)selectPicket:(id)sender;

@end
