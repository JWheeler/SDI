//
//  IRGroup.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 8..
//  Copyright (c) 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IRGroup : NSManagedObject {
@private
}

@property (nonatomic, retain) NSNumber * idx;
@property (nonatomic, retain) NSString * groupName;

@end
