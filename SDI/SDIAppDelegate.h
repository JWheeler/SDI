//
//  SDIAppDelegate.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 22..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentController;

@interface SDIAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ContentController *contentController;

@end
