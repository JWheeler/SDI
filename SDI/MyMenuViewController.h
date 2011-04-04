//
//  MyMenuViewController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 4..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class MyMenuView;

@interface MyMenuViewController : UIViewController 
{
    MyMenuView *scrollMyMenuView;
}

@property (nonatomic, retain) MyMenuView *scrollMyMenuView;

-(void)setMyMenu;

@end
