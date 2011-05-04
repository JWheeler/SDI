//
//  MyMenuViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEW_REVISE 20
#define MY_MENU_BUTTON_COUNT 9
#define MY_MENU_BUTTON_HEIGHT 37.0
#define MY_MENU_BUTTON_MARGIN 7

@interface MyMenuViewController : UIViewController
{
    CGRect buttonFrame[MY_MENU_BUTTON_COUNT];
    UIButton *buttonForFrame[MY_MENU_BUTTON_COUNT];
    
    int startIndex;   // 메뉴의 애니메이션 처리를 위해 사용.
    int currentIndex;
}

@property (nonatomic, retain) NSMutableArray *myMenus;

- (NSString *)applicationDocumentsDirectory;
- (BOOL)isFileExistence:(NSString *)file;
- (void)createEditableCopyOfFileIfNeeded;
- (void)loadMyMenus;
- (void)removeMyMenuTapGesture:(UITapGestureRecognizer *)recognizer;
- (void)changeDirection:(UISwipeGestureRecognizer *)recognizer;
- (IBAction)voiceSearch:(id)sender;
- (void)createButtons;
- (void)removeButtons;
- (IBAction)buttonPressed:(id)sender;

@end
