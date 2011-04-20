//
//  MenuGroup.h
//  YFPortal
//
//  Created by Jong Pil Park on 10. 10. 11..
//  Copyright 2010 YouFirst. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuGroup : NSObject {
	NSString *menuID;
	NSString *name;
	NSString *icon;
	NSString *isUse;
	NSString *target;
	NSString *loginType;
}

@property (nonatomic, retain) NSString *menuID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *isUse;
@property (nonatomic, retain) NSString *target;
@property (nonatomic, retain) NSString *loginType;

@end
