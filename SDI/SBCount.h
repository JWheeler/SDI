//
//  SBRegCount.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 30..
//  Copyright (c) 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SBCount : NSObject 
{ 
    
}

@property (nonatomic, retain) NSString *trCode;
@property (nonatomic, retain) NSString *idx;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSNumber *regCount;

- (id)initWithTRCode:(NSString *)trCode idx:(NSString *)idx code:(NSString *)code;
- (void)increaseRegCount;
- (void)decreaseRegCount;
- (void)clearSB;
- (void)debugRegCount;

@end
