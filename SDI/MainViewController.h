//
//  MainViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UISearchBar *searchBar;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

// 웹소켓 테스트.
- (IBAction)reconnect:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)sendTR:(id)sender;
- (void)viewText:(NSNotification *)notification;

@end
