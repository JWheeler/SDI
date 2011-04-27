//
//  WebViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 27..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic, retain) IBOutlet UIWebView *web;

- (void)removeWebViewTapGesture:(UITapGestureRecognizer *)recognizer;

@end
