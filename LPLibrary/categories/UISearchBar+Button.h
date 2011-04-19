//
//  UISearchBar+Button.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 19..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UISearchBar (Button)

- (void)setCloseButtonTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state forView:(UIView *)view;

@end
