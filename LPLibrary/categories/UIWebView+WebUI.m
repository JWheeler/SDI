//
//  UIWebView+JavaScriptAlert.m
//  YFPortal
//
//  Created by Jong Pil Park on 11. 1. 21..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "UIWebView+WebUI.h"


@implementation UIWebView (WebUI)

// 얼럿뷰 수정: 자바스크립트로 alert를 사용한 경우.
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message  initiatedByFrame:(CGRect *)frame {
	Debug(@"Javascript alert : %@", message);
	
    UIAlertView *jsAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [jsAlert show];
    [jsAlert autorelease];
}


// 얼럿뷰 수정: 자바스크립트로 confirm을 사용한 경우.
//- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame {
//	Debug(@"Javascript alert : %@", message);
//	
//    UIAlertView *jsAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//    [jsAlert show];
//    [jsAlert autorelease];
//	
//	// TODO: 리턴값 확인 방법 처리해야 함!
//	return YES;
//}

@end
