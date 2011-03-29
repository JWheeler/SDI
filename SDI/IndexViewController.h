//
//  IndexViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 25..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IndexViewController : UIViewController {
    UIImageView *ribbonImageView;
}

@property (nonatomic, retain) IBOutlet UIImageView *ribbonImageView;

- (void)registerGestureForRibbon;
- (void)closeDaily:(UISwipeGestureRecognizer *)recognizer;

@end
