//
//  ContentController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContentController : UIViewController //NSObject 
{
    NSArray *contentList;
}

@property (nonatomic, retain) NSArray *contentList;

- (UIView *)view;

@end
