//
//  WebViewController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 27..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [web release];
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
    
    // 이전화면 버튼.
    UIButton *backButton = [UIButton buttonWithType:101];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"이전화면" forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    // UITapGestureRecognizer 인스턴스 생성.
    UITapGestureRecognizer *recognizerTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeWebViewTapGesture:)] autorelease];
    recognizerTap.numberOfTapsRequired = 1;
    recognizerTap.delegate = self;
    [self.web addGestureRecognizer:recognizerTap];
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.200.2.47/common/html/list.html"]]];
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

- (void)removeWebViewTapGesture:(UITapGestureRecognizer *)recognizer
{
    // TODO: 애니메이션 효과 결정할 것!
    [self.web removeFromSuperview];
}

// 백버튼 액션.
- (IBAction)backAction:(id)sender
{
    Debug(@"Back button tapped!");
    [self.navigationController.view removeFromSuperview];
}

@end
