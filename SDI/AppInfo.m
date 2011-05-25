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
#import "IRStockController.h"
#import "DataHandler.h"
#import "TRGenerator.h"
#import "SBCount.h"
#import "SBManager.h"
#import "TouchXML.h"
#import "User.h"


@implementation AppInfo

@synthesize user;
@synthesize stockCodeMasters;
@synthesize stockHistories;
@synthesize branchs;

static dispatch_once_t pred;
static AppInfo *sharedAppInfo = nil;

// 방식 1.
//+ (AppInfo *)sharedAppInfo 
//{
//	if(sharedAppInfo == nil) 
//    {
//        [[self alloc] init];
//    }
//    return sharedAppInfo;
//}

// 방식 2.
//+ (AppInfo *)sharedAppInfo 
//{
//	// 객체에 락을 걸고, 동시에 멀티 스레드에서 메소드에 접근하기 위해 synchronized 사용. 
//    @synchronized(self) 
//    {
//        if(sharedAppInfo == nil) 
//        {
//            [[self alloc] init];
//        }
//    }
//    return sharedAppInfo;
//}

+ (AppInfo *)sharedAppInfo 
{
    // 좀더 효율적인 방법.
    dispatch_once(&pred, ^{
        sharedAppInfo = [[self alloc] init];
    });
    
    return sharedAppInfo;
}

// 초기화.
- (id)init 
{
    self = [super init];
	if (self) 
    {
        [self loadBranchs];
        
        // 사용자 정보.
        self.user = [User sharedUser];
		self.user.loginType = nil;
		self.user.loginState = @"1";
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
	// 릴리즈되어서는 안될 객체 표시(또는 NSUIntegerMax 사용).
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

// 앱의 Documents 디렉토리.
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// 파일 존재 유무 확인.
- (BOOL)isFileExistence:(NSString *)file
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentDirectory = [self applicationDocumentsDirectory];
	NSString *writableFilePath = [documentDirectory stringByAppendingPathComponent:file];
	
	BOOL fileExits = [fileManager fileExistsAtPath:writableFilePath];
	
    return fileExits;
}

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

// 마스터 파일 읽기.
- (NSString *)readToMasterFile:(NSString *)file
{
    // Document 디렉토리.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// 데이터를 저장할 파일명 생성.
	NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, file];
    
    // 파일 읽기.
    NSString *stringFile = [NSString stringWithContentsOfFile:fileName 
                                                     encoding:NSUTF8StringEncoding 
                                                        error:nil];
    
    return stringFile;
}

// TODO: 프로보드 필터링 할 것!
// 마스터 코드 로드.
- (void)loadStockCodeMaster:(NSString *)masterName
{
    NSString *stringFile;
    
    // 매일 오전 7시에 마스터 파일 갱신된다. 
    // 그러므로 앱 실행 시 시간 확인 하여 하루에 한 번씩 마스터 파일을 다운로드 한다.
    if (![self isFileExistence:masterName] || [self isDownloadTime]) 
    {
        //START_TIMER;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:STOCK_CODE_MASTER_URL, masterName]];
        // 인코딩 확인할 것!
        stringFile = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        //END_TIMER(@"loadStockCodeMaster");
        
        [self writeToMasterFile:masterName withContent:stringFile];
        
        if (nil == stringFile) 
        {
            [LPUtils showAlert:LPAlertTypeFirst andTag:LPAlertTypeFirst withTitle:@"알림" andMessage:@"서버 접속에 실패했습니다."];
            return;
        }
    }
    else
    {
        stringFile = [self readToMasterFile:masterName];
    }
    
    //Debug(@"%@", stringFile);
    
    // 파싱.
    StockCode *stockCode = [[StockCode alloc] init];
    NSArray *headers = stockCode.headers;
    CSVParser *parser = [[CSVParser alloc] initWithString:stringFile    
                                                separator:@"|:"
                                                hasHeader:NO
                                               fieldNames:headers];
    self.stockCodeMasters = [NSArray array];
    self.stockCodeMasters = [parser arrayOfParsedRows];
//    Debug(@"%d", [stockCodeMasters count]);
//    
//    for (int i = 0; i < [stockCodeMasters count]; i++) {
//        Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %@", [[stockCodeMasters objectAtIndex:i] objectForKey:@"stockName"]);
//    }
        
}

