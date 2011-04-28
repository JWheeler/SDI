//
//  CustomHeader.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 28..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "CustomHeader.h"


@implementation CustomHeader

@synthesize imageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        selectImage = 0;
        self.imageName = @"interest_header01.png";
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.frame = frame; //CGRectMake(0.0, 0.0, 320.0, 25.0);
//        button.backgroundColor = [UIColor clearColor];
//        [button addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
//        [button release];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // 테이블뷰 헤더 이미지..
	UIImage *image = [[UIImage imageNamed:self.imageName] retain];
	[image drawInRect:rect];
	[image release];
}


- (void)dealloc
{
    [imageName release];
    [super dealloc];
}

// 헤더의 이미지 변경.
- (void)changeImage
{
    switch (selectImage) 
    {
        case 0:
        {
            self.imageName = @"interest_header01.png";
            selectImage += 1;
            break;
        }
        case 1:
        {
            self.imageName = @"interest_header02.png";
            selectImage += 1;
            break;
        }
        case 2:
        {
            self.imageName = @"interest_header03.png";
            selectImage = 0;
            break;
        } 
        default:
            break;
    }
}

@end
