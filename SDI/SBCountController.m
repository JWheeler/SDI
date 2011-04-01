//
//  SBRegController.m
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 30..
//  Copyright 2011 Lilac Studio. All rights reserved.
//
//  TODO: 모든 엔티티에 사용할 수 있도록 수정할 것!
//

#import "SBCountController.h"
#import "SDIAppDelegate.h"
#import "SBCount.h"


@implementation SBCountController

@synthesize sbCount;
@synthesize updateObject;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)dealloc
{
    [sbCount release];
    [updateObject release];
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

// 삽입.
- (void)insertNewObject:(SBCount *)obj
{
    if (![self isObjectExistence:obj]) 
    {
        // 페치 리절트 컨트롤러에 의해 관리되는 엔티티의 새 인스턴스 생성.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        // 새 관리 객체 설정.
        [newManagedObject setValue:obj.trCode forKey:@"trCode"];
        [newManagedObject setValue:obj.idx forKey:@"idx"];
        [newManagedObject setValue:obj.code forKey:@"code"];
        [newManagedObject setValue:obj.regCount forKey:@"regCount"];    // regCount를 1로 설정!
        // ???: newManagedObject = obj;
        
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
        self.sbCount = [self searchObjet:obj];
        
        Debug(@"\n---------------------------------------------------------------\
              \nStock code: %@\
              \nCurrent regCount: %@\
              \n---------------------------------------------------------------", self.sbCount.code, self.sbCount.regCount);
        
        // 업데이트: regCount 증가(+1).
        [self updateObject:self.sbCount withType:SBRegCountIncrease];
        
        [LPUtils showAlert:LPAlertTypeFirst andTag:0 withTitle:@"알림" andMessage:@"이미 등록된 SB 입니다."];
    }
    
}

// 수정: regCount의 값을 1 증가시킨다.
- (void)updateObject:(SBCount *)obj withType:(int)type
{
    int cnt = 0;
    self.updateObject = [[SBCount alloc] init];
    if (type == SBRegCountIncrease) 
    {
        // +1 증가.
        cnt = [obj.regCount intValue] + 1;
        self.updateObject = [self searchObjet:obj];
        self.updateObject.regCount = [NSNumber numberWithInt:cnt];
    }
    else
    {
        // -1 감소.
        cnt = [obj.regCount intValue] - 1;
        self.updateObject = [self searchObjet:obj];
        self.updateObject.regCount = [NSNumber numberWithInt:cnt];
    }
    
    Debug(@"\n---------------------------------------------------------------\
          \nStock code: %@\
          \nUpdated regCount: %@\
          \n---------------------------------------------------------------", updateObject.code, updateObject.regCount);
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    // 컨텍스트 저장.
    NSError *error = nil;
    if (![context save:&error])
    {
        // TODO: 에러 처리.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// 삭제: regCount 값에 따라 실제로 객체를 삭제하거나, regCount의 값을 -1 감소 시킨다.
- (void)deleteObject:(SBCount *)obj 
{
    self.sbCount = [self searchObjet:obj];
    
    if ([self.sbCount.regCount intValue] > 0) 
    {
        // -1 감소.
        [self updateObject:self.sbCount withType:SBRegCountDecrease];
    }
    else
    {
        // 관리 객체 컨텍스트에서 해당 객체 삭제.
        [self.managedObjectContext deleteObject:self.sbCount];
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
        // 컨텍스트 저장.
        NSError *error = nil;
        if (![context save:&error])
        {
            // TODO: 에러 처리.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// 검색.
- (SBCount *)searchObjet:(SBCount *)obj
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"SBCount" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // SBCount 엔티티(테이블)의 trCode, idx, code가 PK이다.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trCode == %@) AND (idx == %@) AND (code == %@)", obj.trCode, obj.idx, obj.code];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) 
    {
        NSUInteger count = [array count]; 
        // 만약 count == 0 이면 객체가 삭제된 것이다.
        Debug(@"Searched count: %d", count);
        
        if (count > 0) 
        {
            // 객체가 하나라는 보장이 되어야 함!
            return [array lastObject];
        }
        else
        {
            return nil;
        }
    }
    else 
    {
        // TODO: 에러 치러!
        return nil;
    }
}

// 확인.
- (SBCount *)isObjectExistence:(SBCount *)obj 
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"SBCount" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // SBCount 엔티티(테이블)은 trCode, idx, code가 PK이다.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trCode == %@) AND (idx == %@) AND (code == %@)", obj.trCode, obj.idx, obj.code];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) 
    {
        NSUInteger count = [array count]; 
        // 만약 count == 0 이면 객체가 삭제된 것이다.
        Debug(@"Searched count: %d", count);
        
        if (count > 0) 
        {
            // 객체가 하나라는 보장이 되어야 함!
            return [array lastObject];
        }
        else
        {
            return nil;
        }
    }
    else 
    {
        // TODO: 에러 치러!
        return nil;
    }
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

// TODO: 화면(테이블뷰 등)과 연계 하여 사용할 경우 정리 필요함!
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