// TODO: 좀 더 효율적인 방법으로 수정할 것!
// 다운로드 시간 확인.
-(BOOL)isDownloadTime
{
    // 현재 날짜와 시간.
	NSDate *now = [[NSDate alloc] init];
	
	// 날짜 포맷.
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	// 비교할 시간 생성.
	NSString *theDate = [dateFormat stringFromDate:now];
	NSString *theTime = @"07:10:00";
	NSString *stringDate = @"";
	stringDate = [stringDate stringByAppendingString:theDate];
	stringDate = [stringDate stringByAppendingString:@" "];
	stringDate = [stringDate stringByAppendingString:theTime];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *compareDate = [formatter dateFromString:stringDate];
	
	[now release];
	[dateFormat release];
	[formatter release];
	
	Debug(@"-----------------------------------------------------------------");
	Debug(@"compareDate: %@", stringDate);
	Debug(@"-----------------------------------------------------------------");
	
	// 시간(날짜) 비교.
	double inteval = [compareDate timeIntervalSinceNow];
	
	Debug(@"-----------------------------------------------------------------");
	Debug(@"Time inteval: %f", inteval);
	Debug(@"-----------------------------------------------------------------");
	
    // 하루에 한 번만...
	if (inteval == 0) 
    { 
		return YES;
	}
    
    return NO;
}

// IRStock 테이블에 등록된 모든 주식종목에 대한 SB등록.
- (void)regAllSB:(NSString *)idx trCode:(NSString *)trCode
{
    IRStockController *irStockController = [[IRStockController alloc] init];
    NSMutableArray *irStockList = [[NSMutableArray alloc] init];
    [irStockList addObjectsFromArray:[irStockController.fetchedResultsController fetchedObjects]];
    
    NSMutableArray *sbBodies = [NSMutableArray array];
    for (NSManagedObject *managedObject in irStockList) 
    {
        SBRegBody *sbRegBody = [[SBRegBody alloc] init];
        sbRegBody.idx = idx;
        sbRegBody.code = [managedObject valueForKey:@"stockCode"];
        
        [sbBodies addObject:sbRegBody];
        [sbRegBody release];
        
        // SBManger.
        [self saveSBManager:idx trCode:trCode stockCode:[managedObject valueForKey:@"stockCode"]];
    }
    
    TRGenerator *tr =  [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_REGSITER andTRCode:trCode withCodeSet:sbBodies]];
}

// IRStock 테이블에 신규로 입력된 주식종목에 대한 SB등록.
- (void)regSB:(NSMutableDictionary *)dict idx:(NSString *)idx trCode:(NSString *)trCode
{
    NSMutableArray *sbBodies = [NSMutableArray array];
    SBRegBody *sbRegBody = [[SBRegBody alloc] init];
    sbRegBody.idx = idx;
    sbRegBody.code = [dict objectForKey:@"stockCode"];
    [sbBodies addObject:sbRegBody];
    [sbRegBody release];
    
    TRGenerator *tr =  [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_REGSITER andTRCode:trCode withCodeSet:sbBodies]];
    
    // SBManger.
    [self saveSBManager:idx trCode:trCode stockCode:[dict objectForKey:@"stockCode"]];
}

// IRStock 테이블에서 삭제된 주식종목에 대한 SB등록. 
- (void)clearSB:(NSMutableDictionary *)dict idx:(NSString *)idx trCode:(NSString *)trCode
{
    NSMutableArray *sbBodies = [NSMutableArray array];
    SBRegBody *sbRegBody = [[SBRegBody alloc] init];
    sbRegBody.idx = idx;
    sbRegBody.code = [dict objectForKey:@"stockCode"];
    [sbBodies addObject:sbRegBody];
    [sbRegBody release];
    
    TRGenerator *tr =  [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_CLEAR andTRCode:trCode withCodeSet:sbBodies]];
    
    // SBManger.
    [self removeSBManager:idx trCode:trCode stockCode:[dict objectForKey:@"stockCode"]];
}

// SBManager에 데이터 저장.
- (void)saveSBManager:(NSString *)idx trCode:(NSString *)trCode stockCode:(NSString *)stockCode
{
    // 메모리를 사용하는 경우.
    SBCount *sbCount = [[SBCount alloc] initWithTRCode:trCode idx:idx code:stockCode];
    [[SBManager sharedSBManager] insertNewObject:sbCount];
    [sbCount release];
}

// SBManager의 데이터 삭제.
- (void)removeSBManager:(NSString *)idx trCode:(NSString *)trCode stockCode:(NSString *)stockCode
{
    // 메모리를 사용하는 경우.
    SBCount *sbCount = [[SBCount alloc] initWithTRCode:trCode idx:idx code:stockCode];
    [[SBManager sharedSBManager] deleteObject:sbCount];
    [sbCount release];
}

