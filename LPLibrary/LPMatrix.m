//
//  LPMatrix.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "LPMatrix.h"
#import "NSIndexPath+LPMatrix.h"


@implementation LPMatrix

- (id)initWithRows:(NSInteger)rows columns:(NSInteger)cols
{
    self = [super init];
    if (self)
    {
        _source = [[NSMutableDictionary alloc] initWithCapacity:rows *cols];
    }
    return self;
}

- (id)objectForRow:(NSInteger)row column:(NSInteger)col
{
    NSUInteger idxs[] = {row, col};
    NSIndexPath *path = [NSIndexPath indexPathWithIndexes:idxs length:2];
    return [_source objectForKey:path];
}

- (void)setObject:(id)object forRow:(NSInteger)row column:(NSInteger)col
{
    NSUInteger idxs[] = {row, col};
    NSIndexPath *path = [NSIndexPath indexPathWithIndexes:idxs length:2];
    [_source setObject:object forKey:path];
}

- (void)removeAllObjects
{
    [_source removeAllObjects];
}

@end
