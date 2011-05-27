//
//  WebViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 27..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *trCd;
@property (nonatomic, retain) NSString *stockCode;
@property (nonatomic, retain) NSString *jsFunction;

- (NSDictionary *)parseQueryString:(NSString *)querylj;
- (void)runJavaScriptForRqRp:(NSNotification *)notification;
- (void)configNotification:(NSNotification *)notification;
- (void)runJavaScriptForReal:(NSNotification *)notification;
- (void)runJavaScriptForHistory:(NSNotification *)notification;
- (void)runJavaScriptForLogin:(NSNotification *)notification;
- (void)addNaviButton:(NSNotification *)notification;
- (void)removeWebViewTapGesture:(UITapGestureRecognizer *)recognizer;
- (IBAction)backAction:(id)sender;
- (void)refresh:(id)sender;
- (void)openPopup:(id)sender;
- (void)goToPage:(id)sender;

@end
