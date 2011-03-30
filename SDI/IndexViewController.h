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
    // 웹뷰: 자바스크립트 테스트.
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIImageView *ribbonImageView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void)registerGestureForRibbon;
- (void)closeDaily:(UISwipeGestureRecognizer *)recognizer;
- (void)viewText:(NSNotification *)notification;

@end