// 종목검색 히스토리 관리(읽기/쓰기).
- (void)manageStockHistory:(NSInteger)type
{
    if (type == Read) 
    {
        if ([self isFileExistence:@"StockHistory.plist"]) 
        {
            self.stockHistories = [self loadStockHistories:@"StockHistory.plist"];
        }
        else
        {
            self.stockHistories = [[NSMutableArray alloc] init];
        }
    }
    else if (type == Save)
    {
        // Document 디렉토리.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        // 파일명.
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"StockHistory.plist"];
        
        [self.stockHistories writeToFile:fileName atomically:NO];
    }
    else
    {
        Debug(@"Warning: check type!");
    }
}

// 종목검색 히스토리 로드.
- (NSMutableArray *)loadStockHistories:(NSString *)file
{
    // Document 디렉토리.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// 파일명 생성.
	NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, file];

	NSMutableArray *stockHistoryList = [[NSMutableArray alloc] initWithContentsOfFile:fileName];
    
	return [stockHistoryList autorelease];
}

// 종목검색 히스토리 저장.
- (void)addStockHistory:(NSDictionary *)dict
{
    int stockHistoryCnt = [self.stockHistories count];
    
    // 종목검색 히스토리는 최대 10개까지 저장함!
    if (stockHistoryCnt < 10)
    {
        // 만약 이미 등로된 종목이면, 기존 것을 삭제하고 신규 등록함!
        for (NSDictionary *oldDict in self.stockHistories) 
        {
            if ([[oldDict objectForKey:@"stockCode"] isEqualToString:[dict objectForKey:@"stockCode"]]) 
            {
                [self.stockHistories removeObject:oldDict];
            }
        }
        [self.stockHistories addObject:dict];
    }
    else
    {
        [self.stockHistories removeObjectAtIndex:0];
        [self.stockHistories addObject:dict];
    }
}

// marketCode(장구분 코드) 검색.
- (NSString *)searchMarketCode:(NSString *)stockCode
{
    NSString *retVal = nil;
    for (NSDictionary *dict in self.stockCodeMasters) 
    {
        
        if ([[dict objectForKey:@"stockCode"] isEqualToString:stockCode]) 
        {
            NSString *currentMarketCode = [dict objectForKey:@"marketCode"];
            
            if ([currentMarketCode isEqualToString:@"K"]) 
            {
                retVal = @"0";
            }
            if ([currentMarketCode isEqualToString:@"Q"]) 
            {
                retVal = @"1";
            }
            if ([currentMarketCode isEqualToString:@"T"]) 
            {
                retVal = @"2";
            }
        }
    }
    
    return retVal;
}

// 지점 데이터 로드: 큐 사용을 위해...
- (void)loadBranchs 
{
	NSOperationQueue *queue = [NSOperationQueue new];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
																			selector:@selector(grabBranchs) 
																			  object:nil];
	[queue addOperation:operation];
	[queue release];
	[operation release];
}


// 지점 데이터 로드.
- (void)grabBranchs 
{
	NSMutableArray *branchEntries = [[[NSMutableArray alloc] init] autorelease];	
    NSURL *contentsURL = [NSURL URLWithString:SERVER_URL_FOR_BRANCH];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	// 인코딩: utf-8
    //CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	// 인코딩: euc-kr
	CXMLDocument *xmlParser = [[[CXMLDocument alloc] initWithContentsOfURL:contentsURL encoding:-2147481280 options:0 error:nil] autorelease];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    NSArray *resultNodes = NULL;
    // Branch XML의 item 노드를 resultNodes에 세팅.
	resultNodes = [xmlParser nodesForXPath:@"//item" error:nil];
	
    for (CXMLElement *resultElement in resultNodes) {
		//Debug(@"%@", resultElement);
        
		// 각 item의 필드를 저장하기 위해 임시 MutableDictionary 타입의 branchgItem 생성.
		NSMutableDictionary *branchItem = [[[NSMutableDictionary alloc] init] autorelease];
		
		// 카운트 용.
		int counter;
		
		// 현재 노드 루프.
		for(counter = 0; counter < [resultElement childCount]; counter++) {
			// 키-값 형태로 데이터 저장.
			[branchItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
		}
		
		// articleItem을 articleEntries에 저장. 
		[branchEntries addObject:[branchItem copy]];
	}
	
	self.branchs = branchEntries;
}

@end
