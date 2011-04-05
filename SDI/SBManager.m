//
//  SBManager.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 5..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 싱글톤 클래스(현재...)를 사용할 지 세미 싱클톤 클래스를 사용할 지 결정!
//

#import "SBManager.h"
#import "SBCount.h"


@implementation SBManager

@synthesize sbTable;
@synthesize currentObject;
@synthesize updateObject;

static SBManager *sharedSBManager = nil;

+ (SBManager *)sharedSBManager 
{
	// 객체에 락을 걸고, 동시에 멀티 스레드에서 메소드에 접근하기 위해 synchronized 사용. 
	@synchronized(self) {
		if(sharedSBManager == nil) 
        {
			[[self alloc] init];
		}
	}
	return sharedSBManager;
}

// 초기화.
- (id)init 
{
	if ((self = [super init])) 
    {
        self.sbTable = [[NSMutableArray alloc] init];
	}
	
	return self;
}

// 객체 할당(alloc) 시 호출됨.
// 객체 할당과 초기화 시 sharedAppInfo 인스턴스가 nil인지 확인.
+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
    {
        if (sharedSBManager == nil) 
        {
            sharedSBManager = [super allocWithZone:zone];
            return sharedSBManager;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
	// 릴리즈되어서는 안될 객체 표시.
    return UINT_MAX;  
} 

- (void)release 
{
    // 아무일도 안함.
}

- (id)autorelease 
{
    return self;
}

#pragma mark - 커스텀 메서드

// 추가.
- (void)insertNewObject:(SBCount *)obj
{
    if (![self isObjectExistence:obj]) 
    {
        [self.sbTable addObject:obj];
    }
    else
    {
        [self updateObject:obj withType:RegCountIncrease];
    }
}

// 수정.
- (void)updateObject:(SBCount *)obj withType:(int)type
{
    if (type == RegCountIncrease) 
    {
        // regCount +1 증가.
        self.currentObject = [self searchObjet:obj];
        NSInteger currentIndex = [self.sbTable indexOfObject:self.currentObject];
        [self.currentObject increaseRegCount];
        [self.sbTable replaceObjectAtIndex:currentIndex withObject:self.currentObject];
    }
    else
    {
        // regCount -1 감소.
        self.currentObject = [self searchObjet:obj];
        NSInteger currentIndex = [self.sbTable indexOfObject:self.currentObject];
        [self.currentObject decreaseRegCount];
        [self.sbTable replaceObjectAtIndex:currentIndex withObject:self.currentObject];
    }
    
}

// 삭제: regCount의 값을 -1 감소 시킨다..
- (void)deleteObject:(SBCount *)obj
{
    [self updateObject:obj withType:RegCountDecrease];
}

// 검색.
- (SBCount *)searchObjet:(SBCount *)obj
{
    if ([self.sbTable count] > 0) 
    {
        for (SBCount *sbCount in self.sbTable) 
        {
            if ([sbCount.trCode isEqualToString:obj.trCode] &&
                [sbCount.idx isEqualToString:obj.idx] &&
                [sbCount.code isEqualToString:obj.code]) 
            {
                return sbCount;
            }
            else
            {
                return nil;
            }
        }
    }
    else
    {
        return nil;
    }
}

// 확인.
- (SBCount *)isObjectExistence:(SBCount *)obj
{
    if ([self.sbTable count] > 0) 
    {
        for (SBCount *sbCount in self.sbTable) 
        {
            if ([sbCount.trCode isEqualToString:obj.trCode] &&
                [sbCount.idx isEqualToString:obj.idx] &&
                [sbCount.code isEqualToString:obj.code]) 
            {
                return sbCount;
            }
            else
            {
                return nil;
            }
        }
    }
    else
    {
        return nil;
    }
}

@end
