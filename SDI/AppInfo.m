//
//  AppInfo.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 22..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "AppInfo.h"
#import "CSVParser.h"
#import "SDIConstants.h"
#import "StockCode.h"


@implementation AppInfo

@synthesize stockCodeMasters;

static AppInfo *sharedAppInfo = nil;

+ (AppInfo *)sharedAppInfo 
{
	// 객체에 락을 걸고, 동시에 멀티 스레드에서 메소드에 접근하기 위해 synchronized 사용. 
	@synchronized(self) 
    {
		if(sharedAppInfo == nil) 
        {
			[[self alloc] init];
		}
	}
	return sharedAppInfo;
}

// 초기화.
- (id)init 
{
    self = [super init];
	if (self) 
    {

	}
	
	return self;
}

// 객체 할당(alloc) 시 호출됨.
// 객체 할당과 초기화 시 sharedAppInfo 인스턴스가 nil인지 확인.
+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
    {
        if (sharedAppInfo == nil) 
        {
            sharedAppInfo = [super allocWithZone:zone];
            return sharedAppInfo;
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

// 마스터 파일 저장.
- (void)writeToMasterFile:(NSString *)file withContent:(NSString *)content 
{
	// Document 디렉토리.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// 데이터를 저장할 파일명 생성.
	NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, file];
    
	// Document 디렉토리에 저장.
	[content writeToFile:fileName 
			  atomically:NO 
				encoding:NSUTF8StringEncoding 
				   error:nil];
}

// TODO: 종목코드를 파일 또는 DB에 저장해야함!
- (void)loadStockCodeMaster:(NSString *)masterName
{
    START_TIMER;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:STOCK_CODE_MASTER_URL, masterName]];
    // 인코딩 확인할 것!
    NSString *stringFile = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    END_TIMER(@"loadStockCodeMaster");
    
    //[self writeToMasterFile:STOCK_CODE_MASTER_FILE_NAME withContent:stringFile];
    //Debug(@"%@", stringFile);
    
    // TODO: 예외처리!
    // 얼럿.
    
    if (nil == stringFile) 
    {
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:@"서버 접속에 실패했습니다."];
        return;
    }
        
    // 파싱.
    StockCode *stockCode = [[StockCode alloc] init];
    NSArray *headers = stockCode.headers;
    CSVParser *parser = [[CSVParser alloc] initWithString:stringFile    
                                                separator:@"|:"
                                                hasHeader:NO
                                               fieldNames:headers];
    stockCodeMasters = [NSArray array];
    stockCodeMasters = [parser arrayOfParsedRows];
    Debug(@"%d", [stockCodeMasters count]);
    
//    for (NSArray *arr in stockCodeMasters) {
//        Debug(@"%@", arr);
//    }
    
}

@end
