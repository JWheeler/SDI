//
//  IRStock.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 11..
//  Copyright (c) 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IRGroup;

@interface IRStock : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * idx;
@property (nonatomic, retain) NSString * stockName;
@property (nonatomic, retain) NSString * stockCode;
@property (nonatomic, retain) IRGroup * group;

@end
