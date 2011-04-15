//
//  NSArray+NestedArrays.m
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 6. 14..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import "NSArray+NestedArrays.h"


@implementation NSArray (NestedArrays)

- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	NSArray *subArray = [self objectAtIndex:section];
	
	if (![subArray isKindOfClass:[NSArray class]])
		return nil;
	
	if (row >= [subArray count])
		return nil;
	
	return [subArray objectAtIndex:row];
}

- (NSInteger)countOfNestedArray:(NSUInteger)section {
	NSArray *subArray = [self objectAtIndex:section];
	return [subArray count];
}

@end
