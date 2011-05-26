//
//  SDIAppDelegate.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 22..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 초기화 프로세스 플로우 정리할 것!
//

#import "SDIAppDelegate.h"
#import "Reachability.h"
#import "ContentController.h"
#import "SBCountController.h"
#import "DataHandler.h"
#import "HTTPHandler.h"
#import "SBManager.h"

SOLogger *gLogger;


@implementation SDIAppDelegate

@synthesize window = _window;
@synthesize contentController = _contentController;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

#pragma mark Custom URL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    // URL이 nil인 경우.
	if (!url) { return NO; }
	
    Debug(@"url recieved: %@", url);
    Debug(@"query string: %@", [url query]);
    Debug(@"host: %@", [url host]);
    Debug(@"url path: %@", [url path]);
    NSDictionary *dict = [self parseQueryString:[url query]];
    Debug(@"query dict: %@", dict);
    
    // TODO: 로그인 프로세스 먼저 구현할 것!
    // 웹뷰에서 로그인을 호출했을 경우.
	if ([[url host] isEqualToString:@"login"]) 
    {
//        [self removeWebView:self.contentController.view.superview];
//        
//        [AppInfo sharedAppInfo].user.loginType = [dict objectForKey:@"loginType"];
//		[AppInfo sharedAppInfo].targetURL = [dict objectForKey:@"target"];
//        
//		// 로그인 여부에 따른 분기.
//		if ([[[AppInfo sharedAppInfo] user] isLogin]) 
//        {
//			
//		}
//		else 
//        {
//			
//		}
	}
	
	// 웹뷰에서 홈을 호출했을 경우.
	if ([[url host] isEqualToString:@"home"]) 
    {
        [self removeWebView:self.contentController.view.superview];
	}
    
    // 웹뷰에서 지점안내를 호출했을 경우.
	if ([[url host] isEqualToString:@"branch"]) 
    {
        [self removeWebView:self.contentController.view.superview];
	}
    
    // 웹뷰에서 관심종목을 호출했을 경우.
	if ([[url host] isEqualToString:@"irStock"]) 
    {
        [self removeWebView:self.contentController.view.superview];
	}
    
    // 웹뷰에서 종목검색을 호출했을 경우.
	if ([[url host] isEqualToString:@"searchStock"]) 
    {
        [self removeWebView:self.contentController.view.superview];
	}
    
    // 웹뷰에서 종목검색 히스토리를 요청했을 경우.
	if ([[url host] isEqualToString:@"history"]) 
    {
        
	}
    
    // 웹뷰에서 실시간 데이터를 요청했을 경우.
	if ([[url host] isEqualToString:@"real"]) 
    {
        NSString *trCode = [dict objectForKey:@"trCode"];
        NSString *stockCode = [dict objectForKey:@"stockCode"];
        NSString *marketCode = [dict objectForKey:@"marketCode"];
        NSString *jsName = [dict objectForKey:@"jsName"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:stockCode forKey:@"stockCode"];
        
        // SB 등록 메시지 전송.
        [[AppInfo sharedAppInfo] regSB:dict idx:marketCode trCode:trCode];
        
        NSMutableDictionary *realDict = [[NSMutableDictionary alloc] init];
        [realDict setObject:trCode forKey:@"trCode"];
        [realDict setObject:stockCode forKey:@"stockCode"];
        [realDict setObject:jsName forKey:@"jsName"];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"Real" object:self userInfo:realDict];
        
        [realDict release];
	}
    
    // 웹뷰에서 RQ/RP 데이터를 요청했을 경우.
	if ([[url host] isEqualToString:@"rq"]) 
    {
        int isEncrypt = [[dict objectForKey:@"isEncrypt"] intValue];
        NSString *trCode = [dict objectForKey:@"trCode"];
        NSString *queryString = [dict objectForKey:@"queryString"];
        NSString *jsName = [dict objectForKey:@"jsName"];

        HTTPHandler *httpHandler = [[HTTPHandler alloc] init];
        
        if (isEncrypt == 0) 
        {
            // 암호화.
            NSString *query = [NSString stringWithFormat:@"HDSTR_SRC=trcode/%@%@", trCode, queryString];
            [httpHandler reqEncryptForWeb:query];
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"%@%@", trCode, queryString];
            [httpHandler reqForWeb:query];
        }
        
        if (httpHandler.reponse != nil) 
        {
            NSMutableDictionary *rpDict = [[NSMutableDictionary alloc] init];
            [rpDict setObject:trCode forKey:@"trCode"];
            [rpDict setObject:jsName forKey:@"jsName"];
            [rpDict setObject:httpHandler.reponse forKey:@"data"];
            
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"RqRp" object:self userInfo:rpDict];
            
            [rpDict release];
        }
        [httpHandler release];
	}
    
    // 웹뷰에서 addHistory 등록을 요청했을 경우.
	if ([[url host] isEqualToString:@"addHistory"]) 
    {
        
	}
    
    return YES;
}

#pragma mark Application lifecycle

