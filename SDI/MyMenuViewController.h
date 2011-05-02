//
//  MyMenuViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
   
}

@property (nonatomic, retain) IBOutlet UITableView *myMenuTable;
@property (nonatomic, retain) NSMutableArray *myMenus;

- (NSString *)applicationDocumentsDirectory;
- (BOOL)isFileExistence:(NSString *)file;
- (void)createEditableCopyOfFileIfNeeded;
- (void)loadMyMenus;
- (IBAction)buttonPressed:(id)sender;
- (void)removeMyMenuTapGesture:(UITapGestureRecognizer *)recognizer;
- (IBAction)voiceSearch:(id)sender;

@end
