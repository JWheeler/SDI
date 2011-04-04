//
//  SDIContentController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentController.h"
#import "LPPageControl.h"


@interface SDIContentController : ContentController <UIScrollViewDelegate> 
{   
    UIScrollView *scrollView;
	LPPageControl *pageControl;
    UIImageView *ribbonImageView;
    
    NSMutableArray *viewControllers;
    
    // UIPageControl로 부터 originate로 스크롤할 때 사용.
    BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIImageView *ribbonImageView;

@property (nonatomic, retain) NSMutableArray *viewControllers;

- (IBAction)changePage:(id)sender;
- (void)registerGestureForRibbon;
- (void)openDaily:(UISwipeGestureRecognizer *)recognizer;
- (IBAction)openMyMenu:(id)sender;

@end
