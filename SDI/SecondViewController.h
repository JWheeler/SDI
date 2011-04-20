//
//  SecondViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuGroup.h"

#define BUTTON_COLUMNS 4
#define BUTTON_ROWS 5
#define BUTTON_COUNT (BUTTON_COLUMNS * BUTTON_ROWS)
#define BUTTON_MARGIN 7
#define BUTTON_WIDTH 65
#define BUTTON_HEIGHT 65
#define BUTTON_START_X 13.0
#define BUTTON_START_Y 8.0


@interface SecondViewController : UIViewController
{
    // 버튼 관련.
    CGRect buttonFrame[BUTTON_COUNT];
    UIButton *buttonForFrame[BUTTON_COUNT];
	NSMutableArray *menuGroups;
    
    // 폴더 애니메이션 관련.
    UIView *mainBackgroundView;
	UIView *folderView;
	UIView *selectedArrowTipView;
	UIImageView *bottomPartOfMainBackgroundView;
	UIButton *folderIcon;
}

@property (nonatomic, retain) NSMutableArray *menuGroups;

@property (nonatomic, retain) IBOutlet UIView *mainBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *folderView;
@property (nonatomic, retain) IBOutlet UIView *selectedArrowTipView;
@property (nonatomic, retain) IBOutlet UIView *bottomPartOfMainBackgroundView;
@property (nonatomic, retain) IBOutlet UIButton *folderIcon;

- (NSMutableArray *)loadMenuGroups;
- (void)createButtons;
- (IBAction)buttonPressed:(id)sender;

- (IBAction)openFolder:(id)sender;

@end
