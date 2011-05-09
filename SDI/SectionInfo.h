//
//  SectionInfo.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SectionHeaderView;
@class MenuGroup;

@interface SectionInfo : NSObject 
{
    
}

@property (assign) BOOL open;
@property (retain) MenuGroup *menuGroup;
@property (retain) SectionHeaderView *headerView;

@property (nonatomic,retain,readonly) NSMutableArray *rowHeights;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)getRowHeights:(id *)buffer range:(NSRange)inRange;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end
