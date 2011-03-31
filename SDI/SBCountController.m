//
//  SBRegController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 30..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 모든 엔티티에 사용할 수 있도록 수정할 것!

#import "SBCountController.h"
#import "SDIAppDelegate.h"
#import "SBCount.h"


@implementation SBCountController

@synthesize sbCount;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)dealloc
{
    [sbCount release];
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
        
        // sbCount 리스트.
        [self fetchedResultsController];
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
        Debug(@"Total SB count: %d", [sectionInfo numberOfObjects]);
    }
    
    return self;
}

#pragma markt - CRUD

- (void)insertNewObject:(SBCount *)obj
{
    if (![self searchObject:obj]) 
    {
        // 페치 리절트 컨트롤러에 의해 관리되는 엔티티의 새 인스턴스 생성.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        // 만약 새 관리 객체에 접근이 가능하면...
        [newManagedObject setValue:obj.trCode forKey:@"trCode"];
        [newManagedObject setValue:obj.idx forKey:@"idx"];
        [newManagedObject setValue:obj.code forKey:@"code"];
        [newManagedObject setValue:obj.regCount forKey:@"regCount"];    // regCount를 1로 증가 시킴!
        // ???: newManagedObject = obj;
        //newManagedObject = obj;
        
        // 컨텍스트 저장.
        NSError *error = nil;
        if (![context save:&error])
        {
            // TODO: 에러 처리.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else
    {
        // 업데이트: regCount 증가(+1).
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:@"이미 등록된 SB 입니다."];
    }
    
}

- (void)updateObject:(SBCount *)obj
{
    
}

- (BOOL)searchObject:(SBCount *)obj
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SBCount" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entityDescription];
    // 검색 조건.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trCode == '%@') AND (idx == '%@') AND (code == '%@')", obj.trCode, obj.idx, obj.code];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trCode == 'SS01REAL'"];
	[request setPredicate:predicate];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trCode" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:@"SBCount.cache"];
	fetchedResultsController.delegate = self;
	
	NSError *error;
	BOOL success = [fetchedResultsController performFetch:&error];
	if (!success) 
    {
		// TODO: 에러 처리!
	}
    
    [request release];
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    Debug(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%d", [sectionInfo numberOfObjects]);
    if ([sectionInfo numberOfObjects] > 0) 
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)deleteObject:(SBCount *)obj 
{
    // 관리 객체 컨텍스트에서 해당 객체 삭제.
    //[self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SBCount" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 배치 사이즈 설정.
    [fetchRequest setFetchBatchSize:20];
    
    // 정렬 키.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trCode" ascending:NO];
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

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // TODO: 구현.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            // TODO: 구현.
            break;
            
        case NSFetchedResultsChangeDelete:
            // TODO: 구현.
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{    
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            // TODO: 구현.
            break;
            
        case NSFetchedResultsChangeDelete:
            // TODO: 구현.
            break;
            
        case NSFetchedResultsChangeUpdate:
            // TODO: 구현.
            break;
            
        case NSFetchedResultsChangeMove:
            // TODO: 구현.
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // TODO: 구현.
}

@end
