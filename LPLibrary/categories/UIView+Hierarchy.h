//
//  UIView+Hierarchy.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 5..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (Hierarchy)

- (int)getSubviewIndex;

- (void)bringToFront;
- (void)sendToBack;

- (void)bringOneLevelUp;
- (void)sendOneLevelDown;

- (BOOL)isInFront;
- (BOOL)isAtBack;

- (void)swapDepthsWithView:(UIView *)swapView;

@end
