//
//  MyMenuEditViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyMenuEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *defaultMyMenus;
}

@property (nonatomic, retain) IBOutlet UITableView *menuTable;
@property (nonatomic, retain) NSMutableArray *myMenus;
@property (nonatomic, retain) NSMutableArray *displayMyMenus;

- (NSString *)applicationDocumentsDirectory;
- (BOOL)isFileExistence:(NSString *)file;
- (NSMutableArray *)loadMyMenus;
- (IBAction)editMyMenu:(id)sender;
- (void)saveMyMenu;

@end
