//
//  NSDate+Timesince.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (NSDate_Timesince)

- (NSString *)timesince;
- (NSString *)timesinceWithDepth:(int)depth;

@end
