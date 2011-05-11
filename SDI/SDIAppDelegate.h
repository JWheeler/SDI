//
//  SDIAppDelegate.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 22..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>  
#import <AudioToolbox/AudioToolbox.h>


@class Reachability;
@class ContentController;

extern SOLogger *gLogger;

@interface SDIAppDelegate : NSObject <UIApplicationDelegate> 
{
    Reachability *realServerReach;  // 중계(Real) 서버.
    Reachability *rqrpServerReach;  // RQ/RP 서버.
    Reachability *internetReach;    // 인터넷.
    Reachability *wifiReach;        // 로컬 WiFi.
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ContentController *contentController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSString *)applicationDocumentsDirectoryForString;
- (void)createEditableCopyOfDatabaseIfNeeded;

- (void)isConnect;
- (void)updateInterfaceWithReachability:(Reachability *)curReach;
- (BOOL)isConnectToNetwork;
- (void)initProcessWithReachability:(Reachability *)curReach;
- (void)initProcess;
- (void)exitProcess;
- (NSDictionary *)parseQueryString:(NSString *)query;
- (void)removeWebView:(UIView *)theView;

@end
