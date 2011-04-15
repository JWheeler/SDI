//
//  NSArray+NestedArrays.h
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 6. 14..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (NestedArrays)

// 한 번에 중첩된 배열의 객체를 반환.
- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath;

// 서브 배열의 수 리턴.
- (NSInteger)countOfNestedArray:(NSUInteger)section;

@end
