//
//  SecondViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"


@interface SecondViewController : UIViewController
{
    UILabel *trCode;
    UILabel *price;
    UILabel *volume;
}

@property (nonatomic, retain) IBOutlet UILabel *trCode;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) IBOutlet UILabel *volume;

// 웹소켓 테스트.
- (IBAction)reconnect:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)sendTR:(id)sender;
- (void)viewText:(NSNotification *)notification;

// 코어 데이터 SB 등록, 해제 테스트.
- (IBAction)save:(id)sender;
- (IBAction)remove:(id)sender;

@end
