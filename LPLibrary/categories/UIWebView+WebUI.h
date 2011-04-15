//
//  UIWebView+JavaScriptAlert.h
//  YFPortal
//
//  Created by Jong Pil Park on 11. 1. 21..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIWebView (WebUI)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message  initiatedByFrame:(CGRect *)frame;
//- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;

@end
