//
//  SBManager.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 5..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  !!!: SB 등록 관리를 메모리에서 할 경우.
//

#import <Foundation/Foundation.h>

@class SBCount;

enum 
{
    RegCountIncrease = 0,
    RegCountDecrease = 1
};


@interface SBManager : NSObject 
{
    NSMutableArray *sbTable;
    SBCount *currentObject;
}

@property (nonatomic, retain) NSMutableArray *sbTable;
@property (nonatomic, retain) SBCount *currentObject;

+ (SBManager *)sharedSBManager;

- (void)insertNewObject:(SBCount *)obj;
- (void)updateObject:(SBCount *)obj withType:(int)type;
- (void)deleteObject:(SBCount *)obj;
- (SBCount *)searchObjet:(SBCount *)obj;
- (SBCount *)isObjectExistence:(SBCount *)obj;

@end
