//
//  Index.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Index : NSObject 
{
    
}

@property (nonatomic, retain) NSString *index;              // 지수.
@property (nonatomic, retain) NSString *fluctuation;        // 등락.
@property (nonatomic, retain) NSString *fluctuationRate;    // 등락비율.
@property (assign) BOOL isFluctuationRate;                  // 등락비율 사용 여부.

- (NSString *)calcFluctionRate;
- (NSString *)changeFormat:(NSString *)unfromatted;

@end
