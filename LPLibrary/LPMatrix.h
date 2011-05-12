//
//  LPMatrix.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 12..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPMatrix : NSObject 
{
    @private
    NSMutableDictionary *_source;
}

- (id)initWithRows:(NSInteger)rows columns:(NSInteger)cols;
- (id)objectForRow:(NSInteger)row column:(NSInteger)col;
- (void)setObject:(id)object forRow:(NSInteger)row column:(NSInteger)col;
- (void)removeAllObjects;

@end
