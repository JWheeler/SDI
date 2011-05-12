//
//  IndexViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 리본 애니메이션 세부 조정.
//

#import <UIKit/UIKit.h>


@interface IndexViewController : UIViewController 
{
    
}

@property (nonatomic, retain) IBOutlet UIImageView *ribbonImageView;
@property (nonatomic, retain) IBOutlet UIImageView *beforeImageView;    // 장전.
@property (nonatomic, retain) IBOutlet UIImageView *afterImageView;     // 장중.

- (void)registerGestureForRibbon;
- (void)closeDaily:(UISwipeGestureRecognizer *)recognizer;

@end
