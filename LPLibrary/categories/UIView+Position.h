//
//  UIView+Position.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 5..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  UIView의 위치를 설정하기 위한 카테고리이다.
//  UIView의 autoresizingMask 설정에 주의하라.
//  
//  [사용법]
//  myView.frameX += 10;  // 오른쪽으로 10 포인트 이동.
//  [myView addCenteredSubview:aSubView];


#import <Foundation/Foundation.h>


@interface UIView (Position)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// 원점(origin) 설정.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

// 센터를 위한 메서드들.
- (void)addCenteredSubview:(UIView *)subview;
- (void)moveToCenterOfSuperview;
- (void)centerVerticallyInSuperview;
- (void)centerHorizontallyInSuperview;

@end
