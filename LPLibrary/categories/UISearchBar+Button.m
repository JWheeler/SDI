//
//  UISearchBar+Button.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 19..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "UISearchBar+Button.h"


@implementation UISearchBar (Button)

- (void)setCloseButtonTitle:(NSString *)title forState:(UIControlState)state
{
    [self setTitle: title forState: state forView:self];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state forView:(UIView *)view
{
    UIButton *cancelButton = nil;
    for(UIView *subView in view.subviews){
        if([subView isKindOfClass:UIButton.class])
        {
            cancelButton = (UIButton*)subView;
        }
        else
        {
            [self setTitle:title forState:state forView:subView];
        }
    }
    
    if (cancelButton)
        [cancelButton setTitle:title forState:state];
}

@end
