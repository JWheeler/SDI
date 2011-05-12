//
//  NSIndexPath+LPMatrix.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "NSIndexPath+LPMatrix.h"


@implementation NSIndexPath (NSIndexPath_LPMatrix)

+ (NSIndexPath *)indexPathWithRow:(NSUInteger)row column:(NSUInteger)col
{
    NSUInteger indexes[] = {row, col};
    return [NSIndexPath indexPathWithIndexes:indexes length:2];
}


@end
