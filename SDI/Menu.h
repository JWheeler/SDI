//
//  Menu.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Menu : NSObject 
{
    
}

@property (nonatomic, retain) NSString *groupID;
@property (nonatomic, retain) NSString *iconForAdd;
@property (nonatomic, retain) NSString *iconForMyMenu;
@property (nonatomic, retain) NSString *iconForTotal;
@property (nonatomic, retain) NSString *menuID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *target;
@property (assign) BOOL isMyMenu;

@end
