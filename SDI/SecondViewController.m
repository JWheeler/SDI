//
//  SecondViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 24..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "SecondViewController.h"
#import "DataHandler.h"
#import "TRGenerator.h"


@implementation SecondViewController

@synthesize trCode;
@synthesize price;
@synthesize volume;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(viewText:) name:TRCD_SHNNREAL object:nil];
}

- (void)viewText:(NSNotification *)notification 
{
    self.trCode.text = [[notification userInfo] objectForKey:@"TRCD"];
    self.price.text = [[notification userInfo] objectForKey:@"mktStUntyKey"];
    self.volume.text = [[notification userInfo] objectForKey:@"title"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 커스텀 메서드

// 서버 재접속.
- (IBAction)reconnect:(id)sender 
{
    [[DataHandler sharedDataHandler] reconnect];
}

// 접속 종료.
- (IBAction)close:(id)sender
{
    [[DataHandler sharedDataHandler] close];
}

// 전문 전송.
- (IBAction)sendTR:(id)sender 
{
	// 3 단계: SB 등록.
    // SB 등록 테스트.
//    NSMutableArray *sbBodies = [NSMutableArray array];
//    for (int i = 0; i < 3; i++) 
//    {
//        SBRegBody *sbRegBody = [[SBRegBody alloc] init];
//        sbRegBody.idx = @"0";
//        
//        if (i == 0) {
//            sbRegBody.code = @"000660";
//        }
//        if (i == 1) {
//            sbRegBody.code = @"003450";
//        }
//        if (i == 2) {
//            sbRegBody.code = @"005930";
//        }
//        
//        [sbBodies addObject:sbRegBody];
//    }
//    TRGenerator *tr =  [[TRGenerator alloc] init];
//    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_REGSITER andTRCode:@"SS01REAL" withCodeSet:sbBodies]];
    
    // 3 단계: SB 등록.
    // SB 등록 테스트.
    NSMutableArray *sbBodies = [NSMutableArray array];
//    for (int i = 0; i < 1; i++) 
//    {
//        SBRegBody *sbRegBody = [[SBRegBody alloc] init];
//        sbRegBody.idx = @"null";
//        
//        if (i == 0) {
//            sbRegBody.code = nil;
//        }
//        //        if (i == 1) {
//        //            sbRegBody.code = @"003450";
//        //        }
//        //        if (i == 2) {
//        //            sbRegBody.code = @"005930";
//        //        }
//        
//        [sbBodies addObject:sbRegBody];
//    }
    SBRegBody *sbRegBody = [[SBRegBody alloc] init];
    sbRegBody.idx = @"N";
    sbRegBody.code = @"";
    [sbBodies addObject:sbRegBody];
    TRGenerator *tr =  [[TRGenerator alloc] init];
    [[DataHandler sharedDataHandler] sendMessage:[tr genRegisterOrClearSB:SB_CMD_REGSITER andTRCode:TRCD_SHNNREAL withCodeSet:sbBodies]];
}

@end