+ (void)initialize
{
    gLogger = [[SOLogger alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // 로그.
    gLogger = [[SOLogger alloc] init];
    
    // DB 복사: 미리 입력된 데이터를 위해...
    [self createEditableCopyOfDatabaseIfNeeded];
    
    // 네트워크 상태 확인.
    [self isConnect];
    
    // APNS 등록.
	[[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
	// 앱 런칭 시 뱃지 지우기.
	application.applicationIconBadgeNumber = 0;
    
    
    NSString *nibTitle = @"SDIContent";
    [[NSBundle mainBundle] loadNibNamed:nibTitle owner:self options:nil];

    [self.window addSubview:self.contentController.view];
    [self.window makeKeyAndVisible];
    
    // ----------------------------------------------
    // !!!: 앱스토어에 등록할 때 삭제할 것!
    // ----------------------------------------------
//    [self performSelector:@selector(printViewHierarchy)
//               withObject:nil
//               afterDelay:2.0 /* 뷰가 세팅될 시간 확보 */ ];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [self exitProcess];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    // TODO: SB 등록 프로세스 추가.
    
    // SB 최초 접속 등록.
    TRGenerator *tr = [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genInitOrFinishSB:TRCD_MAINSTRT andCMD:SB_CMD_INIT_OR_FINISH]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    NSError *error = nil;
    if (__managedObjectContext != nil) 
    {
        if ([__managedObjectContext hasChanges] && ![__managedObjectContext save:&error]) 
        {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
    
    // 앱 종료 프로세스.
    [self exitProcess];
}

- (void)dealloc
{
    [_window release];
    [_contentController release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SDI" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SDI.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    // 마이그레이션을 위한 설정.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectoryForString  
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
	// DB가 존재하는 지 확인.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentDirectory = [self applicationDocumentsDirectoryForString];
	NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"SDI.sqlite"];
	
	BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
	if (!dbexits) 
    {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SDI.sqlite"];
		
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) 
        {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
}

#pragma mark - APNS

/**
 * Fetch and Format Device Token and Register Important Information to Remote Server
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{
#if !TARGET_IPHONE_SIMULATOR
    
    // 원격 등록용 번들 정보.
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
    // 노티피케이션 설정 확인.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	
    // 기본값 설정.
	NSString *pushBadge = @"disabled";
	NSString *pushAlert = @"disabled";
	NSString *pushSound = @"disabled";
	
	if (rntypes == UIRemoteNotificationTypeBadge)
    {
		pushBadge = @"enabled";
	}
	else if (rntypes == UIRemoteNotificationTypeAlert)
    {
		pushAlert = @"enabled";
	}
	else if (rntypes == UIRemoteNotificationTypeSound)
    {
		pushSound = @"enabled";
	}
	else if (rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert))
    {
		pushBadge = @"enabled";
		pushAlert = @"enabled";
	}
	else if (rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound))
    {
		pushBadge = @"enabled";
		pushSound = @"enabled";
	}
	else if (rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
    {
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	else if (rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound))
    {
		pushBadge = @"enabled";
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	
	// 디바이스: Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
	
	// 프로바이더에 등록할 디바이스 토큰 ('스페이스'와 '< >'는 제거)
	NSString *deviceToken = [[[[devToken description] 
                               stringByReplacingOccurrencesOfString:@"<"withString:@""] 
                              stringByReplacingOccurrencesOfString:@">" withString:@""] 
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	// 프로바이더 URL.
	// !!! 'http://'는 사용하지 않는다.
	// !!! 예: "apns.youfirst.co.kr"
	NSString *host = APNS_PROVIDER_URL;
	
	// !!! (반드시 '/"로 시작하여 '?' 끝이 되어야 한다). 
	// !!! 예: "/path/to/apns.php?"
	NSString *urlString = [NSString stringWithFormat:@"/apns.php?task=%@&appname=%@&appversion=%@&deviceuid=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@", @"register", appName,appVersion, deviceUuid, deviceToken, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound];
	
	// 프로바이더에 디바이스 정보 등록
	NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"Register URL: %@", url);
	NSLog(@"Return Data: %@", [NSString stringWithUTF8String:[returnData bytes]]);
	
#endif
}

// 원격 노티피케이션 등록을 실해할 경우.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
#if !TARGET_IPHONE_SIMULATOR
	
	NSLog(@"Error in registration. Error: %@", error);
	
#endif
}

// 앱이 실행되는 동안 원격 노티피케이션을 수신할 경우.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
	
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
	
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
	application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
	
#endif
}

#pragma mark - 커스텀 메서드.

- (void)printViewHierarchy 
{
    // ----------------------------------------------
    // 1. 워닝은 무시할 것. 
    // 2. 앱스토어에 등록할 때 삭제할 것!
    // ----------------------------------------------
    //Debug(@"%@", [self.window recursiveDescription]);
}

// 중계 서버와 RQ/RP 서버 접속 여부.
- (void)isConnect
{
    // kNetworkReachabilityChangedNotification 옵저버.
    // 노티피케이션이 포스트되면 "reachabilityChanged" 메서드가 호출됨. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    
    // ???: Node.js 서버 접속 확인은 어떻게? > 현재는 WebSocket에서 처리함.
    // 모니터링 할 서버.
	realServerReach = [[Reachability reachabilityWithHostName:RQ_RP_SERVER_URL] retain];
	[realServerReach startNotifier];
	[self updateInterfaceWithReachability:realServerReach];
    
    rqrpServerReach = [[Reachability reachabilityWithHostName:RQ_RP_SERVER_URL] retain];
	[rqrpServerReach startNotifier];
	[self updateInterfaceWithReachability:rqrpServerReach];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability:internetReach];
    
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
	[self updateInterfaceWithReachability:wifiReach];
}

// 네트워크 접속 상태가 변경되면 Reachability에 의해 호출됨.
- (void)reachabilityChanged:(NSNotification *)note
{
	Reachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

// 네트워크 접속 상태에 따른 처리.
- (void)updateInterfaceWithReachability:(Reachability *)curReach
{
    if (curReach == rqrpServerReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired = [curReach connectionRequired];
        NSString *statusString =  @"";
        if (connectionRequired)
        {
            statusString = @"네트워크에 연결되어 있지 않습니다.\n 네트워크 접속 상태를 확인해 주십시오!";
            [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:statusString];
        }
        else
        {
            [self initProcessWithReachability:curReach];
        }
    }
	if (curReach == internetReach)
	{	
		[self initProcessWithReachability:curReach];
	}
	if (curReach == wifiReach)
	{	
		[self initProcessWithReachability:curReach];
	}
}

// TODO: 중계서버 접속 여부 로직 추가.
- (BOOL)isConnectToNetwork 
{
    // 0.0.0.0 주소를 만든다.
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Reachability 플래그를 설정한다.
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
	// 플래그를 이용하여 각각의 네트워크 커넥션의 상태를 체크한다.
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	return ((isReachable && !needsConnection) || nonWiFi) ? YES : NO;
}

// 통신 등 서비스 초기화.
- (void)initProcessWithReachability:(Reachability *)curReach
{
    // !!!: 네트워크 상태별 로직 추가 전, 임시 처리용...
    if (curReach != rqrpServerReach) return;
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
    NSString *statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"네트워크에 연결되어 있지 않습니다.\n 네트워크 접속 상태를 확인해 주십시오!";
            [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:statusString];
            connectionRequired = NO;  
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"현재 3G에 연결되어 있습니다. \n 리얼 시세 사용 시 통신 요금이 부과되오니 유의해 주시기 바랍니다!";
            [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:statusString];
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            
            break;
        }
    }
    
    if (connectionRequired)
    {
        statusString = [NSString stringWithFormat:@"%@, 연결이 필요합니다!", statusString];
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:statusString];
    }
    else
    {
        [self initProcess];
    }
}

// 앱 런칭 시 처리할 것들.
- (void)initProcess
{
    // 앱 정보.
    [AppInfo sharedAppInfo];
    
    // 마스터 코드 로드.
    [[AppInfo sharedAppInfo] loadStockCodeMaster:JONGMOK_MASTER];
    
    // 데이터핸들러.
    [DataHandler sharedDataHandler];
    
    // SB 등록 관리.
    [SBManager sharedSBManager];
    
    // 종목검색 히스토리 읽기.
    [[AppInfo sharedAppInfo] manageStockHistory:Read];
}

// 앱 종료 시 처리할 것들.
- (void)exitProcess
{
    // SB 접속 종료.
    TRGenerator *tr = [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genInitOrFinishSB:TRCD_MAINEXIT andCMD:SB_CMD_INIT_OR_FINISH]];
    
    // SB 등록 테이블 초기화.
    [SBManager sharedSBManager].sbTable = nil;
    
    // 종목검색 히스토리 저장.
    [[AppInfo sharedAppInfo] manageStockHistory:Save];
}

// URL 파싱.
- (NSDictionary *)parseQueryString:(NSString *)query 
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:8] autorelease];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
	
	for (NSString *pair in pairs) 
    {
		NSArray *elements = [pair componentsSeparatedByString:@"="];
		NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *val;
		
		// val 이 nil인 경우 예외 처리!
		if (val != nil) 
        {
			if ([key isEqualToString:@"target"]) 
            {
				// !!!: target의 경우 URL 디코딩 안함.
				val = [elements objectAtIndex:1];
			}
			else 
            {
				val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			}
		}
        else 
        {
			val = @"";
		}
		
		[dict setObject:val forKey:key];
	}
    
    return dict;
}

// 화면에서 웹뷰 제거.
- (void)removeWebView:(UIView *)theView
{
	for (UIView *view in theView.subviews) 
    {
		if ([view isKindOfClass:[UIWebView class]]) 
        {
            [view.superview removeFromSuperview];
		}
        else
        {
            [self removeWebView:view];
        }
	}
}

@end
