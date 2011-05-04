//
//  MyMenuAddViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyMenuAddViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> 
{
    
}

@property (nonatomic, retain) IBOutlet UITableView *menuTable;
@property (nonatomic, retain) NSMutableArray *menuGroups;
@property (nonatomic, retain) NSMutableArray *menus;
@property (nonatomic, retain) NSMutableArray *myMenus;
@property (nonatomic, retain) NSMutableArray *dataSets;

- (IBAction)backAction:(id)sender;
- (IBAction)myMenuSort:(id)sender;
- (NSString *)applicationDocumentsDirectory;
- (NSMutableArray *)loadMenuGroups;
- (NSMutableArray *)loadMenus;
- (NSMutableDictionary *)filteredMenus:(NSString *)groupID;
- (NSMutableArray *)loadMyMenus;
- (NSMutableArray *)createDataSet;
- (void)saveMyMenus;

@end
