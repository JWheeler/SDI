//
//  MenuGroup.h
//  YFPortal
//
//  Created by Jong Pil Park on 10. 10. 11..
//  Copyright 2010 YouFirst. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuGroup : NSObject 
{
}

@property (nonatomic, retain) NSString *groupID;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *target;
@property (nonatomic, retain) NSString *titleIcon;
@property (nonatomic, retain) NSString *headerIcon;
@property (nonatomic, retain) NSArray *subMenus;

@end
