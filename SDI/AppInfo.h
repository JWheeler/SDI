//
//  AppInfo.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 22..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

// 종목검색 히스토리.
enum 
{
    Read = 0,
    Save = 1
};

@interface AppInfo : NSObject 
{

}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSArray *stockCodeMasters;
@property (nonatomic, retain) NSMutableArray *stockHistories;
@property (nonatomic, retain) NSMutableArray *branchs;

+ (AppInfo *)sharedAppInfo;

- (NSString *)applicationDocumentsDirectory;
- (BOOL)isFileExistence:(NSString *)file;
- (void)writeToMasterFile:(NSString *)fileName withContent:(NSString *)content;
- (NSString *)readToMasterFile:(NSString *)file;
- (void)loadStockCodeMaster:(NSString *)masterName;
- (BOOL)isDownloadTime;
- (void)regAllSB:(NSString *)idx trCode:(NSString *)trCode;
- (void)regSB:(NSMutableDictionary *)dict idx:(NSString *)idx trCode:(NSString *)trCode;
- (void)clearSB:(NSMutableDictionary *)dict idx:(NSString *)idx trCode:(NSString *)trCode;
- (void)saveSBManager:(NSString *)idx trCode:(NSString *)trCode stockCode:(NSString *)stockCode;
- (void)removeSBManager:(NSString *)idx trCode:(NSString *)trCode stockCode:(NSString *)stockCode;
- (void)manageStockHistory:(NSInteger)type;
- (NSMutableArray *)loadStockHistories:(NSString *)file;
- (void)addStockHistory:(NSDictionary *)dict;
- (NSString *)searchMarketCode:(NSString *)stockCode;
- (void)loadBranchs;
- (void)grabBranchs;

@end
