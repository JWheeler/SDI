//
//  SecondViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuGroup.h"

// 메인 메뉴 버튼.
#define BUTTON_COLUMNS 4
#define BUTTON_ROWS 5
#define BUTTON_COUNT (BUTTON_COLUMNS * BUTTON_ROWS)
#define BUTTON_MARGIN 7
#define BUTTON_WIDTH 65
#define BUTTON_HEIGHT 65
#define BUTTON_START_X 13.0
#define BUTTON_START_Y 8.0

// 서브 메뉴 버튼.
#define SUB_BUTTON_COLUMNS 4
#define SUB_BUTTON_WIDTH 60
#define SUB_BUTTON_HEIGHT 60
#define MAX_SUB_BUTTON_COUNT 8
#define SUB_BUTTON_MARGIN 16
#define SUB_BUTTON_START_X 16.0
#define SUB_BUTTON_START_Y 40.0

@interface SecondViewController : UIViewController
{
    NSMutableArray *menuGroups;
    NSMutableArray *menus;
    NSMutableArray *filteredMenus;
    
    // 메인 메뉴 버튼 관련.
    CGRect buttonFrame[BUTTON_COUNT];
    UIButton *buttonForFrame[BUTTON_COUNT];
    
    // 서브 메뉴 버튼 관련.
    CGRect subButtonFrame[MAX_SUB_BUTTON_COUNT];
    UIButton *subButtonForFrame[MAX_SUB_BUTTON_COUNT];
    UILabel *labelForFrame[MAX_SUB_BUTTON_COUNT];
    
    // 폴더 애니메이션 관련.
    UIView *mainBackgroundView;
	UIView *folderView;
	UIView *selectedArrowTipView;
	UIImageView *bottomPartOfMainBackgroundView;
	UIButton *folderIcon;
}

@property (nonatomic, retain) NSMutableArray *menuGroups;
@property (nonatomic, retain) NSMutableArray *menus;
@property (nonatomic, retain) NSMutableArray *filteredMenus;

@property (nonatomic, retain) IBOutlet UIView *mainBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *folderView;
@property (nonatomic, retain) IBOutlet UIView *selectedArrowTipView;
@property (nonatomic, retain) IBOutlet UIImageView *bottomPartOfMainBackgroundView;
@property (nonatomic, retain) IBOutlet UIButton *folderIcon;

- (NSMutableArray *)loadMenuGroups;
- (NSMutableArray *)loadMenus;
- (void)filteredMenus:(NSInteger)groupID;
- (void)createButtons;
- (void)createSubButton:(NSInteger)groupID;
- (IBAction)openTarget:(id)sender;

- (IBAction)openFolder:(id)sender;
- (void)changeButtonState:(NSInteger)buttonTag withType:(BOOL)type;

@end
