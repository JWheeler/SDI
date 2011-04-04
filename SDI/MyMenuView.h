//
//  MyMenuView.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyMenuView : UIView <UIScrollViewDelegate> 
{
    UIScrollView *menuScrollView;
	NSMutableArray *menuButtons;
}

@property (nonatomic, retain) UIScrollView *menuScrollView;
@property (nonatomic, retain) NSMutableArray *menuButtons;

- (id)initWithFrameAndButtons:(CGRect)frame buttons:(NSMutableArray *)buttonArray;

@end
