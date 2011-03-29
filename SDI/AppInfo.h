//
//  AppInfo.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 22..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppInfo : NSObject {
    
}

@property (nonatomic, retain) NSArray *stockCodeMasters;

+ (AppInfo *)sharedAppInfo;

- (void)writeToMasterFile:(NSString *)fileName withContent:(NSString *)content;
- (void)loadStockCodeMaster;

@end
