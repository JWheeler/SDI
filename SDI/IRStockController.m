//
//  IRStrockController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 14..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "IRStockController.h"
#import "SDIAppDelegate.h"


@implementation IRStockController

@synthesize irStock;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)dealloc
{
    [irStock release];
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        // 관리 객체 컨텍스트 설정.
        SDIAppDelegate *appDelegate = (SDIAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        
        // irStock 리스트.
        [self fetchedResultsController];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
        Debug(@"Total SB count: %d", [sectionInfo numberOfObjects]);
    }
    
    return self;
}

#pragma mark - Fetched results controller

// 페치 리절트 컨트롤러.
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    // 엔티티를 위한 페치 리절트 컨트롤러 생성.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // 엔티티 이름.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IRStock" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 배치 사이즈 설정.
    [fetchRequest setFetchBatchSize:50];
    
    // 정렬 키.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // 섹션 이름 체크: nil = 섹션 없슴.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    // TODO: 에러 처리.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
} 

@end
