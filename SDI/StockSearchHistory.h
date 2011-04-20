//
//  StockSearchHistory.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 20..
//  Copyright (c) 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StockSearchHistory : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * StockCode;
@property (nonatomic, retain) NSString * StockName;

@end
